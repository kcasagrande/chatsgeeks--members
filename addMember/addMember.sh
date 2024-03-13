#!/usr/bin/env sh

DEFAULT_FEE=1000
CURRENT_YEAR=$(date '+%Y')

options=$(getopt --options i:y:d:f: --longoptions id:,year:,date:,fee-in-cents:,force -- "$@")
eval set -- "$options"

while true; do
	case "${1}" in
		-i|--id)
			argId="${2}"
			shift 2
		;;
		-y|--year)
			argYear="${2}"
			shift 2
		;;
		-d|--date)
			argDate="${2}"
			shift 2
		;;
		-f|--fee-in-cents)
			argFee="${2}"
			shift 2
		;;
		--force)
			argForce=1
			shift
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
id="'${argId:?}'"
test -z "${argYear}" && echo "Note: year not set, assuming current year ${CURRENT_YEAR}."
year="${argYear:-${CURRENT_YEAR}}"
date="'${argDate:?}'"
test -z "${argFee}" && echo "Note: fee not set, assuming default amount $(( ${DEFAULT_FEE} / 100 )).$(( ${DEFAULT_FEE} % 100 ))€." >&2
fee="${argFee:-${DEFAULT_FEE}}"
test $(date '+%Y' --date "${argDate:?}") -ne ${year} && test -z "${argForce}" && { echo "Membership year does not match subscription date, please use --force to process anyway" >&2 ; exit 1 ; }

sqlite3 "${DATABASE}" <<- END
	.parameter set :id "${id}"
	.parameter set :year "${year}"
	.parameter set :inscription "${date}"
	.parameter set :fee "${fee}"

	.read "$(dirname "${0}")/addMember.sql"
END
