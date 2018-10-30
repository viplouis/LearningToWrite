CREATE DEFINER=`root`@`%` PROCEDURE `getOrderSummaryDataProc`( 
    IN userId INT,
    IN shopId INT,
    IN saleChannel VARCHAR(20),
    IN startDate DATETIME,
    IN endDate DATETIME,
    IN timeDimension VARCHAR(20),
    IN userType VARCHAR(20),
    in selectElement VARCHAR(5000),
    IN selectWhere VARCHAR(300),
    IN selectGroupby VARCHAR(300),
    IN limit1 int,
    IN offset1 INT,
    IN loginUserId INT
    )
BEGIN
    #临时表，判断这个用户是子账号，还是主账号
	CREATE TEMPORARY TABLE  IF NOT EXISTS temp_shopId_order_summary_data(shopId INT,parent_user_id INT,sale_channel VARCHAR(50) );
	TRUNCATE TABLE temp_shopId_order_summary_data;
	
	#主账号
	IF userType='PriAccount' THEN
		#准备工作，找到这个主账号的所有激活的店铺信息
		INSERT INTO temp_shopId_order_summary_data(shopId,parent_user_id)
		SELECT shop_id,user_id FROM  shop_info i  WHERE i.`state`='1' AND i.user_id=userId;
	END IF;
	#子账号
	IF userType='SubAccount' THEN
		INSERT INTO temp_shopId_order_summary_data(shopId,parent_user_id,sale_channel)
		SELECT i.shop_id,i.`user_ID`,sub.`sale_channel` FROM shop_info i INNER JOIN sub_user_authority sub ON i.`user_ID`=sub.`parent_user_id` AND i.`shop_Id`=sub.`shop_id` WHERE i.`user_ID`=userId AND i.`state`='1' AND sub.`user_id`=loginUserId;
	END IF; 
	
	IF userType='PriAccount' THEN
	
		SET @SQL_data1=CONCAT("SELECT ",selectElement," from order_summary WHERE order_summary.`user_id`=",userId);
		
	
		SET @SQL_data_count=CONCAT("SELECT count(1) totalCount from order_summary WHERE order_summary.`user_id`=",userId);
	 
	 ELSE
	 
		SET @SQL_data1=CONCAT("SELECT ",selectElement," from order_summary
		inner join temp_shopId_order_summary_data
		on order_summary.shop_id=temp_shopId_order_summary_data.shopId
		and order_summary.sale_channel=temp_shopId_order_summary_data.sale_channel  WHERE order_summary.`user_id`=",userId);
	
		SET @SQL_data_count=CONCAT("SELECT count(1) totalCount from order_summary
		inner join temp_shopId_order_summary_data
		on order_summary.shop_id=temp_shopId_order_summary_data.shopId
		and order_summary.sale_channel=temp_shopId_order_summary_data.sale_channel  WHERE order_summary.`user_id`=",userId);
	 END IF;
	 
	 SET @SQL_data2=CONCAT(" and if(",shopId,"=0",",1=1,order_summary.shop_id=",shopId,")");
	# SELECT  @SQL_data2;
	SET @SQL_data3=CONCAT(" and if('",saleChannel,"'='zero'",",1=1,order_summary.sale_channel='",saleChannel,"') and ",selectWhere);
	# SELECT  @SQL_data3;
	SET @SQL_data4 = CONCAT(" and order_summary.",timeDimension);
	#SELECT  @SQL_data4;
	SET @SQL_data5= CONCAT(" between '",startDate,"' and '", endDate,"'");
	#SELECT  @SQL_data5;
	SET @SQL_data6= CONCAT(" GROUP BY ",selectGroupby);
	select @SQL_data6;
	#SELECT  @SQL_data6;
	SET @finalSql_data = CONCAT(@SQL_data1,@SQL_data2,@SQL_data3,@SQL_data4,@SQL_data5,@SQL_data6);
	#SELECT  @finalSql_data;
	PREPARE stmt FROM @finalSql_data;  
	 EXECUTE stmt;
	 
		 
	
	 
	 SET @finalSql_count = CONCAT(@SQL_data_count,@SQL_data2,@SQL_data3,@SQL_data4,@SQL_data5);
	PREPARE stmt1 FROM @finalSql_count;  
	 EXECUTE stmt1;
	 
	 
    END