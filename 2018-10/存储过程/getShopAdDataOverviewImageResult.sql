CREATE DEFINER=`admin`@`%` PROCEDURE `getShopAdDataOverviewImageResult`(
	IN `startDate` DATETIME,
	IN `endDate` DATETIME,
	IN `shopId` INT,
	IN `userId` INT,
	IN `loginUserId` INT,
	IN `saleChannel` VARCHAR(30),
	IN `userType` VARCHAR(30),
	IN `shopAdDataOverviewType` VARCHAR(30)
)
BEGIN
	#Routine body goes here...
	DECLARE startDate1 DATETIME DEFAULT NULL ;
	DECLARE endDate1  DATETIME DEFAULT NULL ;
	SELECT startDate INTO startDate1;
	SELECT endDate INTO endDate1;
	
  #临时表，判断这个用户是子账号，还是主账号
  CREATE TEMPORARY TABLE  IF NOT EXISTS temp_shopId_adDateView(shopId INT,parent_user_id INT,sale_channel VARCHAR(50) );
	TRUNCATE TABLE temp_shopId_adDateView;
	
	CREATE TEMPORARY TABLE  IF NOT EXISTS adDateView_day(date1 DATETIME,impressions INT,clicks INT,orders INT);
	TRUNCATE TABLE adDateView_day;

	#修改广告的时间
	WHILE startDate1<endDate1 DO
		INSERT INTO adDateView_day(date1) 
		SELECT DATE_FORMAT(startDate1,'%Y-%m-%d');
		SET startDate1=DATE_FORMAT(DATE_ADD(startDate1,INTERVAL 1 day),'%Y-%m-%d');
	END WHILE;
		
	#主账号
	IF userType='PriAccount' THEN
		#准备工作，找到这个主账号的所有激活的店铺信息
		INSERT INTO temp_shopId_adDateView(shopId,parent_user_id)
		SELECT shop_id,user_id FROM  shop_info i  WHERE i.`state`='1' AND i.user_id=userId;
	END IF;
	#子账号
	IF userType='SubAccount' THEN
		INSERT INTO temp_shopId_adDateView(shopId,parent_user_id,sale_channel)
		SELECT i.shop_id,i.`user_ID`,sub.`sale_channel` FROM shop_info i INNER JOIN sub_user_authority sub ON i.`user_ID`=sub.`parent_user_id` AND i.`shop_Id`=sub.`shop_id` WHERE i.`user_ID`=userId AND i.`state`='1' AND sub.`user_id`=loginUserId;
	END IF; 
	
	
	IF shopAdDataOverviewType = 'campaigns' THEN
	
		#找到这段时间的广告campaigns
		IF userType='PriAccount' THEN
-- 		SELECT impressions,clicks,attributed_units_ordered1d,DATE_FORMAT( site_local_date,"%Y-%m-%d") snapshotDate FROM campaigns_report WHERE shop_id = shopId AND sale_channel = saleChannel AND user_id = userId AND DATE_ADD(site_local_date,INTERVAL 1 DAY) >= startDate AND DATE_ADD(site_local_date,INTERVAL 1 DAY) <= endDate GROUP BY snapshotDate ;
			#主账号
		SELECT DATE_FORMAT( adDateView_day.date1,"%Y-%m-%d") snapshotDate,
		
-- 		IF(SUM(campaigns_report.`clicks`) IS NULL,0,SUM(campaigns_report.`clicks`)) clicks,
-- 		IF(SUM(campaigns_report.`impressions`) IS NULL,0,SUM(campaigns_report.`impressions`)) impressions,
-- 		IF(SUM(campaigns_report.`orders`) IS NULL,0,SUM(campaigns_report.`orders`)) orders
		
		IF(campaigns_report.`clicks` IS NULL,0,campaigns_report.`clicks`) clicks,
		IF(campaigns_report.`impressions` IS NULL,0,campaigns_report.`impressions`) impressions,
		IF(campaigns_report.`orders` IS NULL,0,campaigns_report.`orders`) orders
		
		
		FROM
		adDateView_day LEFT JOIN 
		(SELECT DATE_FORMAT(campaigns_report.`site_local_date`,"%Y-%m-%d") snapshot_date,
		
-- 		SUM(campaigns_report.`impressions`) impressions,
-- 		SUM(campaigns_report.`clicks`) clicks,
-- 		SUM(campaigns_report.`attributed_units_ordered1d`) orders
		
		campaigns_report.`impressions` impressions,
		campaigns_report.`clicks` clicks,
		campaigns_report.`attributed_units_ordered1d` orders
	
		FROM  campaigns_report 
		WHERE
		campaigns_report.`user_id`=userId
		AND IF(shopId=0,1=1,campaigns_report.`shop_id`=shopId) 
		AND IF(saleChannel is null,1=1,campaigns_report.`sale_channel`=saleChannel)
		GROUP BY snapshot_date)
		campaigns_report
		ON  DATE_FORMAT( adDateView_day.date1,"%Y-%m-%d") = campaigns_report.snapshot_date
		  GROUP BY snapshotDate ORDER BY snapshotDate;
		ELSE
		#子账号
			
		SELECT DATE_FORMAT( inventory_daily_day.date1,"%Y-%m-%d") snapshotDate,IF(SUM(inventory_summary_temp.`quantity`) IS NULL,0,SUM(inventory_summary_temp.`quantity`))quantity FROM
			inventory_daily_day LEFT JOIN 
			(SELECT DATE_FORMAT(inventory_summary.`snapshot_date`,"%Y-%m-%d") snapshot_date,SUM(inventory_summary.`quantity`) quantity FROM  inventory_summary 
			INNER JOIN temp_shopId_inventory_daily ON temp_shopId_inventory_daily.parent_user_id = inventory_summary.`user_id`
			AND temp_shopId_inventory_daily.shopId = inventory_summary.`shop_id`
			AND temp_shopId_inventory_daily.sale_channel = inventory_summary.`sale_channel`
			WHERE
			inventory_summary.`user_id`=userId
			AND IF(shopId=0,1=1,inventory_summary.`shop_id`=shopId) 
			AND IF(salesChannel IS NULL,1=1,inventory_summary.`sale_channel`=salesChannel)
			AND inventory_summary.`quantity`>0 GROUP BY snapshot_date)
			inventory_summary_temp
			ON  DATE_FORMAT( inventory_daily_day.date1,"%Y-%m-%d") = inventory_summary_temp.snapshot_date
				GROUP BY snapshotDate ORDER BY snapshotDate;
		
		END IF;
		
	ELSEIF shopAdDataOverviewType = 'adgroups' THEN
		#找到这段时间的广告adgroups
		IF userType='PriAccount' THEN
			#主账号
			SELECT DATE_FORMAT( inventory_daily_day.date1,"%Y-%m-%d") snapshotDate,IF(SUM(inventory_summary_temp.`quantity`) IS NULL,0,SUM(inventory_summary_temp.`quantity`))quantity FROM
			inventory_daily_day LEFT JOIN 
			(SELECT DATE_FORMAT(inventory_summary.`snapshot_date`,"%Y-%m-%d") snapshot_date,SUM(inventory_summary.`quantity`) quantity FROM  inventory_summary 
			WHERE
			inventory_summary.`user_id`=userId
			AND IF(shopId=0,1=1,inventory_summary.`shop_id`=shopId) 
			AND IF(salesChannel is null,1=1,inventory_summary.`sale_channel`=salesChannel)
			AND inventory_summary.`quantity`>0 GROUP BY snapshot_date)
			inventory_summary_temp
			ON  DATE_FORMAT( inventory_daily_day.date1,"%Y-%m-%d") = inventory_summary_temp.snapshot_date
				GROUP BY snapshotDate ORDER BY snapshotDate;
		ELSE
		#子账号
			
		SELECT DATE_FORMAT( inventory_daily_day.date1,"%Y-%m-%d") snapshotDate,IF(SUM(inventory_summary_temp.`quantity`) IS NULL,0,SUM(inventory_summary_temp.`quantity`))quantity FROM
			inventory_daily_day LEFT JOIN 
			(SELECT DATE_FORMAT(inventory_summary.`snapshot_date`,"%Y-%m-%d") snapshot_date,SUM(inventory_summary.`quantity`) quantity FROM  inventory_summary 
			INNER JOIN temp_shopId_inventory_daily ON temp_shopId_inventory_daily.parent_user_id = inventory_summary.`user_id`
			AND temp_shopId_inventory_daily.shopId = inventory_summary.`shop_id`
			AND temp_shopId_inventory_daily.sale_channel = inventory_summary.`sale_channel`
			WHERE
			inventory_summary.`user_id`=userId
			AND IF(shopId=0,1=1,inventory_summary.`shop_id`=shopId) 
			AND IF(salesChannel IS NULL,1=1,inventory_summary.`sale_channel`=salesChannel)
			AND inventory_summary.`quantity`>0 GROUP BY snapshot_date)
			inventory_summary_temp
			ON  DATE_FORMAT( inventory_daily_day.date1,"%Y-%m-%d") = inventory_summary_temp.snapshot_date
				GROUP BY snapshotDate ORDER BY snapshotDate;
		
		END IF;
			
		
	ELSEIF shopAdDataOverviewType = 'productads' THEN
		#找到这段时间的广告productads
		IF userType='PriAccount' THEN
			#主账号
			SELECT DATE_FORMAT( inventory_daily_day.date1,"%Y-%m-%d") snapshotDate,IF(SUM(inventory_summary_temp.`quantity`) IS NULL,0,SUM(inventory_summary_temp.`quantity`))quantity FROM
			inventory_daily_day LEFT JOIN 
			(SELECT DATE_FORMAT(inventory_summary.`snapshot_date`,"%Y-%m-%d") snapshot_date,SUM(inventory_summary.`quantity`) quantity FROM  inventory_summary 
			WHERE
			inventory_summary.`user_id`=userId
			AND IF(shopId=0,1=1,inventory_summary.`shop_id`=shopId) 
			AND IF(salesChannel is null,1=1,inventory_summary.`sale_channel`=salesChannel)
			AND inventory_summary.`quantity`>0 GROUP BY snapshot_date)
			inventory_summary_temp
			ON  DATE_FORMAT( inventory_daily_day.date1,"%Y-%m-%d") = inventory_summary_temp.snapshot_date
				GROUP BY snapshotDate ORDER BY snapshotDate;
		ELSE
		#子账号
			
		SELECT DATE_FORMAT( inventory_daily_day.date1,"%Y-%m-%d") snapshotDate,IF(SUM(inventory_summary_temp.`quantity`) IS NULL,0,SUM(inventory_summary_temp.`quantity`))quantity FROM
			inventory_daily_day LEFT JOIN 
			(SELECT DATE_FORMAT(inventory_summary.`snapshot_date`,"%Y-%m-%d") snapshot_date,SUM(inventory_summary.`quantity`) quantity FROM  inventory_summary 
			INNER JOIN temp_shopId_inventory_daily ON temp_shopId_inventory_daily.parent_user_id = inventory_summary.`user_id`
			AND temp_shopId_inventory_daily.shopId = inventory_summary.`shop_id`
			AND temp_shopId_inventory_daily.sale_channel = inventory_summary.`sale_channel`
			WHERE
			inventory_summary.`user_id`=userId
			AND IF(shopId=0,1=1,inventory_summary.`shop_id`=shopId) 
			AND IF(salesChannel IS NULL,1=1,inventory_summary.`sale_channel`=salesChannel)
			AND inventory_summary.`quantity`>0 GROUP BY snapshot_date)
			inventory_summary_temp
			ON  DATE_FORMAT( inventory_daily_day.date1,"%Y-%m-%d") = inventory_summary_temp.snapshot_date
				GROUP BY snapshotDate ORDER BY snapshotDate;
		
		END IF;
	ELSEIF shopAdDataOverviewType = 'keywords' THEN
	#找到这段时间的广告keywords
		IF userType='PriAccount' THEN
			#主账号
			SELECT DATE_FORMAT( inventory_daily_day.date1,"%Y-%m-%d") snapshotDate,IF(SUM(inventory_summary_temp.`quantity`) IS NULL,0,SUM(inventory_summary_temp.`quantity`))quantity FROM
			inventory_daily_day LEFT JOIN 
			(SELECT DATE_FORMAT(inventory_summary.`snapshot_date`,"%Y-%m-%d") snapshot_date,SUM(inventory_summary.`quantity`) quantity FROM  inventory_summary 
			WHERE
			inventory_summary.`user_id`=userId
			AND IF(shopId=0,1=1,inventory_summary.`shop_id`=shopId) 
			AND IF(salesChannel is null,1=1,inventory_summary.`sale_channel`=salesChannel)
			AND inventory_summary.`quantity`>0 GROUP BY snapshot_date)
			inventory_summary_temp
			ON  DATE_FORMAT( inventory_daily_day.date1,"%Y-%m-%d") = inventory_summary_temp.snapshot_date
				GROUP BY snapshotDate ORDER BY snapshotDate;
		ELSE
		#子账号
			
		SELECT DATE_FORMAT( inventory_daily_day.date1,"%Y-%m-%d") snapshotDate,IF(SUM(inventory_summary_temp.`quantity`) IS NULL,0,SUM(inventory_summary_temp.`quantity`))quantity FROM
			inventory_daily_day LEFT JOIN 
			(SELECT DATE_FORMAT(inventory_summary.`snapshot_date`,"%Y-%m-%d") snapshot_date,SUM(inventory_summary.`quantity`) quantity FROM  inventory_summary 
			INNER JOIN temp_shopId_inventory_daily ON temp_shopId_inventory_daily.parent_user_id = inventory_summary.`user_id`
			AND temp_shopId_inventory_daily.shopId = inventory_summary.`shop_id`
			AND temp_shopId_inventory_daily.sale_channel = inventory_summary.`sale_channel`
			WHERE
			inventory_summary.`user_id`=userId
			AND IF(shopId=0,1=1,inventory_summary.`shop_id`=shopId) 
			AND IF(salesChannel IS NULL,1=1,inventory_summary.`sale_channel`=salesChannel)
			AND inventory_summary.`quantity`>0 GROUP BY snapshot_date)
			inventory_summary_temp
			ON  DATE_FORMAT( inventory_daily_day.date1,"%Y-%m-%d") = inventory_summary_temp.snapshot_date
				GROUP BY snapshotDate ORDER BY snapshotDate;
		
		END IF;
		
		
	END IF ;
	
	
	
	
	
	
	

END