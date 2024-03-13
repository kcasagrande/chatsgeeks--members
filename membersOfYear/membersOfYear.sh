#!/usr/bin/env sh

DATABASE="${1}"
YEAR="${2}"

sqlite3 -readonly -table "${DATABASE}" <<- END
	.parameter set :year ${YEAR}

	.read "$(dirname "${0}")/membersOfYear.sql"
END

