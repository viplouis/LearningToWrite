CREATE DEFINER=`yz_dev`@`%` PROCEDURE `activeCustomer`(
	IN storeId VARCHAR(20),
	IN startDate DATETIME,
  IN endDate DATETIME,
	OUT once INT,
	OUT twice INT,
	OUT repeatedly INT
)
BEGIN
	#Routine body goes here...
	
	CREATE TEMPORARY TABLE IF NOT EXISTS temp_customer_views(visitor_id VARCHAR(20),views INT);
	TRUNCATE TABLE temp_customer_views;

		SET @tableName = CONCAT("sys_store_log_",storeId);
		
		SET @sqlStrTemp = CONCAT("INSERT INTO temp_customer_views(visitor_id,views) SELECT visitor_id,count(*) as views FROM ", @tableName," WHERE create_date BETWEEN '",startDate,"' AND '",endDate,"' GROUP BY visitor_id");

    PREPARE stmtTemp from @sqlStrTemp;
    EXECUTE stmtTemp;
    DEALLOCATE PREPARE stmtTemp;  
		
		
		SELECT count(*) into once FROM temp_customer_views WHERE views > 1 && views < 2;
		SELECT count(*) into twice FROM temp_customer_views WHERE views >=2 && views < 3;
		SELECT count(*) into repeatedly FROM temp_customer_views WHERE views >= 3;

-- 			SELECT SUM(CASE WHEN views > 1 && views < 2 THEN 1 ELSE 0 END) as once, SUM(CASE WHEN views >=2 && views < 3 THEN 1 ELSE 0 END) as twice, 
-- 		SUM(CASE WHEN views >= 3 THEN 1 ELSE 0 END) as repeatedly FROM temp_customer_views;



END