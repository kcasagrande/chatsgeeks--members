#!/usr/bin/env sh

options=$(getopt --options y: --longoptions year: -- "$@")
eval set -- "$options"

while true; do
	case "${1}" in
		-y|--year)
			argYear="${2}"
			shift 2
		;;
		--)
			shift
			break
		;;
		*)
			break
		;;
	esac
done

DATABASE="${1}"
year="'${argYear:?}'"

sqlite3 -readonly -table "${DATABASE}" <<- END
	.parameter set :year ${year}

	.read "$(dirname "${0}")/membersOfYear.sql"
END
