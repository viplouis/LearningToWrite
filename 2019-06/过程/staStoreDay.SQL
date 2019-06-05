CREATE DEFINER=`yz_dev`@`%` PROCEDURE `staStoreDay`()
BEGIN
	#Routine body goes here...

-- 	需要定义接收游标数据的变量
  DECLARE storeId VARCHAR(20);
	DECLARE staDay date DEFAULT DATE_SUB(curdate(),INTERVAL 1 DAY);


  -- 遍历数据结束标志
  DECLARE done INT DEFAULT FALSE;
  DECLARE cur CURSOR FOR SELECT store_id from store_body where 1 = 1;
  -- 将结束标志绑定到游标
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  -- 打开游标
  OPEN cur;
  -- 开始循环
  read_loop: LOOP
    -- 提取游标里的数据
    FETCH cur INTO storeId;
	
    -- 声明结束的时候
    IF done THEN
      LEAVE read_loop;
    END IF;
    -- 这里做你想做的循环的事件
		-- 从门店表获取所有门店id,如果门店统计表中不存在某门店id则插入，存在则不做操作
-- 		REPLACE INTO sta_store_day (store_id,day) VALUES (storeId, NOW());
		INSERT IGNORE INTO sta_store_day (store_id,day) VALUES (storeId, staDay) ON DUPLICATE KEY UPDATE store_id = storeId AND day = staDay;
		
		/** 更新所有门店每天浏览数 **/
		SET @tableName = CONCAT("sys_store_log_",storeId);
		
		SET @sqlStrViewCount = CONCAT("select count(1) as view from ", @tableName," WHERE operation_id = 1 "," and DATE_FORMAT(create_date,'%Y-%m-%d') = ",staDay);
		
-- 		SELECT @sqlStrViewCount;
		
		
		
		SET @sqlStrViewResult = CONCAT("UPDATE sta_store_day ", " SET view_sum = ","(",@sqlStrViewCount,")"," WHERE store_id = ",storeId," and DATE_FORMAT(day,'%Y-%m-%d') = ",staDay);

    PREPARE stmt from @sqlStrViewResult;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;  
		
		/** 更新所有门店每天客户数 **/
		SET @sqlStrCustomerCount = CONCAT("SELECT count(*) FROM( select count(*) from order_reserve where status = 3 and store_id = ",storeId," and DATE_FORMAT(deal_time,'%Y-%m-%d') = ",staDay," GROUP BY user_id",") t ");
		SET @sqlStrCustomerResult = CONCAT("UPDATE sta_store_day ", " SET customer_sum = ","(",@sqlStrCustomerCount,")"," WHERE store_id = ",storeId," and DATE_FORMAT(day,'%Y-%m-%d') = ",staDay);

		PREPARE stmtCustomer from @sqlStrCustomerResult;
    EXECUTE stmtCustomer;
    DEALLOCATE PREPARE stmtCustomer; 
		
		/** 更新所有门店每天预约数 **/
		SET @sqlStrReserveCount = CONCAT("select count(1) as orders from order_reserve WHERE store_id = ", storeId, " and status = 1 "," and DATE_FORMAT(reserve_time,'%Y-%m-%d') = ",staDay);
		SET @sqlStrReserveResult = CONCAT("UPDATE sta_store_day ", " SET reserve_sum = ","(",@sqlStrReserveCount,")"," WHERE store_id = ",storeId," and DATE_FORMAT(day,'%Y-%m-%d') = ",staDay);

		PREPARE stmtReserve from @sqlStrReserveResult;
    EXECUTE stmtReserve;
    DEALLOCATE PREPARE stmtReserve; 
		
		/** 更新所有门店每天订单数 **/
		SET @sqlStrOrderCount = CONCAT("select count(1) as orders from order_reserve WHERE store_id = ", storeId, " and status = 3 "," and DATE_FORMAT(deal_time,'%Y-%m-%d') = ",staDay);
		SET @sqlStrOrderResult = CONCAT("UPDATE sta_store_day ", " SET order_sum = ","(",@sqlStrOrderCount,")"," WHERE store_id = ",storeId," and DATE_FORMAT(day,'%Y-%m-%d') = ",staDay);

		PREPARE stmtOrder from @sqlStrOrderResult;
    EXECUTE stmtOrder;
    DEALLOCATE PREPARE stmtOrder;  
		
		/** 更新所有门店每天客户来源（此处非比例，单纯数量） **/
		
		
		/** 更新所有门店每天活跃客户（此处非比例，单纯数量） **/
		
		
  END LOOP;
  -- 关闭游标
  CLOSE cur;
	

END