CREATE DEFINER=`yz_dev`@`%` PROCEDURE `staStoreRadar`()
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
		
-- 		MySQL产生min到max之间的随机数
-- 		floor(min+(RAND()*(max-min+1)))
		
		INSERT IGNORE INTO sta_store_radar (store_id,month,customer_interact,sales_initiative,get_customer_ability,brand_promotion,customer_satisfaction,platform_glamour) VALUES (storeId, NOW(),floor(50+(RAND()*(21))),floor(50+(RAND()*(21))),floor(50+(RAND()*(21))),floor(50+(RAND()*(21))),floor(50+(RAND()*(21))),floor(50+(RAND()*(21))));	
		
		
  END LOOP;
  -- 关闭游标
  CLOSE cur;
	

END