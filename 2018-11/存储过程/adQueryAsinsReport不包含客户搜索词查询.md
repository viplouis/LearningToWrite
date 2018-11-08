CREATE DEFINER=`root`@`%` PROCEDURE `adQueryAsinsReport`( 
    IN `userId` INT,
    IN `shopId` INT,
    IN `saleChannel` VARCHAR(20),
    IN startDate DATETIME,
    IN endDate DATETIME,
    IN userType VARCHAR(20),
-- 		IN firstDimension VARCHAR(30),
-- 		IN secondDimension VARCHAR(30),
    in selectElement VARCHAR(3000),
    IN selectWhere VARCHAR(3000),
    IN selectGroupby VARCHAR(3000),
		IN selectOrderby VARCHAR(1000),
		IN limitStr VARCHAR(3000),
-- 		IN currentPage INT,
-- 		IN pageSize INT,
    IN loginUserId INT
    )
BEGIN
    #临时表，判断这个用户是子账号，还是主账号
	CREATE TEMPORARY TABLE  IF NOT EXISTS temp_shopId_asins_report_data(shopId INT,parent_user_id INT,sale_channel VARCHAR(50) );
	TRUNCATE TABLE temp_shopId_asins_report_data;

	
	CREATE TEMPORARY TABLE  IF NOT EXISTS `temp_asins_report` (
  `shop_id` int(11) NOT NULL,
  `sale_channel` varchar(50) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `campaign_type` varchar(50) DEFAULT NULL COMMENT '查询参数字段',
  `segment` varchar(30) DEFAULT NULL COMMENT '查询参数字段',
  `report_date` date NOT NULL COMMENT '查询参数字段',
  `campaign_id` varchar(50) NOT NULL,
  `campaign_name` varchar(50) DEFAULT NULL,
  `ad_group_id` varchar(50) NOT NULL,
  `ad_group_name` varchar(50) DEFAULT NULL,
  `keyword_id` varchar(30) NOT NULL,
	`query` varchar(255) NOT NULL,
  `keyword_text` varchar(100) DEFAULT NULL,
  `asin` varchar(50) NOT NULL,
  `other_asin` varchar(50) NOT NULL,
  `sku` varchar(50) NOT NULL,
  `match_type` varchar(50) DEFAULT NULL,
  `currency` varchar(10) DEFAULT NULL,
  `attributedSales1dOtherSKU` decimal(11,2) DEFAULT NULL,
  `attributedSales7dOtherSKU` decimal(11,2) DEFAULT NULL,
  `attributedSales14dOtherSKU` decimal(11,2) DEFAULT NULL,
  `attributedSales30dOtherSKU` decimal(11,2) DEFAULT NULL,
  `attributedUnitsOrdered1dOtherSKU` decimal(11,2) DEFAULT NULL,
  `attributedUnitsOrdered7dOtherSKU` decimal(11,2) DEFAULT NULL,
  `attributedUnitsOrdered14dOtherSKU` decimal(11,2) DEFAULT NULL,
  `attributedUnitsOrdered30dOtherSKU` decimal(11,2) DEFAULT NULL,
  `synchronised_time` datetime DEFAULT NULL COMMENT '入数据库北京时间',
  `is_delete` varchar(2) DEFAULT NULL COMMENT '是否假删除',
  `site_local_date` datetime DEFAULT NULL COMMENT '站点当地时间',
  `remarks` varchar(100) DEFAULT NULL COMMENT '数据操作备注',
  PRIMARY KEY (`shop_id`,`sale_channel`,`report_date`,`campaign_id`,`ad_group_id`,`keyword_id`,`asin`,`other_asin`,`sku`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;
	TRUNCATE TABLE temp_asins_report;
	
	
	
	
	#主账号
	IF userType = 'PriAccount' THEN
		#准备工作，找到这个主账号的所有激活的店铺信息
		INSERT INTO temp_shopId_asins_report_data(shopId,parent_user_id)
		SELECT shop_id,user_id FROM  shop_info i  WHERE i.`state`='1' AND i.user_id=userId;

	END IF;
	#子账号
	IF userType = 'SubAccount' THEN
		INSERT INTO temp_shopId_asins_report_data(shopId,parent_user_id,sale_channel)
		SELECT i.shop_id,i.`user_ID`,sub.`sale_channel` FROM shop_info i INNER JOIN sub_user_authority sub ON i.`user_ID`=sub.`parent_user_id` AND i.`shop_Id`=sub.`shop_id` WHERE i.`user_ID`=userId AND i.`state`='1' AND sub.`user_id`=loginUserId;

	END IF; 
	
	IF userType = 'PriAccount' THEN
	
		SET @SQL_data1 = CONCAT("SELECT ",selectElement," from asins_report WHERE asins_report.`user_id`=",userId);
		
-- 	SELECT * FROM asins_report LIMIT 0,20; 
		SET @SQL_data_count = CONCAT("SELECT count(1) totalCount from asins_report WHERE asins_report.`user_id`=",userId);
	 
	 ELSE
-- 	SELECT * FROM asins_report LIMIT 0,20; 
		SET @SQL_data1 = CONCAT("SELECT ",selectElement," from asins_report 
		inner join temp_shopId_asins_report_data
		on asins_report.shop_id=temp_shopId_asins_report_data.shopId
		and asins_report.sale_channel=temp_shopId_asins_report_data.sale_channel  WHERE asins_report.`user_id`=",userId);
	
		SET @SQL_data_count = CONCAT("SELECT count(1) totalCount from asins_report
		inner join temp_shopId_asins_report_data
		on asins_report.shop_id=temp_shopId_asins_report_data.shopId
		and asins_report.sale_channel=temp_shopId_asins_report_data.sale_channel  WHERE asins_report.`user_id`=",userId);
	 END IF;
	 
	 SET @SQL_data2 = CONCAT(" and if(",shopId,"=0",",1=1,asins_report.shop_id=",shopId,")");
	 
	SET @SQL_data3 = CONCAT(" and if('",saleChannel,"'='zero'",",1=1,asins_report.sale_channel='",saleChannel,"') and ",selectWhere);
	 #SELECT  @SQL_data3;

	SET @SQL_data4 = CONCAT(" AND asins_report.`report_date` between '",startDate,"' and '", endDate,"'");
#	SELECT  @SQL_data5;
	SET @SQL_data5 = CONCAT(" GROUP BY ",selectGroupby);
	#SELECT  CONCAT(@SQL_data1,@SQL_data2,@SQL_data3,@SQL_data4,@SQL_data4);
	SET @SQL_data6 = CONCAT(" LIMIT ",limitStr);

	SET @SQL_data7 = CONCAT(" ORDER BY ",selectOrderby);
	 #SELECT @SQL_data7;

	IF selectOrderby = 'blank' THEN
	
		SET @finalSql_data = CONCAT(@SQL_data1,@SQL_data2,@SQL_data3,@SQL_data4,@SQL_data5,@SQL_data6);
	 ELSE
		SET @finalSql_data = CONCAT(@SQL_data1,@SQL_data2,@SQL_data3,@SQL_data4,@SQL_data5,@SQL_data7,@SQL_data6);
	 END IF;

	PREPARE stmt FROM @finalSql_data;  
	EXECUTE stmt;
	 
	SET @finalSql_count = CONCAT(@SQL_data_count,@SQL_data2,@SQL_data3,@SQL_data4,@SQL_data5);
	PREPARE stmt1 FROM @finalSql_count;  
	EXECUTE stmt1;
	 
	 
    END