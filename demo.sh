#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

# script directory
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
SCRIPTDIR="$(realpath "$SCRIPTDIR")"

#################### help utils
function check_dir() {
  local adir="$1"

  if [[ ! -d "$adir" ]]; then
    (>&2 echo "$adir is not a valid directory.")
    exit 1
  fi
}
#################### end: help utils

#################### help
function short_usage() {
  (>&2 echo \
"Usage:
  $(basename "$0") [-d] [-b BASEDIR]
  $(basename "$0") [-d] -t
  $(basename "$0") -h")
}

function usage() {
  (>&2 short_usage )
  (>&2 echo \
"
Run a demo of CMS with docker compose.

Options:
  -b BASEDIR    	Base directory where to run the demo [default: .].
  -d            	Enable debug output.
  -t            	Use a temporary directory as base directory.
  -h            	Show this help and exits.

Example:
  $(basename "$0")
")
}

debug=false
basedir_flag=false
help_flag=false
temp_flag=false
BASEDIR="$(realpath '.')"

while getopts ":b:dht" opt; do
  case $opt in
    b)
			basedir_flag=true
      check_dir "$OPTARG"
      BASEDIR="$OPTARG"
      ;;
    d)
      debug=true
      ;;
    h)
      help_flag=true
      ;;
    t)
      temp_flag=true
      ;;
    \?)
      (>&2 echo "Error. Invalid option: -$OPTARG")
      exit 1
      ;;
    :)
      (>&2 echo "Error.Option -$OPTARG requires an argument.")
      exit 1
      ;;
  esac
done

if $help_flag; then
  usage
  exit 0
fi
#################### end: help

#################### utils
# define ANSI escape codes
# -- bold_yellow="\033[1;33m"
bold_red="\033[1;31m"
bold_yellow="\033[1;31m"
reset="\033[0m"

if $debug; then
  function echodebug() {
    debugfmt="${bold_yellow}$(date "+%Y-%m-%d %H:%M:%S") [DEBUG]${reset}\t"
    (echo -e "${debugfmt}" "$@" 1>&2 >&2)
  }
else
  function echodebug() { true; }
fi

function echocritical() {
	critfmt="${bold_red}$(date "+%Y-%m-%d %H:%M:%S") [CRITICAL]${reset}\t"
	(echo -e "${critfmt}" "$@" >&2)
}

function die_if_file_exists() {
	local afile="$1"

	if [ -f "$afile" ]; then
		echocritical "File $afile exists, I will not overwrite it. Exiting."
		exit 1
	fi
}

if $temp_flag; then
	tmpdir=$(mktemp -d -t tmp.cms-demo.XXXXXXXXXX)
	function finish {
	  rm -rf "$tmpdir"
	}
	trap finish EXIT
fi
#################### end: utils

if $basedir_flag && $temp_flag; then
	echocritical "Options -b and -t are mutually exclusive."
	exit 1
fi

if $temp_flag; then
	BASEDIR="$(realpath "$tmpdir")"
fi

basedir_path="$(realpath "$BASEDIR")"
scriptdir_path="$(realpath "$SCRIPTDIR")"
# cms_config_dir_path="$(realpath "${BASEDIR}/docker/cms-services/configs")"
if [ ! "$basedir_path" -ef "$scriptdir_path" ]; then
	rsync -r -l \
	      --exclude='.git' \
	      --exclude='.env' \
	      --exclude='cms.conf' \
	      --exclude='cms.ranking.conf' \
	        "${scriptdir_path}/" "${basedir_path}/"
fi

die_if_file_exists "${BASEDIR}/.env"
cp ".env.sample" "${BASEDIR}/.env"

cms_config_dir="${BASEDIR}/docker/cms-services/configs"

die_if_file_exists "${cms_config_dir}/cms.conf"
cp "${cms_config_dir}/cms.conf.sample" \
     "${cms_config_dir}/cms.conf"

die_if_file_exists "${cms_config_dir}/cms.ranking.conf"
cp "${cms_config_dir}/cms.ranking.conf.sample" \
     "${cms_config_dir}/cms.ranking.conf"

# set_default_if_unset
export CMS_MAKE_TASK=${CMS_MAKE_TASK=true}
export CMS_INIT=${CMS_INIT=true}
export CMS_IMPORT_CONTEST=${CMS_IMPORT_CONTEST=contest}

echodebug "CMS_MAKE_TASK: $CMS_MAKE_TASK"
echodebug "CMS_INIT: $CMS_INIT"
echodebug "CMS_IMPORT_CONTEST: $CMS_IMPORT_CONTEST"

echo "Running the demo in $BASEDIR"

if [[ -n "${CMS_IMPORT_CONTEST+x}" ]] && check_dir "$CMS_IMPORT_CONTEST"; then
	docker compose \
	  run -v "$CMS_IMPORT_CONTEST":/home/cmsuser/contest taskbuilder
fi

# docker compose build

# docker compose up

exit 0
