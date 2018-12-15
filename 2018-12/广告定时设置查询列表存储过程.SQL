CREATE DEFINER=`root`@`%` PROCEDURE `getHostingTypeList`( 
    IN `userId` INT,
		IN `loginUserId` INT,
		IN `shopId` INT,
    IN `saleChannel` VARCHAR(20),
    IN userType VARCHAR(20),
		IN hostingType VARCHAR(20),
		IN hostingTypeId VARCHAR(30),
		IN name VARCHAR(100),
		IN hostingStatus VARCHAR(20),
		IN currentPage INT,
		IN pageSize INT
		
    )
BEGIN
    #临时表，判断这个用户是子账号，还是主账号
	CREATE TEMPORARY TABLE  IF NOT EXISTS temp_shopId_ad_timing_data(shopId INT,parent_user_id INT,sale_channel VARCHAR(50) );
	TRUNCATE TABLE temp_shopId_ad_timing_data;
	
	#主账号
	IF userType='PriAccount' THEN
		#准备工作，找到这个主账号的所有激活的店铺信息
		INSERT INTO temp_shopId_ad_timing_data(shopId,parent_user_id)
		SELECT shop_id,user_id FROM shop_info i WHERE i.`state`='1' AND i.user_id=userId;

	END IF;
	#子账号
	IF userType='SubAccount' THEN
		INSERT INTO temp_shopId_ad_timing_data(shopId,parent_user_id,sale_channel)
		SELECT i.shop_id,i.`user_ID`,sub.`sale_channel` FROM shop_info i INNER JOIN sub_user_authority sub ON i.`user_ID`=sub.`parent_user_id` AND i.`shop_Id`=sub.`shop_id` WHERE i.`user_ID`=userId AND i.`state`='1' AND sub.`user_id`=loginUserId;

	END IF; 
	
	
	IF userType='PriAccount' THEN
	
		IF (hostingStatus = 'all' && name = 'blankNull') THEN
			SELECT timing_id,shop_id,ad_timing.sale_channel,ad_timing.parent_user_id,ad_timing.user_id,start_time,end_time,bid,timing_type,timing_type_id,create_time,last_update_time,remarks,is_delete,timing_switch,targeting_type,campaign_id,campaign_name,ad_group_id,ad_group_name,ad_id,sku,asin,keyword_id,keyword_text,group_concat(" ",start_time,' - ',end_time,"  出价: ",bid) as period from ad_timing
		inner join temp_shopId_ad_timing_data
		on ad_timing.shop_id=temp_shopId_ad_timing_data.shopId
		WHERE ad_timing.`user_id`= userId AND ad_timing.`shop_id`= shopId AND ad_timing.`sale_channel`= saleChannel AND ad_timing.`timing_type`=hostingType GROUP BY timing_type,timing_type_id;
		ELSEIF(hostingStatus != 'all' && name = 'blankNull') THEN
			SELECT timing_id,shop_id,ad_timing.sale_channel,ad_timing.parent_user_id,ad_timing.user_id,start_time,end_time,bid,timing_type,timing_type_id,create_time,last_update_time,remarks,is_delete,timing_switch,targeting_type,campaign_id,campaign_name,ad_group_id,ad_group_name,ad_id,sku,asin,keyword_id,keyword_text,group_concat(" ",start_time,' - ',end_time,"  出价: ",bid) as period from ad_timing
		inner join temp_shopId_ad_timing_data
		on ad_timing.shop_id=temp_shopId_ad_timing_data.shopId
		WHERE ad_timing.`user_id`= userId AND ad_timing.`shop_id`= shopId AND ad_timing.`sale_channel`= saleChannel AND ad_timing.`timing_type`=hostingType AND ad_timing.`timing_switch` = hostingStatus GROUP BY timing_type,timing_type_id;
		ELSEIF(hostingStatus = 'all' && name != 'blankNull')  THEN
				 CASE hostingType  
            WHEN 'campaigns' THEN  
                SELECT timing_id,shop_id,ad_timing.sale_channel,ad_timing.parent_user_id,ad_timing.user_id,start_time,end_time,bid,timing_type,timing_type_id,create_time,last_update_time,remarks,is_delete,timing_switch,targeting_type,campaign_id,campaign_name,ad_group_id,ad_group_name,ad_id,sku,asin,keyword_id,keyword_text,group_concat(" ",start_time,' - ',end_time,"  出价: ",bid) as period from ad_timing
		inner join temp_shopId_ad_timing_data
		on ad_timing.shop_id=temp_shopId_ad_timing_data.shopId
		WHERE ad_timing.`user_id`= userId AND ad_timing.`shop_id`= shopId AND ad_timing.`sale_channel`= saleChannel AND ad_timing.`timing_type`=hostingType AND ad_timing.`campaign_name` = name GROUP BY timing_type,timing_type_id; 
            WHEN 'adgroups' THEN  
                SELECT timing_id,shop_id,ad_timing.sale_channel,ad_timing.parent_user_id,ad_timing.user_id,start_time,end_time,bid,timing_type,timing_type_id,create_time,last_update_time,remarks,is_delete,timing_switch,targeting_type,campaign_id,campaign_name,ad_group_id,ad_group_name,ad_id,sku,asin,keyword_id,keyword_text,group_concat(" ",start_time,' - ',end_time,"  出价: ",bid) as period from ad_timing
		inner join temp_shopId_ad_timing_data
		on ad_timing.shop_id=temp_shopId_ad_timing_data.shopId
		WHERE ad_timing.`user_id`= userId AND ad_timing.`shop_id`= shopId AND ad_timing.`sale_channel`= saleChannel AND ad_timing.`timing_type`=hostingType AND ad_timing.`ad_group_name` = name GROUP BY timing_type,timing_type_id; 
            WHEN 'productads' THEN  
                SELECT timing_id,shop_id,ad_timing.sale_channel,ad_timing.parent_user_id,ad_timing.user_id,start_time,end_time,bid,timing_type,timing_type_id,create_time,last_update_time,remarks,is_delete,timing_switch,targeting_type,campaign_id,campaign_name,ad_group_id,ad_group_name,ad_id,sku,asin,keyword_id,keyword_text,group_concat(" ",start_time,' - ',end_time,"  出价: ",bid) as period from ad_timing
		inner join temp_shopId_ad_timing_data
		on ad_timing.shop_id=temp_shopId_ad_timing_data.shopId
		WHERE ad_timing.`user_id`= userId AND ad_timing.`shop_id`= shopId AND ad_timing.`sale_channel`= saleChannel AND ad_timing.`timing_type`=hostingType AND ad_timing.`sku` = name OR ad_timing.`asin` = name GROUP BY timing_type,timing_type_id;  
            WHEN 'keywords' THEN  
                SELECT timing_id,shop_id,ad_timing.sale_channel,ad_timing.parent_user_id,ad_timing.user_id,start_time,end_time,bid,timing_type,timing_type_id,create_time,last_update_time,remarks,is_delete,timing_switch,targeting_type,campaign_id,campaign_name,ad_group_id,ad_group_name,ad_id,sku,asin,keyword_id,keyword_text,group_concat(" ",start_time,' - ',end_time,"  出价: ",bid) as period from ad_timing
		inner join temp_shopId_ad_timing_data
		on ad_timing.shop_id=temp_shopId_ad_timing_data.shopId
		WHERE ad_timing.`user_id`= userId AND ad_timing.`shop_id`= shopId AND ad_timing.`sale_channel`= saleChannel AND ad_timing.`timing_type`=hostingType AND ad_timing.`keyword_text` = name GROUP BY timing_type,timing_type_id; 
        END CASE;
				
				ELSEIF(hostingStatus != 'all' && name != 'blankNull')  THEN
				 CASE hostingType  
            WHEN 'campaigns' THEN  
                SELECT timing_id,shop_id,ad_timing.sale_channel,ad_timing.parent_user_id,ad_timing.user_id,start_time,end_time,bid,timing_type,timing_type_id,create_time,last_update_time,remarks,is_delete,timing_switch,targeting_type,campaign_id,campaign_name,ad_group_id,ad_group_name,ad_id,sku,asin,keyword_id,keyword_text,group_concat(" ",start_time,' - ',end_time,"  出价: ",bid) as period from ad_timing
		inner join temp_shopId_ad_timing_data
		on ad_timing.shop_id=temp_shopId_ad_timing_data.shopId
		WHERE ad_timing.`user_id`= userId AND ad_timing.`shop_id`= shopId AND ad_timing.`sale_channel`= saleChannel AND ad_timing.`timing_type`=hostingType AND ad_timing.`timing_switch` = hostingStatus AND ad_timing.`campaign_name` = name GROUP BY timing_type,timing_type_id; 
            WHEN 'adgroups' THEN  
                SELECT timing_id,shop_id,ad_timing.sale_channel,ad_timing.parent_user_id,ad_timing.user_id,start_time,end_time,bid,timing_type,timing_type_id,create_time,last_update_time,remarks,is_delete,timing_switch,targeting_type,campaign_id,campaign_name,ad_group_id,ad_group_name,ad_id,sku,asin,keyword_id,keyword_text,group_concat(" ",start_time,' - ',end_time,"  出价: ",bid) as period from ad_timing
		inner join temp_shopId_ad_timing_data
		on ad_timing.shop_id=temp_shopId_ad_timing_data.shopId
		WHERE ad_timing.`user_id`= userId AND ad_timing.`shop_id`= shopId AND ad_timing.`sale_channel`= saleChannel AND ad_timing.`timing_type`=hostingType AND ad_timing.`timing_switch` = hostingStatus AND ad_timing.`ad_group_name` = name GROUP BY timing_type,timing_type_id; 
            WHEN 'productads' THEN  
                SELECT timing_id,shop_id,ad_timing.sale_channel,ad_timing.parent_user_id,ad_timing.user_id,start_time,end_time,bid,timing_type,timing_type_id,create_time,last_update_time,remarks,is_delete,timing_switch,targeting_type,campaign_id,campaign_name,ad_group_id,ad_group_name,ad_id,sku,asin,keyword_id,keyword_text,group_concat(" ",start_time,' - ',end_time,"  出价: ",bid) as period from ad_timing
		inner join temp_shopId_ad_timing_data
		on ad_timing.shop_id=temp_shopId_ad_timing_data.shopId
		WHERE ad_timing.`user_id`= userId AND ad_timing.`shop_id`= shopId AND ad_timing.`sale_channel`= saleChannel AND ad_timing.`timing_type`=hostingType AND ad_timing.`timing_switch` = hostingStatus AND ad_timing.`sku` = name OR ad_timing.`asin` = name GROUP BY timing_type,timing_type_id;  
            WHEN 'keywords' THEN  
                SELECT timing_id,shop_id,ad_timing.sale_channel,ad_timing.parent_user_id,ad_timing.user_id,start_time,end_time,bid,timing_type,timing_type_id,create_time,last_update_time,remarks,is_delete,timing_switch,targeting_type,campaign_id,campaign_name,ad_group_id,ad_group_name,ad_id,sku,asin,keyword_id,keyword_text,group_concat(" ",start_time,' - ',end_time,"  出价: ",bid) as period from ad_timing
		inner join temp_shopId_ad_timing_data
		on ad_timing.shop_id=temp_shopId_ad_timing_data.shopId
		WHERE ad_timing.`user_id`= userId AND ad_timing.`shop_id`= shopId AND ad_timing.`sale_channel`= saleChannel AND ad_timing.`timing_type`=hostingType AND ad_timing.`timing_switch` = hostingStatus AND ad_timing.`keyword_text` = name GROUP BY timing_type,timing_type_id; 
        END CASE;  
				
		END IF;
		
-- 	子账号
	 ELSE
	 
	 		IF (hostingStatus = 'all' && name = 'blankNull') THEN
			SELECT timing_id,shop_id,ad_timing.sale_channel,ad_timing.parent_user_id,ad_timing.user_id,start_time,end_time,bid,timing_type,timing_type_id,create_time,last_update_time,remarks,is_delete,timing_switch,targeting_type,campaign_id,campaign_name,ad_group_id,ad_group_name,ad_id,sku,asin,keyword_id,keyword_text,group_concat(" ",start_time,' - ',end_time,"  出价: ",bid) as period from ad_timing
		inner join temp_shopId_ad_timing_data
		on ad_timing.shop_id=temp_shopId_ad_timing_data.shopId
		WHERE ad_timing.`user_id`= userId AND ad_timing.`shop_id`= shopId AND ad_timing.`sale_channel`= saleChannel AND ad_timing.`timing_type`=hostingType GROUP BY timing_type,timing_type_id;
		ELSEIF(hostingStatus != 'all' && name = 'blankNull') THEN
			SELECT timing_id,shop_id,ad_timing.sale_channel,ad_timing.parent_user_id,ad_timing.user_id,start_time,end_time,bid,timing_type,timing_type_id,create_time,last_update_time,remarks,is_delete,timing_switch,targeting_type,campaign_id,campaign_name,ad_group_id,ad_group_name,ad_id,sku,asin,keyword_id,keyword_text,group_concat(" ",start_time,' - ',end_time,"  出价: ",bid) as period from ad_timing
		inner join temp_shopId_ad_timing_data
		on ad_timing.shop_id=temp_shopId_ad_timing_data.shopId
		WHERE ad_timing.`user_id`= userId AND ad_timing.`shop_id`= shopId AND ad_timing.`sale_channel`= saleChannel AND ad_timing.`timing_type`=hostingType AND ad_timing.`timing_switch` = hostingStatus GROUP BY timing_type,timing_type_id;
		ELSEIF(hostingStatus = 'all' && name != 'blankNull')  THEN
				 CASE hostingType  
            WHEN 'campaigns' THEN  
                SELECT timing_id,shop_id,ad_timing.sale_channel,ad_timing.parent_user_id,ad_timing.user_id,start_time,end_time,bid,timing_type,timing_type_id,create_time,last_update_time,remarks,is_delete,timing_switch,targeting_type,campaign_id,campaign_name,ad_group_id,ad_group_name,ad_id,sku,asin,keyword_id,keyword_text,group_concat(" ",start_time,' - ',end_time,"  出价: ",bid) as period from ad_timing
		inner join temp_shopId_ad_timing_data
		on ad_timing.shop_id=temp_shopId_ad_timing_data.shopId
		WHERE ad_timing.`user_id`= userId AND ad_timing.`shop_id`= shopId AND ad_timing.`sale_channel`= saleChannel AND ad_timing.`timing_type`=hostingType AND ad_timing.`campaign_name` = name GROUP BY timing_type,timing_type_id; 
            WHEN 'adgroups' THEN  
                SELECT timing_id,shop_id,ad_timing.sale_channel,ad_timing.parent_user_id,ad_timing.user_id,start_time,end_time,bid,timing_type,timing_type_id,create_time,last_update_time,remarks,is_delete,timing_switch,targeting_type,campaign_id,campaign_name,ad_group_id,ad_group_name,ad_id,sku,asin,keyword_id,keyword_text,group_concat(" ",start_time,' - ',end_time,"  出价: ",bid) as period from ad_timing
		inner join temp_shopId_ad_timing_data
		on ad_timing.shop_id=temp_shopId_ad_timing_data.shopId
		WHERE ad_timing.`user_id`= userId AND ad_timing.`shop_id`= shopId AND ad_timing.`sale_channel`= saleChannel AND ad_timing.`timing_type`=hostingType AND ad_timing.`ad_group_name` = name GROUP BY timing_type,timing_type_id; 
            WHEN 'productads' THEN  
                SELECT timing_id,shop_id,ad_timing.sale_channel,ad_timing.parent_user_id,ad_timing.user_id,start_time,end_time,bid,timing_type,timing_type_id,create_time,last_update_time,remarks,is_delete,timing_switch,targeting_type,campaign_id,campaign_name,ad_group_id,ad_group_name,ad_id,sku,asin,keyword_id,keyword_text,group_concat(" ",start_time,' - ',end_time,"  出价: ",bid) as period from ad_timing
		inner join temp_shopId_ad_timing_data
		on ad_timing.shop_id=temp_shopId_ad_timing_data.shopId
		WHERE ad_timing.`user_id`= userId AND ad_timing.`shop_id`= shopId AND ad_timing.`sale_channel`= saleChannel AND ad_timing.`timing_type`=hostingType AND ad_timing.`sku` = name OR ad_timing.`asin` = name GROUP BY timing_type,timing_type_id;  
            WHEN 'keywords' THEN  
                SELECT timing_id,shop_id,ad_timing.sale_channel,ad_timing.parent_user_id,ad_timing.user_id,start_time,end_time,bid,timing_type,timing_type_id,create_time,last_update_time,remarks,is_delete,timing_switch,targeting_type,campaign_id,campaign_name,ad_group_id,ad_group_name,ad_id,sku,asin,keyword_id,keyword_text,group_concat(" ",start_time,' - ',end_time,"  出价: ",bid) as period from ad_timing
		inner join temp_shopId_ad_timing_data
		on ad_timing.shop_id=temp_shopId_ad_timing_data.shopId
		WHERE ad_timing.`user_id`= userId AND ad_timing.`shop_id`= shopId AND ad_timing.`sale_channel`= saleChannel AND ad_timing.`timing_type`=hostingType AND ad_timing.`keyword_text` = name GROUP BY timing_type,timing_type_id; 
        END CASE;
				
				ELSEIF(hostingStatus != 'all' && name != 'blankNull')  THEN
				 CASE hostingType  
            WHEN 'campaigns' THEN  
                SELECT timing_id,shop_id,ad_timing.sale_channel,ad_timing.parent_user_id,ad_timing.user_id,start_time,end_time,bid,timing_type,timing_type_id,create_time,last_update_time,remarks,is_delete,timing_switch,targeting_type,campaign_id,campaign_name,ad_group_id,ad_group_name,ad_id,sku,asin,keyword_id,keyword_text,group_concat(" ",start_time,' - ',end_time,"  出价: ",bid) as period from ad_timing
		inner join temp_shopId_ad_timing_data
		on ad_timing.shop_id=temp_shopId_ad_timing_data.shopId
		WHERE ad_timing.`user_id`= userId AND ad_timing.`shop_id`= shopId AND ad_timing.`sale_channel`= saleChannel AND ad_timing.`timing_type`=hostingType AND ad_timing.`timing_switch` = hostingStatus AND ad_timing.`campaign_name` = name GROUP BY timing_type,timing_type_id; 
            WHEN 'adgroups' THEN  
                SELECT timing_id,shop_id,ad_timing.sale_channel,ad_timing.parent_user_id,ad_timing.user_id,start_time,end_time,bid,timing_type,timing_type_id,create_time,last_update_time,remarks,is_delete,timing_switch,targeting_type,campaign_id,campaign_name,ad_group_id,ad_group_name,ad_id,sku,asin,keyword_id,keyword_text,group_concat(" ",start_time,' - ',end_time,"  出价: ",bid) as period from ad_timing
		inner join temp_shopId_ad_timing_data
		on ad_timing.shop_id=temp_shopId_ad_timing_data.shopId
		WHERE ad_timing.`user_id`= userId AND ad_timing.`shop_id`= shopId AND ad_timing.`sale_channel`= saleChannel AND ad_timing.`timing_type`=hostingType AND ad_timing.`timing_switch` = hostingStatus AND ad_timing.`ad_group_name` = name GROUP BY timing_type,timing_type_id; 
            WHEN 'productads' THEN  
                SELECT timing_id,shop_id,ad_timing.sale_channel,ad_timing.parent_user_id,ad_timing.user_id,start_time,end_time,bid,timing_type,timing_type_id,create_time,last_update_time,remarks,is_delete,timing_switch,targeting_type,campaign_id,campaign_name,ad_group_id,ad_group_name,ad_id,sku,asin,keyword_id,keyword_text,group_concat(" ",start_time,' - ',end_time,"  出价: ",bid) as period from ad_timing
		inner join temp_shopId_ad_timing_data
		on ad_timing.shop_id=temp_shopId_ad_timing_data.shopId
		WHERE ad_timing.`user_id`= userId AND ad_timing.`shop_id`= shopId AND ad_timing.`sale_channel`= saleChannel AND ad_timing.`timing_type`=hostingType AND ad_timing.`timing_switch` = hostingStatus AND ad_timing.`sku` = name OR ad_timing.`asin` = name GROUP BY timing_type,timing_type_id;  
            WHEN 'keywords' THEN  
                SELECT timing_id,shop_id,ad_timing.sale_channel,ad_timing.parent_user_id,ad_timing.user_id,start_time,end_time,bid,timing_type,timing_type_id,create_time,last_update_time,remarks,is_delete,timing_switch,targeting_type,campaign_id,campaign_name,ad_group_id,ad_group_name,ad_id,sku,asin,keyword_id,keyword_text,group_concat(" ",start_time,' - ',end_time,"  出价: ",bid) as period from ad_timing
		inner join temp_shopId_ad_timing_data
		on ad_timing.shop_id=temp_shopId_ad_timing_data.shopId
		WHERE ad_timing.`user_id`= userId AND ad_timing.`shop_id`= shopId AND ad_timing.`sale_channel`= saleChannel AND ad_timing.`timing_type`=hostingType AND ad_timing.`timing_switch` = hostingStatus AND ad_timing.`keyword_text` = name GROUP BY timing_type,timing_type_id; 
        END CASE;  
				
		END IF;
	

	 
	 END IF;
	 

	 
	 
    END