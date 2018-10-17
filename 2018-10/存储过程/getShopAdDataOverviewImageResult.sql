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
			
		SELECT DATE_FORMAT( adDateView_day.date1,"%Y-%m-%d") snapshotDate,

		IF(campaigns_report.`clicks` IS NULL,0,campaigns_report.`clicks`) clicks,
		IF(campaigns_report.`impressions` IS NULL,0,campaigns_report.`impressions`) impressions,
		IF(campaigns_report.`orders` IS NULL,0,campaigns_report.`orders`) orders
		
		FROM
		adDateView_day LEFT JOIN 
		(SELECT DATE_FORMAT(campaigns_report.`site_local_date`,"%Y-%m-%d") snapshot_date,

		campaigns_report.`impressions` impressions,
		campaigns_report.`clicks` clicks,
		campaigns_report.`attributed_units_ordered1d` orders
	
		FROM  campaigns_report 
		INNER JOIN temp_shopId_adDateView ON temp_shopId_adDateView.parent_user_id = campaigns_report.`user_id`
		AND temp_shopId_adDateView.shopId = campaigns_report.`shop_id`
		AND temp_shopId_adDateView.sale_channel = campaigns_report.`sale_channel`
		WHERE
		campaigns_report.`user_id`=userId
		AND IF(shopId=0,1=1,campaigns_report.`shop_id`=shopId) 
		AND IF(saleChannel is null,1=1,campaigns_report.`sale_channel`=saleChannel)
		GROUP BY snapshot_date)
		campaigns_report
		ON  DATE_FORMAT( adDateView_day.date1,"%Y-%m-%d") = campaigns_report.snapshot_date
		  GROUP BY snapshotDate ORDER BY snapshotDate;
		
		END IF;
		
	ELSEIF shopAdDataOverviewType = 'adgroups' THEN
		#找到这段时间的广告adgroups
		IF userType='PriAccount' THEN
			#主账号
			SELECT DATE_FORMAT( adDateView_day.date1,"%Y-%m-%d") snapshotDate,
		
		IF(adgroups_report.`clicks` IS NULL,0,adgroups_report.`clicks`) clicks,
		IF(adgroups_report.`impressions` IS NULL,0,adgroups_report.`impressions`) impressions,
		IF(adgroups_report.`orders` IS NULL,0,adgroups_report.`orders`) orders
		
		
		FROM
		adDateView_day LEFT JOIN 
		(SELECT DATE_FORMAT(adgroups_report.`site_local_date`,"%Y-%m-%d") snapshot_date,
		
		adgroups_report.`impressions` impressions,
		adgroups_report.`clicks` clicks,
		adgroups_report.`attributed_units_ordered1d` orders
	
		FROM  adgroups_report 
		WHERE
		adgroups_report.`user_id`=userId
		AND IF(shopId=0,1=1,adgroups_report.`shop_id`=shopId) 
		AND IF(saleChannel is null,1=1,adgroups_report.`sale_channel`=saleChannel)
		GROUP BY snapshot_date)
		adgroups_report
		ON  DATE_FORMAT( adDateView_day.date1,"%Y-%m-%d") = adgroups_report.snapshot_date
		  GROUP BY snapshotDate ORDER BY snapshotDate;
		ELSE
		#子账号
			
		SELECT DATE_FORMAT( adDateView_day.date1,"%Y-%m-%d") snapshotDate,
		
		IF(adgroups_report.`clicks` IS NULL,0,adgroups_report.`clicks`) clicks,
		IF(adgroups_report.`impressions` IS NULL,0,adgroups_report.`impressions`) impressions,
		IF(adgroups_report.`orders` IS NULL,0,adgroups_report.`orders`) orders
		
		
		FROM
		adDateView_day LEFT JOIN 
		(SELECT DATE_FORMAT(adgroups_report.`site_local_date`,"%Y-%m-%d") snapshot_date,
		
		adgroups_report.`impressions` impressions,
		adgroups_report.`clicks` clicks,
		adgroups_report.`attributed_units_ordered1d` orders
	
		FROM  adgroups_report 
		INNER JOIN temp_shopId_adDateView ON temp_shopId_adDateView.parent_user_id = adgroups_report.`user_id`
		AND temp_shopId_adDateView.shopId = adgroups_report.`shop_id`
		AND temp_shopId_adDateView.sale_channel = adgroups_report.`sale_channel`
		WHERE
		adgroups_report.`user_id`=userId
		AND IF(shopId=0,1=1,adgroups_report.`shop_id`=shopId) 
		AND IF(saleChannel is null,1=1,adgroups_report.`sale_channel`=saleChannel)
		GROUP BY snapshot_date)
		adgroups_report
		ON  DATE_FORMAT( adDateView_day.date1,"%Y-%m-%d") = adgroups_report.snapshot_date
		  GROUP BY snapshotDate ORDER BY snapshotDate;
		
		END IF;
			
		
	ELSEIF shopAdDataOverviewType = 'productads' THEN
		#找到这段时间的广告productads
		IF userType='PriAccount' THEN
			#主账号
		SELECT DATE_FORMAT( adDateView_day.date1,"%Y-%m-%d") snapshotDate,
		
		IF(productads_report.`clicks` IS NULL,0,productads_report.`clicks`) clicks,
		IF(productads_report.`impressions` IS NULL,0,productads_report.`impressions`) impressions,
		IF(productads_report.`orders` IS NULL,0,productads_report.`orders`) orders

		FROM
		adDateView_day LEFT JOIN 
		(SELECT DATE_FORMAT(productads_report.`site_local_date`,"%Y-%m-%d") snapshot_date,
		
		productads_report.`impressions` impressions,
		productads_report.`clicks` clicks,
		productads_report.`attributed_units_ordered1d` orders
	
		FROM  productads_report 
		WHERE
		productads_report.`user_id`=userId
		AND IF(shopId=0,1=1,productads_report.`shop_id`=shopId) 
		AND IF(saleChannel is null,1=1,productads_report.`sale_channel`=saleChannel)
		GROUP BY snapshot_date)
		productads_report
		ON  DATE_FORMAT( adDateView_day.date1,"%Y-%m-%d") = productads_report.snapshot_date
		  GROUP BY snapshotDate ORDER BY snapshotDate;
		ELSE
		#子账号
			
		SELECT DATE_FORMAT( adDateView_day.date1,"%Y-%m-%d") snapshotDate,
		
		IF(productads_report.`clicks` IS NULL,0,productads_report.`clicks`) clicks,
		IF(productads_report.`impressions` IS NULL,0,productads_report.`impressions`) impressions,
		IF(productads_report.`orders` IS NULL,0,productads_report.`orders`) orders

		FROM
		adDateView_day LEFT JOIN 
		(SELECT DATE_FORMAT(productads_report.`site_local_date`,"%Y-%m-%d") snapshot_date,
		
		productads_report.`impressions` impressions,
		productads_report.`clicks` clicks,
		productads_report.`attributed_units_ordered1d` orders
	
		FROM  productads_report 
		INNER JOIN temp_shopId_adDateView ON temp_shopId_adDateView.parent_user_id = productads_report.`user_id`
		AND temp_shopId_adDateView.shopId = productads_report.`shop_id`
		AND temp_shopId_adDateView.sale_channel = productads_report.`sale_channel`
		WHERE
		productads_report.`user_id`=userId
		AND IF(shopId=0,1=1,productads_report.`shop_id`=shopId) 
		AND IF(saleChannel is null,1=1,productads_report.`sale_channel`=saleChannel)
		GROUP BY snapshot_date)
		productads_report
		ON  DATE_FORMAT( adDateView_day.date1,"%Y-%m-%d") = productads_report.snapshot_date
		  GROUP BY snapshotDate ORDER BY snapshotDate;
		
		END IF;
	ELSEIF shopAdDataOverviewType = 'keywords' THEN
	#找到这段时间的广告keywords
		IF userType='PriAccount' THEN
			#主账号
			SELECT DATE_FORMAT( adDateView_day.date1,"%Y-%m-%d") snapshotDate,
		
		IF(keywords_report.`clicks` IS NULL,0,keywords_report.`clicks`) clicks,
		IF(keywords_report.`impressions` IS NULL,0,keywords_report.`impressions`) impressions,
		IF(keywords_report.`orders` IS NULL,0,keywords_report.`orders`) orders

		FROM
		adDateView_day LEFT JOIN 
		(SELECT DATE_FORMAT(keywords_report.`site_local_date`,"%Y-%m-%d") snapshot_date,
		
		keywords_report.`impressions` impressions,
		keywords_report.`clicks` clicks,
		keywords_report.`attributed_units_ordered1d` orders
	
		FROM  keywords_report 
		WHERE
		keywords_report.`user_id`=userId
		AND IF(shopId=0,1=1,keywords_report.`shop_id`=shopId) 
		AND IF(saleChannel is null,1=1,keywords_report.`sale_channel`=saleChannel)
		GROUP BY snapshot_date)
		keywords_report
		ON  DATE_FORMAT( adDateView_day.date1,"%Y-%m-%d") = keywords_report.snapshot_date
		  GROUP BY snapshotDate ORDER BY snapshotDate;
		ELSE
		#子账号
			
		SELECT DATE_FORMAT( adDateView_day.date1,"%Y-%m-%d") snapshotDate,
		
		IF(keywords_report.`clicks` IS NULL,0,keywords_report.`clicks`) clicks,
		IF(keywords_report.`impressions` IS NULL,0,keywords_report.`impressions`) impressions,
		IF(keywords_report.`orders` IS NULL,0,keywords_report.`orders`) orders

		FROM
		adDateView_day LEFT JOIN 
		(SELECT DATE_FORMAT(keywords_report.`site_local_date`,"%Y-%m-%d") snapshot_date,
		
		keywords_report.`impressions` impressions,
		keywords_report.`clicks` clicks,
		keywords_report.`attributed_units_ordered1d` orders
	
		FROM  keywords_report 
		INNER JOIN temp_shopId_adDateView ON temp_shopId_adDateView.parent_user_id = keywords_report.`user_id`
		AND temp_shopId_adDateView.shopId = keywords_report.`shop_id`
		AND temp_shopId_adDateView.sale_channel = keywords_report.`sale_channel`
		WHERE
		keywords_report.`user_id`=userId
		AND IF(shopId=0,1=1,keywords_report.`shop_id`=shopId) 
		AND IF(saleChannel is null,1=1,keywords_report.`sale_channel`=saleChannel)
		GROUP BY snapshot_date)
		keywords_report
		ON  DATE_FORMAT( adDateView_day.date1,"%Y-%m-%d") = keywords_report.snapshot_date
		  GROUP BY snapshotDate ORDER BY snapshotDate;
		
		END IF;
		
		
	END IF ;
	
	
	
	
	
	
	

END