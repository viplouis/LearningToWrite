CREATE DEFINER=`root`@`%` PROCEDURE `staStoreDay`()
BEGIN
	#Routine body goes here...

-- 	需要定义接收游标数据的变量
  DECLARE storeId VARCHAR(20);
	DECLARE one VARCHAR(20);
	DECLARE two VARCHAR(20);
	DECLARE three VARCHAR(20);
	DECLARE total VARCHAR(20);


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
		SET @sqlStrViewResult = CONCAT("UPDATE sta_store_day SET view_sum = ","(",@sqlStrViewCount,")"," WHERE store_id = ",storeId," and day = date_format(now(),'%y-%m-%d')");

    PREPARE stmt from @sqlStrViewResult;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;  
		
		/** 更新所有门店每天客户数 **/
		
		
		/** 更新所有门店每天预约数 **/
		
		
		/** 更新所有门店每天订单数 **/
		
		
		/** 更新所有门店每天客户浏览频次**/

		SET @strOne = CONCAT("SELECT count(*) as a FROM (SELECT count( * ) AS num1 FROM ", @tableName," visitor_id HAVING num1 <= 1) t INTO one");
		SET @strTwo = CONCAT("SELECT count(*) as b FROM (SELECT count( * ) AS num2 FROM ", @tableName,"  GROUP BY visitor_id HAVING num2 = 3 ) t INTO two");
		SET @strThree = CONCAT("SELECT count(*) as c FROM (SELECT count( * ) AS num3 FROM ", @tableName,"  GROUP BY visitor_id HAVING num3 >= 3 ) t INTO three");

SET @sqlScaleOneResult = CONCAT("UPDATE sta_store_day set browse_one_scale = (IF(one+two+three) IS 0,0,one/one+two+three) "," WHERE store_id = ",storeId," and day = date_format(now(),'%y-%m-%d')");
SET @sqlScaleTwoResult = CONCAT("UPDATE sta_store_day set browse_two_scale = (IF(one+two+three) IS 0,0,two/one+two+three) "," WHERE store_id = ",storeId," and day = date_format(now(),'%y-%m-%d')");
SET @sqlScaleThreeResult = CONCAT("UPDATE sta_store_day set browse_more_scale = (IF(one+two+three) IS 0,0,three/one+two+three) "," WHERE store_id = ",storeId," and day = date_format(now(),'%y-%m-%d')");




-- 	UPDATE sta_store_day set browse_one_scale = (one/one+two+three) WHERE store;
		
		

  END LOOP;
  -- 关闭游标
  CLOSE cur;
	

END