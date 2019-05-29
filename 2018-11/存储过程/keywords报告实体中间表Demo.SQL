CREATE DEFINER=`root`@`%` PROCEDURE `adQueryKeywordsIntermediateReport`(
	IN `userId` INT,
	IN `shopId` INT,
  IN `saleChannel` VARCHAR(20),
  IN startDate DATETIME,
  IN endDate DATETIME,
  IN userType VARCHAR(20),
-- 		IN firstDimension VARCHAR(30),
-- 		IN secondDimension VARCHAR(30),
  IN selectElement VARCHAR(3000),
  IN selectWhere VARCHAR(3000),
  IN selectGroupby VARCHAR(3000),
	IN selectOrderby VARCHAR(1000),
	IN limitStr VARCHAR(3000),
-- 		IN currentPage INT,
-- 		IN pageSize INT,
   IN loginUserId INT
		)
BEGIN
	#Routine body goes here...
-- 	Truncate Table temp_keywords_report;
	#临时表，判断这个用户是子账号，还是主账号
	CREATE TEMPORARY TABLE  IF NOT EXISTS temp_shopId_keywords_report_data(shopId INT,parent_user_id INT,sale_channel VARCHAR(50) );
	TRUNCATE TABLE temp_shopId_keywords_report_data;
	TRUNCATE TABLE temp_keywords_report ;
	
	CREATE TEMPORARY TABLE  IF NOT EXISTS `temp_shopId_keywords_report_temporary` (
  `shop_id` int(11) NOT NULL,
  `sale_channel` varchar(255) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `campaign_type` varchar(255) DEFAULT NULL COMMENT '查询参数字段',
  `segment` varchar(255) DEFAULT NULL COMMENT '查询参数字段',
  `report_date` date NOT NULL COMMENT '查询参数字段',
  `ad_group_id` varchar(20) NOT NULL,
  `ad_group_name` varchar(30) DEFAULT NULL,
  `keyword_id` varchar(50) NOT NULL DEFAULT '',
  `campaign_id` varchar(50) NOT NULL,
  `campaign_name` varchar(255) DEFAULT NULL,
  `impressions` int(11) DEFAULT NULL,
  `currency` varchar(255) DEFAULT NULL,
  `cost` decimal(11,2) DEFAULT NULL,
  `CTR` decimal(11,2) DEFAULT NULL,
  `CPC` decimal(11,2) DEFAULT NULL,
  `CPM` decimal(11,2) DEFAULT NULL,
  `ACOS` decimal(11,2) DEFAULT NULL,
  `CPA` decimal(11,2) DEFAULT NULL,
  `matchType` varchar(255) DEFAULT NULL,
  `query` varchar(255) NOT NULL,
  `keywordText` varchar(255) DEFAULT NULL,
  `clicks` int(11) DEFAULT NULL,
  `attributed_sales7d` decimal(11,2) DEFAULT NULL,
  `attributed_units_ordered7d` decimal(11,2) DEFAULT NULL,
  `attributed_conversions7d` decimal(11,2) DEFAULT NULL,
  `attributed_sales7d_sameSKU` decimal(11,2) DEFAULT NULL,
  `attributed_conversions7d_sameSKU` decimal(11,2) DEFAULT NULL,
  `synchronised_time` datetime DEFAULT NULL COMMENT '入数据库时间',
  `is_delete` varchar(255) DEFAULT NULL,
  `site_local_date` datetime DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`shop_id`,`sale_channel`,`report_date`,`ad_group_id`,`keyword_id`,`campaign_id`,`query`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;
	TRUNCATE TABLE temp_shopId_keywords_report_temporary;
	
	#主账号
	IF userType = 'PriAccount' THEN
		#准备工作，找到这个主账号的所有激活的店铺信息
		INSERT INTO temp_shopId_keywords_report_data(shopId,parent_user_id)
		SELECT shop_id,user_id FROM  shop_info i  WHERE i.`state`='1' AND i.user_id=userId;

	END IF;
	#子账号
	IF userType = 'SubAccount' THEN
		INSERT INTO temp_shopId_keywords_report_data(shopId,parent_user_id,sale_channel)
		SELECT i.shop_id,i.`user_ID`,sub.`sale_channel` FROM shop_info i INNER JOIN sub_user_authority sub ON i.`user_ID`=sub.`parent_user_id` AND i.`shop_Id`=sub.`shop_id` WHERE i.`user_ID`=userId AND i.`state`='1' AND sub.`user_id`=loginUserId;

	END IF; 


	#迁移数据
-- 	IF(impressions IS 0,0,clicks/impressions)
-- 	IF(impressions IS 0,0,cost/impressions*1000)
-- 	IF(clicks IS 0,0,cost/clicks)
-- 	IF(attributed_sales7d IS 0,0,cost/attributed_sales7d)
-- 	IF(clicks IS 0,0,attributed_units_ordered7d/clicks)
	
	SET @SelectSourceField = CONCAT(" shop_id,","sale_channel,","user_id,","campaign_type,","segment,","report_date,","ad_group_id,","ad_group_name,","keyword_id,","campaign_id,",
	"campaign_name,","impressions,","currency,","cost,","matchType,","query,","keywordText,","clicks,","attributed_sales7d,","attributed_units_ordered7d,","attributed_conversions7d,",
	"attributed_sales7d_sameSKU,","attributed_conversions7d_sameSKU,","synchronised_time,","is_delete,","site_local_date,","remarks,","IF(impressions = 0,0,clicks/impressions) AS CTR,","IF(impressions = 0,0,cost/impressions*1000) AS CPM,","IF(clicks = 0,0,cost/clicks) AS CPC,","IF(attributed_sales7d = 0,0,cost/attributed_sales7d) AS ACOS,","IF(clicks = 0,0,attributed_units_ordered7d/clicks) AS CPA");
	
	IF userType = 'PriAccount' THEN
	
		SET @SQL_data1 = CONCAT("SELECT ",@SelectSourceField," from keywords_report WHERE keywords_report.`user_id`=",userId);
	 
	 ELSE
		
		SET @SQL_data1 = CONCAT("SELECT ",'*'," from keywords_report 
		inner join temp_shopId_keywords_report_data
		on keywords_report.shop_id=temp_shopId_keywords_report_data.shopId
		and keywords_report.sale_channel=temp_shopId_keywords_report_data.sale_channel  WHERE keywords_report.`user_id`=",userId);
	 END IF;

	SET @SQL_data2 = CONCAT(" and if(",shopId,"=0",",1=1,keywords_report.shop_id=",shopId,")");
	 
	SET @SQL_data3 = CONCAT(" and if('",saleChannel,"'='zero'",",1=1,keywords_report.sale_channel='",saleChannel,"') and ",selectWhere);
	 #SELECT  @SQL_data3;

	SET @SQL_data4 = CONCAT(" AND keywords_report.`report_date`  between '",startDate,"' and '", endDate,"'");


-- 		SET @SQL_data5 = CONCAT("insert into temp_keywords_report ",@SQL_data1,@SQL_data2,@SQL_data3,@SQL_data4);
	SET @DestinationField = CONCAT(" (","shop_id,","sale_channel,","user_id,","campaign_type,","segment,","report_date,","ad_group_id,","ad_group_name,","keyword_id,","campaign_id,",
	"campaign_name,","impressions,","currency,","cost,","matchType,","query,","keywordText,","clicks,","attributed_sales7d,","attributed_units_ordered7d,","attributed_conversions7d,",
	"attributed_sales7d_sameSKU,","attributed_conversions7d_sameSKU,","synchronised_time,","is_delete,","site_local_date,","remarks,","CTR,","CPM,","CPC,","ACOS,","CPA",") ");
	
	
	SET @finalSql_data_temp = CONCAT("insert into temp_keywords_report ",@DestinationField,@SQL_data1,@SQL_data2,@SQL_data3,@SQL_data4);
	
	#SELECT @finalSql_data_temp;

	PREPARE stmt FROM @finalSql_data_temp;  
	EXECUTE stmt;
	
	
		#重新查询
		
		#临时表，判断这个用户是子账号，还是主账号
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
	
		SET @SQL_data12=CONCAT("SELECT ",selectElement," from temp_keywords_report WHERE temp_keywords_report.`user_id`=",userId);
		
-- 	SELECT * FROM keywords_report LIMIT 0,20; 
		SET @SQL_data_count2=CONCAT("SELECT count(1) totalCount from temp_keywords_report WHERE temp_keywords_report.`user_id`=",userId);
	 
	 ELSE
-- 	SELECT * FROM keywords_report LIMIT 0,20; 
		SET @SQL_data12=CONCAT("SELECT ",selectElement," from temp_keywords_report 
		inner join temp_shopId_keywords_report_data
		on temp_keywords_report.shop_id=temp_shopId_keywords_report_data.shopId
		and temp_keywords_report.sale_channel=temp_shopId_keywords_report_data.sale_channel  WHERE temp_keywords_report.`user_id`=",userId);
	
		SET @SQL_data_count2=CONCAT("SELECT count(1) totalCount from temp_keywords_report
		inner join temp_shopId_keywords_report_data
		on temp_keywords_report.shop_id=temp_shopId_keywords_report_data.shopId
		and temp_keywords_report.sale_channel=temp_shopId_keywords_report_data.sale_channel  WHERE temp_keywords_report.`user_id`=",userId);
	 END IF;
	 
	 SET @SQL_data22=CONCAT(" and if(",shopId,"=0",",1=1,temp_keywords_report.shop_id=",shopId,")");
	 
	SET @SQL_data32=CONCAT(" and if('",saleChannel,"'='zero'",",1=1,temp_keywords_report.sale_channel='",saleChannel,"') and ",selectWhere);
	 #SELECT  @SQL_data3;

	SET @SQL_data42= CONCAT(" AND temp_keywords_report.`report_date`  between '",startDate,"' and '", endDate,"'");
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
		
	

END