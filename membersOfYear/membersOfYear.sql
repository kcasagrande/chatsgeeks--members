SELECT
	HEX(`person`.`id`) AS `id`,
	`person`.`nickName`,
	`person`.`firstName`,
	`person`.`lastName`,
	`person`.`phone`,
	`person`.`email`,
	`membership`.`inscription`,
	`membership`.`amount` / 100.0 AS `fee`
FROM
	`person` INNER JOIN `membership` ON `membership`.`member`=`person`.`id`
WHERE
	`membership`.`year`=:year
AND
	(
		`person`.`death` IS NULL
	OR
		SUBSTRING(`person`.`death`, 1, 4)<=':year'
	)
;
