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
	local afile
	if [ -f "$afile" ]; then
		critical "File $afile exists, I will not overwrite it. Exiting."
		exit 1
	fi
}

die_if_file_exists '.env'
cp '.env.sample' '.env'

die_if_file_exists 'docker/cms-services/configs/cms.conf'
cp 'docker/cms-services/configs/cms.conf.sample' 'docker/cms-services/configs/cms.conf'

die_if_file_exists 'docker/cms-services/configs/cms.ranking.conf'
cp 'docker/cms-services/configs/cms.ranking.conf.sample' 'docker/cms-services/configs/cms.ranking.conf'

export CMS_INIT=true
export CMS_IMPORT_CONTEST=true

docker compose build

docker compose up

