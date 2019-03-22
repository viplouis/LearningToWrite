CREATE DEFINER=`yz_developer`@`%` PROCEDURE `getSalesData`(
	IN `startDate` DATETIME,
	IN `endDate` DATETIME,
	IN `orgIds` VARCHAR(500)
)
BEGIN
	#Routine body goes here...

	CREATE TEMPORARY TABLE IF NOT EXISTS snapshot_day(tem_date DATETIME,num INT);
	TRUNCATE TABLE snapshot_day;

-- 修改临时表日期时间段
		WHILE startDate<endDate DO
		INSERT INTO snapshot_day(tem_date) 
		SELECT DATE_FORMAT(startDate,'%Y-%m-%d');
		SET startDate = DATE_FORMAT(DATE_ADD(startDate,INTERVAL 1 day),'%Y-%m-%d');
	END WHILE;
			
		SELECT DATE_FORMAT( snapshot_day.tem_date,"%Y-%m-%d") snapshotDate,
		IF(t.num IS NULL,0,t.num) salesNum
		FROM
		snapshot_day LEFT JOIN 
		(SELECT DATE_FORMAT(reserve_order.`reserve_time`,"%Y-%m-%d") snapshot_date,count(*) as num
	
		FROM  reserve_order 
		WHERE
			FIND_IN_SET(
		reserve_order.operator_id,orgIds)
		GROUP BY snapshot_date)
		t
		ON  DATE_FORMAT(snapshot_day.tem_date,"%Y-%m-%d") = t.snapshot_date;

END
