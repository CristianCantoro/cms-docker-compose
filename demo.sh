#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

critical() {
	# define ANSI escape codes
	# -- bold_yellow="\033[1;33m"
	bold_red="\033[1;31m"
	reset="\033[0m"
	crit="${bold_red}$(date "+%Y-%m-%d %H:%M:%S,%3N") [CRITICAL]${reset}\t"

	msg="$1"

	echo -e "${crit}${msg}" >&2
}

die_if_file_exists() {
	local afile="$1"

	if [ -f "$afile" ]; then
		critical "File $afile exists, I will not overwrite it. Exiting."
		exit 1
	fi
}

function check_dir() {
  local adir="$1"

  if [[ ! -d "$adir" ]]; then
    (>&2 echo "$adir is not a valid directory.")
    exit 1
  fi
}

# die_if_file_exists '.env'
# cp '.env.sample' '.env'

# die_if_file_exists 'docker/cms-services/configs/cms.conf'
# cp 'docker/cms-services/configs/cms.conf.sample' 'docker/cms-services/configs/cms.conf'

# die_if_file_exists 'docker/cms-services/configs/cms.ranking.conf'
# cp 'docker/cms-services/configs/cms.ranking.conf.sample' 'docker/cms-services/configs/cms.ranking.conf'

# set_default_if_unset
export CMS_MAKE_TASK=${CMS_MAKE_TASK=true}
export CMS_INIT=${CMS_INIT=true}
export CMS_IMPORT_CONTEST=${CMS_IMPORT_CONTEST=contest}

echo "CMS_MAKE_TASK: $CMS_MAKE_TASK"
echo "CMS_INIT: $CMS_INIT"
echo "CMS_IMPORT_CONTEST: $CMS_IMPORT_CONTEST"

if [[ -n "${CMS_IMPORT_CONTEST+x}" ]] && check_dir "$CMS_IMPORT_CONTEST"; then
	docker compose \
	  run -v "$CMS_IMPORT_CONTEST":/home/cmsuser/contest taskbuilder
fi

# docker compose build

# docker compose up

