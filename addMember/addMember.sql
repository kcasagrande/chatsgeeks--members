INSERT INTO `membership`(
	`member`,
	`year`,
	`inscription`,
	`amount`
) SELECT
	`id`,
	:year,
	:inscription,
	:fee
FROM
	`person`
WHERE
	HEX(`id`)=:id
;
SELECT CHANGES()||' rows inserted.';
