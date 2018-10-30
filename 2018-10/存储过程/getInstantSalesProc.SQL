CREATE DEFINER=`admin`@`%` PROCEDURE `getInstantSalesProc`(
    IN user_id INT,
    IN shop_id INT,
    IN sale_channel  VARCHAR(20),
    IN distribution_channel VARCHAR(20),
    IN statistical_methods  VARCHAR(20))
BEGIN
    
    DECLARE currency_code_sym VARCHAR(30) DEFAULT NULL ;
    SELECT order_item_temp.`currency_code` INTO currency_code_sym FROM orders_temp  INNER JOIN order_item_temp ON order_item_temp.`shop_id`=orders_temp.`shop_Id` AND orders_temp.`amazon_order_id`=order_item_temp.`amazon_order_id` WHERE orders_temp.`shop_Id`=shop_id AND orders_temp.`sales_channel`=sale_channel
    AND order_item_temp.`currency_code` IS NOT NULL LIMIT 1 ;
    
  IF currency_code_sym='GBP' THEN
  SELECT '£' INTO currency_code_sym;
  END IF;
    IF currency_code_sym='EUR' THEN
  SELECT '€' INTO currency_code_sym;
    END IF;
   IF currency_code_sym='USD' THEN
  SELECT '$' INTO currency_code_sym;
    END IF;
   IF currency_code_sym='JPY' THEN
  SELECT '￥' INTO currency_code_sym;
    END IF;
   IF currency_code_sym='CAD' THEN
  SELECT 'C$' INTO currency_code_sym;
    END IF;
   IF currency_code_sym='MXN' THEN
 SELECT '$' INTO currency_code_sym;
   END IF;
   
     SELECT instant_sale_control.order_syn_time,
    SUM(instant_sale.`instant_order_sale`) instant_order_sale,SUM(instant_sale.`instant_sale`) instant_sale,
   SUM(instant_sale.`instant_sale`)/ SUM(instant_sale.`instant_order_sale`) avg_sale, SUM(instant_sale.`instant_net_sale`) instant_price,
   SUM(instant_sale.`instant_net_sale`)/ SUM(instant_sale.`instant_sale`) net_sale, currency_code_sym currency_code
     FROM instant_sale   
	INNER JOIN instant_sale_control ON instant_sale.`shop_id`=instant_sale_control.shop_id
	AND instant_sale.`sale_channel`=instant_sale_control.sale_channel  WHERE instant_sale.`shop_id`=shop_id AND instant_sale.`sale_channel`=sale_channel
   AND IF(distribution_channel='all',1=1,instant_sale.`fulfillment_channel`=distribution_channel) ;
    
	
   
   if statistical_methods='subASIN' then
	SELECT instant_sale.`img_url`,instant_sale.`asin`,instant_sale.`product_name`,instant_sale.`sku`,
	instant_sale.`instant_sale`,instant_sale.`instant_net_sale`,instant_sale.`instant_price`,
	instant_sale.`yesterday_sale`,instant_sale.`yesterday_net_sale`,instant_sale.`yesterday_price`,
	instant_sale.`last_week_same_day_sale`,instant_sale.`last_week_same_day_net_sale`,instant_sale.`last_week_same_day_price`,
	instant_sale.`saleable_inventory`,instant_sale.`reciving_inventory`,instant_sale.`transfer_inventory`,currency_code_sym currency_code FROM instant_sale
	WHERE instant_sale.`shop_id`=shop_id AND instant_sale.`sale_channel`=sale_channel
	AND IF(distribution_channel='all',1=1,instant_sale.`fulfillment_channel`=distribution_channel) ORDER BY instant_sale.`instant_sale` DESC,instant_sale.`yesterday_sale` DESC,instant_sale.`last_week_same_day_sale` DESC,instant_sale.`sku`;
  
   else
	SELECT instant_sale.`img_url`,instant_sale.`fasin` asin,instant_sale.`product_name`,null sku,
	sum(instant_sale.`instant_sale`) instant_sale,sum(instant_sale.`instant_net_sale`) instant_net_sale,instant_sale.`instant_price` instant_price,
	sum(instant_sale.`yesterday_sale`) yesterday_sale,sum(instant_sale.`yesterday_net_sale`) yesterday_net_sale,instant_sale.`yesterday_price` yesterday_price,
	sum(instant_sale.`last_week_same_day_sale`) last_week_same_day_sale,sum(instant_sale.`last_week_same_day_net_sale`) last_week_same_day_net_sale,
	instant_sale.`last_week_same_day_price` last_week_same_day_price,
	sum(instant_sale.`saleable_inventory`) saleable_inventory,sum(instant_sale.`reciving_inventory`) reciving_inventory,
	sum(instant_sale.`transfer_inventory`) transfer_inventory,currency_code_sym currency_code FROM instant_sale
	WHERE instant_sale.`shop_id`=shop_id AND instant_sale.`sale_channel`=sale_channel
	AND IF(distribution_channel='all',1=1,instant_sale.`fulfillment_channel`=distribution_channel) group by instant_sale.`fasin` ORDER BY SUM(instant_sale.`instant_sale`) DESC,
	SUM(instant_sale.`yesterday_sale`)  DESC,SUM(instant_sale.`last_week_same_day_sale`) DESC;
  
   
   end if;
   
   
    
  
	
    
  
  
    END