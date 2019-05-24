CREATE DEFINER=`root`@`%` PROCEDURE `staStoreDay`()
BEGIN
	#Routine body goes here...

-- 	需要定义接收游标数据的变量
  DECLARE storeId VARCHAR(20);


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
		REPLACE INTO sta_store_day (store_id,day) VALUES (storeId, NOW());
		
		/** 更新所有门店每天浏览数 **/
		SET @tableName = CONCAT("sys_store_log_",storeId);
		SET @sqlStrViewCount = CONCAT(" select count(1) as view from ", @tableName," WHERE store_id = ", storeId, " and operation_id = 1 "," and to_days(create_date) = to_days(now())");
		SET @sqlStrViewResult = CONCAT("UPDATE sta_store_day ", " SET view_sum = ","(",@sqlStrViewCount,")"," WHERE store_id = ",storeId," and day = date_format(now(),'%y-%m-%d')");

    PREPARE stmt from @sqlStrViewResult;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;  
		
		/** 更新所有门店每天客户数 **/
		
		
		/** 更新所有门店每天预约数 **/
		
		
		/** 更新所有门店每天订单数 **/
		
		
		
  END LOOP;
  -- 关闭游标
  CLOSE cur;
	

END