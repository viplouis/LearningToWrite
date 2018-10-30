CREATE DEFINER=`root`@`%` PROCEDURE `adQueryProductsAdsReport`( 
    IN `userId` INT,
    IN `shopId` INT,
    IN `saleChannel` VARCHAR(20),
    IN startDate DATETIME,
    IN endDate DATETIME,
    IN userType VARCHAR(20),
    in selectElement VARCHAR(3000),
    IN selectWhere VARCHAR(3000),
    IN selectGroupby VARCHAR(3000),
		IN limitStr VARCHAR(3000),
		IN currentPage INT,
		IN pageSize INT,
    IN loginUserId INT
    )
BEGIN
    #临时表，判断这个用户是子账号，还是主账号
	CREATE TEMPORARY TABLE  IF NOT EXISTS temp_shopId_productads_report_data(shopId INT,parent_user_id INT,sale_channel VARCHAR(50) );
	TRUNCATE TABLE temp_shopId_productads_report_data;
	
	#主账号
	IF userType='PriAccount' THEN
		#准备工作，找到这个主账号的所有激活的店铺信息
		INSERT INTO temp_shopId_productads_report_data(shopId,parent_user_id)
		SELECT shop_id,user_id FROM  shop_info i  WHERE i.`state`='1' AND i.user_id=userId;
-- SELECT * FROM productads_report LIMIT 0,20; 
	END IF;
	#子账号
	IF userType='SubAccount' THEN
		INSERT INTO temp_shopId_productads_report_data(shopId,parent_user_id,sale_channel)
		SELECT i.shop_id,i.`user_ID`,sub.`sale_channel` FROM shop_info i INNER JOIN sub_user_authority sub ON i.`user_ID`=sub.`parent_user_id` AND i.`shop_Id`=sub.`shop_id` WHERE i.`user_ID`=userId AND i.`state`='1' AND sub.`user_id`=loginUserId;
-- SELECT * FROM productads_report LIMIT 0,20; 
	END IF; 
	
	IF userType='PriAccount' THEN
	
		SET @SQL_data1=CONCAT("SELECT ",selectElement," from productads_report WHERE productads_report.`user_id`=",userId);
		
-- 	SELECT * FROM productads_report LIMIT 0,20; 
		SET @SQL_data_count=CONCAT("SELECT count(1) totalCount from productads_report WHERE productads_report.`user_id`=",userId);
	 
	 ELSE
-- 	SELECT * FROM productads_report LIMIT 0,20; 
		SET @SQL_data1=CONCAT("SELECT ",selectElement," from productads_report 
		inner join temp_shopId_productads_report_data
		on productads_report.shop_id=temp_shopId_productads_report_data.shopId
		and productads_report.sale_channel=temp_shopId_productads_report_data.sale_channel  WHERE productads_report.`user_id`=",userId);
	
		SET @SQL_data_count=CONCAT("SELECT count(1) totalCount from productads_report
		inner join temp_shopId_productads_report_data
		on productads_report.shop_id=temp_shopId_productads_report_data.shopId
		and productads_report.sale_channel=temp_shopId_productads_report_data.sale_channel  WHERE productads_report.`user_id`=",userId);
	 END IF;
	 
	 SET @SQL_data2=CONCAT(" and if(",shopId,"=0",",1=1,productads_report.shop_id=",shopId,")");
	 
	SET @SQL_data3=CONCAT(" and if('",saleChannel,"'='zero'",",1=1,productads_report.sale_channel='",saleChannel,"') and ",selectWhere);
	 #SELECT  @SQL_data3;
-- SET @SQL_data7= CONCAT(" ad_group_name LIKE %精准%");
	SET @SQL_data4= CONCAT(" between '",startDate,"' and '", endDate,"'");
#	SELECT  @SQL_data5;
	SET @SQL_data5= CONCAT(" GROUP BY ",selectGroupby);
	#SELECT  CONCAT(@SQL_data1,@SQL_data2,@SQL_data3,@SQL_data4,@SQL_data4);
	SET @SQL_data6= CONCAT(" LIMIT ",limitStr);
	SET @finalSql_data = CONCAT(@SQL_data1,@SQL_data2,@SQL_data3,@SQL_data4,@SQL_data5,@SQL_data6);
	
	#SELECT @finalSql_data;


	PREPARE stmt FROM @finalSql_data;  
	EXECUTE stmt;

	 
	SET @finalSql_count = CONCAT(@SQL_data_count,@SQL_data2,@SQL_data3,@SQL_data4,@SQL_data5);
	PREPARE stmt1 FROM @finalSql_count;  
	EXECUTE stmt1;
	 
	 
    END