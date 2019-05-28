CREATE DEFINER=`root`@`%` PROCEDURE `storeComprehensiveData`()
BEGIN
	#Routine body goes here...

-- 	需要定义接收游标数据的变量
  DECLARE storeId VARCHAR(20);
  DECLARE viewSum VARCHAR(11);
  DECLARE praiseSum VARCHAR(11);
	DECLARE commentSum VARCHAR(11);
  DECLARE collectionSum VARCHAR(11);
  

  -- 遍历数据结束标志
  DECLARE done INT DEFAULT FALSE;
  DECLARE cur CURSOR FOR SELECT store_id,view,praise,comment,collection from store_body where 1 = 1;
  -- 将结束标志绑定到游标
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  -- 打开游标
  OPEN cur;
  -- 开始循环
  read_loop: LOOP
    -- 提取游标里的数据
    FETCH cur INTO storeId,viewSum,praiseSum,commentSum,collectionSum;
	
    -- 声明结束的时候
    IF done THEN
      LEAVE read_loop;
    END IF;
    -- 这里做你想做的循环的事件
		-- 从门店表获取所有门店id,如果门店统计表中不存在某门店id则插入，存在则不做操作
-- 		insert ignore into sta_store_whole (store_id) values (storeId);
		
		REPLACE INTO sta_store_whole (store_id,view_sum,praise_sum,comment_sum,collection_sum) VALUES (storeId,viewSum,praiseSum,commentSum,collectionSum);
		
		
		
		
  END LOOP;
  -- 关闭游标
  CLOSE cur;
	

END