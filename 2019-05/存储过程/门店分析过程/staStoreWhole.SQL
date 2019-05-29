CREATE DEFINER=`yz_dev`@`%` PROCEDURE `staStoreWhole`()
BEGIN
	#Routine body goes here...

-- 	需要定义接收游标数据的变量
  DECLARE storeId VARCHAR(20);
  DECLARE viewSum VARCHAR(11);
  DECLARE praiseSum VARCHAR(11);
  DECLARE collectionSum VARCHAR(11);
  DECLARE commentSum VARCHAR(11);

  -- 遍历数据结束标志
  DECLARE done INT DEFAULT FALSE;
  DECLARE cur CURSOR FOR SELECT store_id,view,praise,collection,comment from store_body where 1 = 1;
  -- 将结束标志绑定到游标
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  -- 打开游标
  OPEN cur;
  -- 开始循环
  read_loop: LOOP
    -- 提取游标里的数据
    FETCH cur INTO storeId,viewSum,praiseSum,collectionSum,commentSum;
	
    -- 声明结束的时候
    IF done THEN
      LEAVE read_loop;
    END IF;
    -- 这里做你想做的循环的事件
		-- 从门店表获取所有门店id,如果门店统计表中不存在某门店id则插入，存在则不做操作
-- 		insert ignore into sta_store_whole (store_id) values (storeId);
		
		INSERT IGNORE INTO sta_store_whole (store_id,view_sum,praise_sum,comment_sum,collection_sum) VALUES (storeId,viewSum,praiseSum,collectionSum,commentSum);
		
		-- 统计门店销售数
		SET @sqlStrViewCount = CONCAT("UPDATE sta_store_whole ssw set ssw.sale_sum = ( SELECT count(*) AS num FROM sale_info si WHERE si.store_id = ",storeId," ) WHERE ssw.store_id = ",storeId);
    PREPARE stmtView from @sqlStrViewCount;
    EXECUTE stmtView;
    DEALLOCATE PREPARE stmtView;  
		
		-- 统计门店预约单数
		SET @sqlStrReserveCount = CONCAT("UPDATE sta_store_whole ssw set ssw.reserve_sum = ( SELECT(IF(( SELECT sum(reserve_sum) AS num FROM sta_product_whole spw WHERE spw.store_id = ",storeId," ) IS NULL,0,( SELECT sum(reserve_sum) AS num FROM sta_product_whole spw WHERE spw.store_id = ",storeId," ))) t) WHERE ssw.store_id = ",storeId);
    PREPARE stmtReserve from @sqlStrReserveCount;
    EXECUTE stmtReserve;
    DEALLOCATE PREPARE stmtReserve;  

		-- 统计门店订单数
		SET @sqlStrOrderCount = CONCAT("UPDATE sta_store_whole ssw set ssw.order_sum = (SELECT(IF(( SELECT sum( order_sum ) AS num FROM sta_product_whole spw WHERE spw.store_id = ",storeId," ) IS NULL,0,( SELECT sum( order_sum ) AS num FROM sta_product_whole spw WHERE spw.store_id = ",storeId," ))) t) WHERE ssw.store_id = ",storeId);
    PREPARE stmtOrder from @sqlStrOrderCount;
    EXECUTE stmtOrder;
    DEALLOCATE PREPARE stmtOrder;  
		
		-- 统计门店客户数
		SET @sqlStrCustomerCount = CONCAT("UPDATE sta_store_whole ssw set ssw.customer_sum = (SELECT count(*) FROM( select count(*) from order_reserve where status = 3 and store_id = ",storeId," GROUP BY user_id",") t ) WHERE ssw.store_id = ",storeId);
    PREPARE stmtCustomer from @sqlStrCustomerCount;
    EXECUTE stmtCustomer;
    DEALLOCATE PREPARE stmtCustomer;  
		
		
		-- 统计顾客到店数
		SET @sqlStrArrivalCount = CONCAT("UPDATE sta_store_whole ssw set ssw.arrival_sum = ( SELECT count(*) AS num FROM order_records orc,order_reserve ors WHERE orc.order_id = ors.id and orc.status = 1 and ors.store_id = ",storeId," ) WHERE ssw.store_id = ",storeId);
    PREPARE stmtArrival from @sqlStrArrivalCount;
    EXECUTE stmtArrival;
    DEALLOCATE PREPARE stmtArrival;  

		
		
		
  END LOOP;
  -- 关闭游标
  CLOSE cur;
	

END