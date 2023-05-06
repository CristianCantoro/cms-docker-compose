#!/bin/bash -e
# shellcheck disable=SC2011

# bash strict mode
set -euo pipefail
IFS=$'\n\t'

case "${1}" in
    'build-all')
        echo '[case: build-all]'
    ;;
    'build-task')
        echo '[case: build-task]'
    ;;
    'build-testo')
        echo '[case: build-testo]'
    ;&
    'clean')
        echo '[case: clean]'
    ;;
    'help')
        echo '[case: help] Build CMS tasks.'
    ;;
    *)
        echo '[case: *] default'
    ;;
esac

exit 0
