#!/usr/bin/env sh

DATABASE="${1}"
YEAR="${2}"

sqlite3 -readonly "${DATABASE}" <<- END
	.parameter set :year ${YEAR}
	SELECT
		\`person\`.*,
		\`membership\`.\`inscription\`,
		\`membership\`.\`amount\`
	FROM
		\`person\` INNER JOIN \`membership\` ON \`membership\`.\`member\`=\`person\`.\`id\`
	WHERE
		\`membership\`.\`year\`=:year
	AND
		(
			\`person\`.\`death\` IS NULL
		OR
			SUBSTRING(\`person\`.\`death\`, 1, 4)<=':year'
		)
	;
END

