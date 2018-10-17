CREATE DEFINER=`root`@`%` PROCEDURE `getInventoryDailySummaryProc`(
	IN startDate DATETIME,
	IN endDate DATETIME,
	IN shopId INT,
	IN userId INT,
	IN loginUserId INT,
	IN salesChannel VARCHAR (30),
	IN userType VARCHAR (30)
    )
BEGIN
    DECLARE startDate1 DATETIME DEFAULT NULL ;
DECLARE endDate1  DATETIME DEFAULT NULL ;
SELECT startDate INTO startDate1;
SELECT endDate INTO endDate1;
    #临时表，判断这个用户是子账号，还是主账号
   CREATE TEMPORARY TABLE  IF NOT EXISTS temp_shopId_inventory_daily(shopId INT,parent_user_id INT,sale_channel VARCHAR(50) );
	TRUNCATE TABLE temp_shopId_inventory_daily;
	
	CREATE TEMPORARY TABLE  IF NOT EXISTS inventory_daily_day(date1 DATETIME,quantity INT);
	TRUNCATE TABLE inventory_daily_day;
	#修改仓储的时间
	WHILE startDate1<endDate1 DO
		INSERT INTO inventory_daily_day(date1) 
		SELECT DATE_FORMAT(startDate1,'%Y-%m-%d');
		SET startDate1=DATE_FORMAT(DATE_ADD(startDate1,INTERVAL 1 day),'%Y-%m-%d');
	END WHILE;
	
		
	#主账号
	IF userType='PriAccount' THEN
		#准备工作，找到这个主账号的所有激活的店铺信息
		INSERT INTO temp_shopId_inventory_daily(shopId,parent_user_id)
		SELECT shop_id,user_id FROM  shop_info i  WHERE i.`state`='1' AND i.user_id=userId;
	END IF;
	#子账号
	IF userType='SubAccount' THEN
		INSERT INTO temp_shopId_inventory_daily(shopId,parent_user_id,sale_channel)
		SELECT i.shop_id,i.`user_ID`,sub.`sale_channel` FROM shop_info i INNER JOIN sub_user_authority sub ON i.`user_ID`=sub.`parent_user_id` AND i.`shop_Id`=sub.`shop_id` WHERE i.`user_ID`=userId AND i.`state`='1' AND sub.`user_id`=loginUserId;
	END IF; 
	
	#找到这段时间的全部入库
	IF userType='PriAccount' THEN
	  #主账号
		SELECT DATE_FORMAT( inventory_daily_day.date1,"%Y-%m-%d") snapshotDate,IF(SUM(inventory_summary_temp.`quantity`) IS NULL,0,SUM(inventory_summary_temp.`quantity`))quantity FROM
		inventory_daily_day LEFT JOIN 
		(SELECT DATE_FORMAT(inventory_summary.`snapshot_date`,"%Y-%m-%d") snapshot_date,SUM(inventory_summary.`quantity`) quantity FROM  inventory_summary 
		WHERE
		inventory_summary.`user_id`=userId
		AND IF(shopId=0,1=1,inventory_summary.`shop_id`=shopId) 
		AND IF(salesChannel='',1=1,inventory_summary.`sale_channel`=salesChannel)
		AND inventory_summary.`quantity`>0 GROUP BY snapshot_date)
		inventory_summary_temp
		ON  DATE_FORMAT( inventory_daily_day.date1,"%Y-%m-%d") = inventory_summary_temp.snapshot_date
		  GROUP BY snapshotDate ORDER BY snapshotDate;
	else
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
		AND IF(salesChannel='',1=1,inventory_summary.`sale_channel`=salesChannel)
		AND inventory_summary.`quantity`>0 GROUP BY snapshot_date)
		inventory_summary_temp
		ON  DATE_FORMAT( inventory_daily_day.date1,"%Y-%m-%d") = inventory_summary_temp.snapshot_date
		  GROUP BY snapshotDate ORDER BY snapshotDate;
	
	end if;
	
	
	
	#找到这段时间的全部出库
IF userType='PriAccount' THEN
	  #主账号
		SELECT DATE_FORMAT( inventory_daily_day.date1,"%Y-%m-%d") snapshotDate,IF(SUM(inventory_summary_temp.`quantity`) IS NULL,0,SUM(inventory_summary_temp.`quantity`))quantity FROM
		inventory_daily_day LEFT JOIN 
		(select DATE_FORMAT(inventory_summary.`snapshot_date`,"%Y-%m-%d") snapshot_date,sum(inventory_summary.`quantity`) quantity from  inventory_summary 
		WHERE
		inventory_summary.`user_id`=userId
		AND IF(shopId=0,1=1,inventory_summary.`shop_id`=shopId) 
		AND IF(salesChannel='',1=1,inventory_summary.`sale_channel`=salesChannel)
		AND inventory_summary.`quantity`<0 group by snapshot_date)
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
		AND IF(salesChannel='',1=1,inventory_summary.`sale_channel`=salesChannel)
		AND inventory_summary.`quantity`<0 GROUP BY snapshot_date)
		inventory_summary_temp
		ON  DATE_FORMAT( inventory_daily_day.date1,"%Y-%m-%d") = inventory_summary_temp.snapshot_date
		  GROUP BY snapshotDate ORDER BY snapshotDate;
	
	END IF;
	
	
	
    END