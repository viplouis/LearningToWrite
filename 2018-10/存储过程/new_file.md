CREATE DEFINER=`root`@`%` PROCEDURE `UpdatePAFEDaterProc`(IN userId INT,IN shopId INT )
label:BEGIN

    DECLARE saleChannelPAFE VARCHAR(30) DEFAULT NULL ;
    DECLARE currencyCodePAFE VARCHAR(30) DEFAULT NULL ;
	DECLARE skurules_PAFE INT DEFAULT 0 ;
	DECLARE currencyExchangeRateIsSettingPAFE INT DEFAULT 0 ;
	DECLARE toucheng INT DEFAULT 0 ;
	SELECT COUNT(1) INTO currencyExchangeRateIsSettingPAFE FROM currency_exchange_rate WHERE currency_exchange_rate.`user_id`=userId;
	
	SELECT amazon_profit2.`marketplace_name` INTO saleChannelPAFE FROM amazon_profit2 WHERE amazon_profit2.`marketplace_name` IS NOT NULL AND amazon_profit2.`marketplace_name`<>'SI UK Prod Marketplace' 
	AND  amazon_profit2.`user_id`=userId AND  amazon_profit2.`shop_id`=shopId LIMIT 1;
	
	SELECT amazon_profit2.`currency_code` INTO currencyCodePAFE FROM amazon_profit2 WHERE amazon_profit2.`currency_code` IS NOT NULL AND  amazon_profit2.`user_id`=userId AND  amazon_profit2.`shop_id`=shopId LIMIT 1;
	
	UPDATE amazon_profit2 SET amazon_profit2.`currency_code`=currencyCodePAFE,amazon_profit2.`marketplace_name`=saleChannelPAFE WHERE  amazon_profit2.`user_id`=userId AND  amazon_profit2.`shop_id`=shopId;
	SELECT COUNT(1) INTO toucheng FROM amazon_profit_shippingcost_sku WHERE amazon_profit_shippingcost_sku.`user_id`=userId;
	IF saleChannelPAFE IS NULL THEN
	LEAVE label;
	END IF;
	
	UPDATE amazon_profit2 SET
	amazon_profit2.`type` = REPLACE (amazon_profit2.`type`, '-', '_')
	WHERE amazon_profit2.`type` LIKE '%-%';
	
	UPDATE amazon_profit2 SET
	amazon_profit2.`type` = REPLACE (amazon_profit2.`type`, ' ', '')
	WHERE amazon_profit2.`type` LIKE '% %';
	
  
	
	#1，修改一下SKU
	SELECT COUNT(1) INTO skurules_PAFE FROM sku_rule WHERE sku_rule.`rule_type`='CUSTOMER' AND sku_rule.`user_id`=userId;
	
	#1.1 如果该用户是自定义SKU
	IF skurules_PAFE>0 THEN 
	UPDATE amazon_profit2 INNER JOIN product ON amazon_profit2.`user_id`=product.`user_id`
	AND amazon_profit2.`seller_SKU`=product.`sku`
	SET amazon_profit2.`fsku`=product.fsku,
	amazon_profit2.`zsku`=product.`zsku`
	WHERE amazon_profit2.`user_id`=userId
	AND product.`user_id`=userId;
	END IF;
	
	#设置产品转换货币
	IF currencyExchangeRateIsSettingPAFE>0 THEN
	UPDATE amazon_profit2 INNER JOIN currency_exchange_rate
	ON amazon_profit2.`currency_code`=currency_exchange_rate.`original_currency`
	AND amazon_profit2.`user_id`=currency_exchange_rate.`user_id`
	SET amazon_profit2.`currency_amount_change`=amazon_profit2.`currency_amount`*currency_exchange_rate.`exchange_rate`,
	amazon_profit2.`currency_code_change`=currency_exchange_rate.`target_currency`
	WHERE amazon_profit2.`user_id`=userId AND currency_exchange_rate.`user_id`=userId
	AND amazon_profit2.`posted_date` BETWEEN currency_exchange_rate.start_date AND currency_exchange_rate.end_date;
    
	END IF;
	
CREATE TEMPORARY TABLE  IF NOT EXISTS `ad_summary_report_temp` (
  `shop_id` int(11) NOT NULL,
  `sale_channel` varchar(30) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `operator_id` varchar(30) DEFAULT NULL,
  `campaign_type` varchar(50) DEFAULT NULL COMMENT '查询参数字段',
  `segment` varchar(50) DEFAULT NULL COMMENT '查询参数字段',
  `report_date` varchar(30) DEFAULT NULL COMMENT '查询参数字段',
  `keyword_id` varchar(50) NOT NULL DEFAULT '',
  `campaign_id` varchar(30) NOT NULL,
  `ad_group_id` varchar(50) NOT NULL,
  `campaign_name` varchar(50) DEFAULT NULL,
  `ad_group_name` varchar(50) DEFAULT NULL,
  `impressions` int(11) DEFAULT NULL,
  `clicks` int(11) DEFAULT NULL,
  `cost` decimal(11,2) DEFAULT NULL,
  `targeting_type` varchar(50) DEFAULT NULL,
  `placement` varchar(50) NOT NULL COMMENT 'Ad placement. Only returned when segment is set to placement(Top of Search on-Amazon", "Other on-Amazon)',
  `match_type` varchar(20) DEFAULT NULL,
  `query` varchar(30) DEFAULT NULL,
  `asin` varchar(30) NOT NULL,
  `other_asin` varchar(30) NOT NULL,
  `sku` varchar(30) DEFAULT NULL,
  `zsku` varchar(30) DEFAULT NULL,
  `fsku` varchar(30) DEFAULT NULL,
  `currency` varchar(8) DEFAULT NULL,
  `keyword_text` varchar(100) DEFAULT NULL,
  `category` varchar(30) DEFAULT NULL,
  `developer` varchar(30) DEFAULT NULL,
  `attributed_sales7d` decimal(11,2) DEFAULT NULL,
  `attributed_conversions7d` decimal(11,2) DEFAULT NULL,
  `attributed_units_ordered7d` decimal(11,2) DEFAULT NULL,
  `attributed_sales7d_sameSKU` decimal(11,2) DEFAULT NULL,
  `attributed_conversions7d_sameSKU` decimal(11,2) DEFAULT NULL,
  `attributed_sales7d_direct` decimal(11,2) DEFAULT NULL,
  `attributed_conversions7d_direct` decimal(11,2) DEFAULT NULL,
  `attributed_units_ordered7d_direct` decimal(11,2) DEFAULT NULL,
  `attributed_sales7d_sameSKU_direct` decimal(11,2) DEFAULT NULL,
  `attributed_conversions7d_sameSKU_direct` decimal(11,2) DEFAULT NULL,
  `attributed_sales7d_indirect` decimal(11,2) DEFAULT NULL,
  `attributed_conversions7d_indirect` decimal(11,2) DEFAULT NULL,
  `attributed_units_ordered7d_indirect` decimal(11,2) DEFAULT NULL,
  `attributed_sales7d_sameSKU_indirect` decimal(11,2) DEFAULT NULL,
  `attributed_conversions7d_sameSKU_indirect` decimal(11,2) DEFAULT NULL,
  `synchronised_time` datetime DEFAULT NULL COMMENT '入数据库时间',
  `is_delete` varchar(3) DEFAULT NULL,
  `site_local_date` datetime DEFAULT NULL,
  `remarks` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`shop_id`,`sale_channel`,`keyword_id`,`campaign_id`,`ad_group_id`,`placement`,`asin`,`other_asin`) USING BTREE
) ENGINE=INNODB DEFAULT CHARSET=utf8;
TRUNCATE TABLE ad_summary_report_temp;
	
	 REPLACE INTO amazon_persku_finnace_element_temp(sku,fsku,zsku,
	per_cost,per_weight,product_category,sale_channel,
	TYPE,classification,post_date,shop_id,user_id,amazon_order_id,
	currency_code,currency_amount,quantity_shipped,developer,
	currency_code_product,per_shipping_cost,per_shipping_cost_currency_code,
	currency_amount_change,currency_code_change,seller,
	update_status,currency_code_product_change,currency_amount_product_change,
	currency_code_shipping_change,currency_amount_shipping_change,seller_order_id,
	currency_code_shipping_seller,currency_amount_shipping_seller,
	currency_code_change_shipping_seller,currency_amount_change_shipping_seller)
	SELECT 
	amazon_profit2.`seller_SKU`,amazon_profit2.`fsku`,amazon_profit2.`zsku`,
	amazon_profit2.`currency_amount_product`,amazon_profit2.`per_weight`,
	amazon_profit2.`product_category`,amazon_profit2.`marketplace_name`,
	amazon_profit2.`type`,amazon_profit2.`classification`,amazon_profit2.`posted_date`,
	amazon_profit2.`shop_id`,amazon_profit2.`user_id`,amazon_profit2.`amazon_order_id`,
	amazon_profit2.`currency_code`,
	SUM(amazon_profit2.`currency_amount`) ,
	SUM(amazon_profit2.`quantity_shipped`),amazon_profit2.`developer`,
	amazon_profit2.`currency_code_product`,amazon_profit2.`currency_amount_shippingFBA`,amazon_profit2.`currency_code_shippingFBA`,
	SUM(amazon_profit2.`currency_amount_change`),amazon_profit2.`currency_code_change`,NULL,
	0,amazon_profit2.`currency_code_product_change`,amazon_profit2.`currency_amount_product_change`,
	amazon_profit2.`currency_code_shippingFBA_change`,amazon_profit2.`currency_amount_shippingFBA_change`,amazon_profit2.`seller_order_id`,
	amazon_profit2.`currency_code_shippingFBM`,amazon_profit2.`currency_amount_shippingFBM`,
	amazon_profit2.`currency_code_shippingFBM_change`,amazon_profit2.`currency_amount_shippingFBM_change`
 	FROM amazon_profit2 
 	WHERE  amazon_profit2.`user_id`=userId AND amazon_profit2.`shop_id`=shopId  GROUP BY amazon_profit2.`amazon_order_id`,amazon_profit2.`classification`,amazon_profit2.`posted_date`,amazon_profit2.`seller_SKU`,amazon_profit2.`type` ORDER BY NULL;
	
	
	
	
	#设置产品的单价
	IF toucheng=0 THEN
		UPDATE
		amazon_persku_finnace_element_temp amazon_profit2 INNER JOIN 
		product
		ON amazon_profit2.`user_id` = product.`user_id`  
		AND amazon_profit2.`zsku`=product.zsku
		AND amazon_profit2.`post_date` BETWEEN product.`developer_time` AND product.`time_range`
		SET amazon_profit2.`per_cost`=product.`unit_price`,
		amazon_profit2.`currency_amount_product_change`=product.currency_amount_change,
		amazon_profit2.`currency_code_product`=product.currency_code,
		amazon_profit2.`currency_code_product_change`=product.currency_code_change,
		amazon_profit2.`per_weight`=product.weight,
		amazon_profit2.`product_category` =product.`product_category`,
		amazon_profit2.`developer`=product.`developer`
		WHERE   
		amazon_profit2.`user_id`=userId
		AND amazon_profit2.`shop_id`=shopId
		AND IF( amazon_profit2.`shop_id`=product.`shop_id`,amazon_profit2.`shop_id`=product.`shop_id`,1=1)  
		AND amazon_profit2.`post_date` BETWEEN product.`developer_time` AND product.`time_range`
		AND amazon_profit2.`per_cost` IS NULL;
	ELSE
		UPDATE
		amazon_persku_finnace_element_temp amazon_profit2 INNER JOIN 
		product
		ON amazon_profit2.`user_id` = product.`user_id`  
		AND amazon_profit2.`zsku`=product.zsku
		AND amazon_profit2.`post_date` BETWEEN product.`developer_time` AND product.`time_range`
		SET amazon_profit2.`per_cost`=product.`unit_price`,
		amazon_profit2.`currency_amount_product_change`=product.currency_amount_change,
		amazon_profit2.`currency_code_product`=product.currency_code,
		amazon_profit2.`currency_code_product_change`=product.currency_code_change,
		amazon_profit2.`per_weight`=1,
		amazon_profit2.`product_category` =product.`product_category`,
		amazon_profit2.`developer`=product.`developer`
		WHERE  amazon_profit2.`user_id`=userId
		AND amazon_profit2.`shop_id`=shopId
		AND 
		IF( amazon_profit2.`shop_id`=product.`shop_id`,amazon_profit2.`shop_id`=product.`shop_id`,1=1)  
		AND amazon_profit2.`post_date` BETWEEN product.`developer_time` AND product.`time_range`
		AND amazon_profit2.`per_cost` IS NULL;
	END IF;
	
	
	#2，设置产品的开发员
	#2.1先去产品库那里看是不是已经设置了
	
    
    
    #设置销售人员
     #UPDATE ad_info_month INNER JOIN seller_relation
     #on ad_info_month.`user_id`=seller_relation.`user_id`
     #and seller_relation.`shop_id`=ad_info_month.`shop_id`
     #and seller_relation.`sku`=ad_info_month.`zsku`
     #and ad_info_month.`sale_channel`=seller_relation.`sale_channel`
     #set ad_info_month.`seller`=seller_relation.`seller`
     #where ad_info_month.`user_id`=userId;
    
    
    
    
    #设置运费
    IF toucheng=0 THEN
	UPDATE amazon_persku_finnace_element_temp amazon_profit2 INNER JOIN amazon_profit_shippingcost ON amazon_profit2.`user_id`=amazon_profit_shippingcost.`user_id`
	AND CONCAT(DATE_FORMAT(amazon_profit2.`post_date`,'%Y-%m'),'-1 00:00:00')=amazon_profit_shippingcost.`export_date`
	AND amazon_profit2.`sale_channel`=amazon_profit_shippingcost.`sale_channel`
	SET amazon_profit2.`per_shipping_cost`=amazon_profit_shippingcost.`average_per_shipping_cost`,
	amazon_profit2.`currency_amount_shipping_change`=amazon_profit_shippingcost.`currency_amount_change`,
	amazon_profit2.per_shipping_cost_currency_code=amazon_profit_shippingcost.`currency_code`,
	amazon_profit2.`currency_code_shipping_change`=amazon_profit_shippingcost.`currency_code_change`
	WHERE amazon_profit2.`user_id`=userId AND amazon_profit2.`shop_id`=shopId
		AND  amazon_profit2.`amazon_order_id`=amazon_profit2.`seller_order_id` AND amazon_profit2.`type`='quantity'
	AND amazon_profit2.`per_shipping_cost` IS NULL;      
    ELSE
	UPDATE amazon_persku_finnace_element_temp amazon_profit2 INNER JOIN amazon_profit_shippingcost_sku
	ON amazon_profit2.`zsku`=amazon_profit_shippingcost_sku.`zsku` AND
	amazon_profit2.`user_id`=amazon_profit_shippingcost_sku.`user_id`
	AND CONCAT(DATE_FORMAT(amazon_profit2.`post_date`,'%Y-%m'),'-01 00:00:00')=amazon_profit_shippingcost_sku.`time_shippingcost_sku`
	SET amazon_profit2.`per_weight`=1,
	 amazon_profit2.`per_shipping_cost`= amazon_profit_shippingcost_sku.`currencyamount_shippingcost_sku`,
	amazon_profit2.`per_shipping_cost_currency_code`=amazon_profit_shippingcost_sku.`currencycode_shippingcost_sku`,
	amazon_profit2.`currency_amount_shipping_change`=amazon_profit_shippingcost_sku.`currencyamount_shippingcost_sku_change`,
	amazon_profit2.`currency_code_shipping_change`=amazon_profit_shippingcost_sku.`currencycode_shippingcost_sku_change`
	WHERE amazon_profit_shippingcost_sku.`user_id`=userId AND amazon_profit2.`user_id`=userId AND amazon_profit2.`shop_id`=shopId
	AND amazon_profit2.`per_shipping_cost` IS NULL;  
    
    END IF;
   
    
    #设置自发货运费
   UPDATE amazon_persku_finnace_element_temp amazon_profit2 INNER JOIN amazon_profit_shippingcost ON amazon_profit2.`user_id`=amazon_profit_shippingcost.`user_id`
    AND amazon_profit2.`amazon_order_id`=amazon_profit_shippingcost.`amazon_order_id`
    SET amazon_profit2.`currency_amount_shipping_seller`=amazon_profit_shippingcost.`average_per_shipping_cost`,
    amazon_profit2.`currency_amount_change_shipping_seller`=amazon_profit_shippingcost.`currency_amount_change`,
    amazon_profit2.`currency_code_shipping_seller`=amazon_profit_shippingcost.`currency_code`,
    amazon_profit2.`currency_code_change_shipping_seller`=amazon_profit_shippingcost.`currency_code_change`
    WHERE  amazon_profit_shippingcost.type="Seller" AND amazon_profit2.`user_id`=userId AND amazon_profit2.`shop_id`=shopId;
    
    
    	 REPLACE INTO amazon_persku_finnace_element
    	 SELECT * FROM amazon_persku_finnace_element_temp WHERE amazon_persku_finnace_element_temp.user_id=userId AND amazon_persku_finnace_element_temp.shop_id=shopId;
	
  
	insert ignore INTO classification_type(classification,TYPE,user_id)
	SELECT IF(amazon_persku_finnace_element_temp.`classification` IS NULL,'otherFee',amazon_persku_finnace_element_temp.`classification`) classification,
	amazon_persku_finnace_element_temp.`type`,
	amazon_persku_finnace_element_temp.`user_id` FROM amazon_persku_finnace_element_temp  GROUP BY amazon_persku_finnace_element_temp.`classification`,amazon_persku_finnace_element_temp.`type`,
	amazon_persku_finnace_element_temp.`user_id`;
	#UPDATE
		#amazon_persku_finnace_element amazon_profit2 INNER JOIN 
		#product
		#ON amazon_profit2.`user_id` = product.`user_id`  
		#AND amazon_profit2.`zsku`=product.zsku
		#SET amazon_profit2.`per_cost`=product.`unit_price`,
		#amazon_profit2.`currency_amount_product_change`=product.currency_amount_change,
		#amazon_profit2.`currency_code_product`=product.currency_code,
		#amazon_profit2.`currency_code_product_change`=product.currency_code_change,
		#amazon_profit2.`per_weight`=1,
		#amazon_profit2.`product_category` =product.`product_category`,
		#amazon_profit2.`developer`=product.`developer`
		#WHERE  
		# amazon_profit2.`user_id`=userId
		# and
		#IF( amazon_profit2.`shop_id`=product.`shop_id`,amazon_profit2.`shop_id`=product.`shop_id`,1=1)  
		#AND amazon_profit2.`per_cost` IS NULL;
		
		
    
    END