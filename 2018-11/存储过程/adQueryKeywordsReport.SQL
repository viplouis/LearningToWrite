		CREATE TEMPORARY TABLE  IF NOT EXISTS temp_shopId_keywords_report_data2(shopId INT,parent_user_id INT,sale_channel VARCHAR(50) );
	TRUNCATE TABLE temp_shopId_keywords_report_data2;
	
	#主账号
	IF userType='PriAccount' THEN
		#准备工作，找到这个主账号的所有激活的店铺信息
		INSERT INTO temp_shopId_keywords_report_data2(shopId,parent_user_id)
		SELECT shop_id,user_id FROM  shop_info i  WHERE i.`state`='1' AND i.user_id=userId;
-- SELECT * FROM keywords_report LIMIT 0,20; 
	END IF;
	#子账号
	IF userType='SubAccount' THEN
		INSERT INTO temp_shopId_keywords_report_data2(shopId,parent_user_id,sale_channel)
		SELECT i.shop_id,i.`user_ID`,sub.`sale_channel` FROM shop_info i INNER JOIN sub_user_authority sub ON i.`user_ID`=sub.`parent_user_id` AND i.`shop_Id`=sub.`shop_id` WHERE i.`user_ID`=userId AND i.`state`='1' AND sub.`user_id`=loginUserId;
-- SELECT * FROM keywords_report LIMIT 0,20; 
	END IF; 
	
	IF userType='PriAccount' THEN
	
				SET @SQL_data12=CONCAT("SELECT ",selectElementTemp," from temp_shopId_keywords_report_temporary WHERE temp_shopId_keywords_report_temporary.`user_id`=",userId);
		
-- 	SELECT * FROM keywords_report LIMIT 0,20; 
		SET @SQL_data_count2=CONCAT("SELECT count(1) totalCount from temp_shopId_keywords_report_temporary WHERE temp_shopId_keywords_report_temporary.`user_id`=",userId);
	 
	 ELSE
-- 	SELECT * FROM keywords_report LIMIT 0,20; 
		SET @SQL_data12=CONCAT("SELECT ",selectElementTemp," from temp_shopId_keywords_report_temporary 
		inner join temp_shopId_keywords_report_data2
		on temp_shopId_keywords_report_temporary.shop_id=temp_shopId_keywords_report_temporary.shopId
		and temp_shopId_keywords_report_temporary.sale_channel=temp_shopId_keywords_report_temporary.sale_channel  WHERE temp_shopId_keywords_report_temporary.`user_id`=",userId);
	
		SET @SQL_data_count2=CONCAT("SELECT count(1) totalCount from temp_shopId_keywords_report_temporary
		inner join temp_shopId_keywords_report_data2
		on temp_shopId_keywords_report_temporary.shop_id=temp_shopId_keywords_report_temporary.shopId
		and temp_shopId_keywords_report_temporary.sale_channel=temp_shopId_keywords_report_temporary.sale_channel  WHERE temp_shopId_keywords_report_temporary.`user_id`=",userId);
	 END IF;
	 
	 SET @SQL_data22=CONCAT(" and if(",shopId,"=0",",1=1,temp_shopId_keywords_report_temporary.shop_id=",shopId,")");
	 
	SET @SQL_data32=CONCAT(" and if('",saleChannel,"'='zero'",",1=1,temp_shopId_keywords_report_temporary.sale_channel='",saleChannel,"') and ",selectWhereTemp);
	 #SELECT  @SQL_data3;

	SET @SQL_data42= CONCAT(" AND temp_shopId_keywords_report_temporary.`report_date`  between '",startDate,"' and '", endDate,"'");
#	SELECT  @SQL_data5;
	SET @SQL_data52= CONCAT(" GROUP BY ",selectGroupby);
	#SELECT  CONCAT(@SQL_data1,@SQL_data2,@SQL_data3,@SQL_data4,@SQL_data4);
	SET @SQL_data62= CONCAT(" LIMIT ",limitStr);
	SET @SQL_data72 = CONCAT(" ORDER BY ",selectOrderby);
	
	
		IF selectOrderby = 'blank' THEN
	
		SET @finalSql_data = CONCAT(@SQL_data12,@SQL_data22,@SQL_data32,@SQL_data42,@SQL_data52,@SQL_data62);
	 ELSE
		SET @finalSql_data = CONCAT(@SQL_data12,@SQL_data22,@SQL_data32,@SQL_data42,@SQL_data52,@SQL_data72,@SQL_data62);
	 END IF;

	PREPARE stmt FROM @finalSql_data;  
	EXECUTE stmt;
	
	
	
	#SELECT @finalSql_data;
	 
	SET @finalSql_count = CONCAT(@SQL_data_count2,@SQL_data22,@SQL_data32,@SQL_data42,@SQL_data52);
	PREPARE stmt1 FROM @finalSql_count;  
	EXECUTE stmt1;