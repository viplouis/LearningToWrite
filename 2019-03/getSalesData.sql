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
			
	CREATE TEMPORARY TABLE IF NOT EXISTS snapshot_order_contract(order_id varchar(40),amount decimal(10,2),receipt_status char(1),sign_time DATE,operator_id varchar(15));
	TRUNCATE TABLE snapshot_order_contract;
			
			
		INSERT INTO snapshot_order_contract ( order_id, amount,  receipt_status, sign_time, operator_id )
    ( SELECT o.order_id, o.amount, o.receipt_status, o.sign_time, r.operator_id FROM order_contract o,reserve_order r WHERE o.order_id = r.Id );

			
		SELECT DATE_FORMAT( snapshot_day.tem_date,"%Y-%m-%d") snapshotDate,t.amountCount
		FROM
		snapshot_day LEFT JOIN 
		(SELECT DATE_FORMAT(sign_time,"%Y-%m-%d") snapshot_date,sum(amount) as amountCount
	
		FROM snapshot_order_contract
		WHERE
		receipt_status = 1 AND
			FIND_IN_SET(
		snapshot_order_contract.operator_id,orgIds)
		GROUP BY snapshot_date)
		t
		ON  DATE_FORMAT(snapshot_day.tem_date,"%Y-%m-%d") = t.snapshot_date;

END