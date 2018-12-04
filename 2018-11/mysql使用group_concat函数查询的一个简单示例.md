## mysql使用group_concat函数查询的一个简单示例

SELECT timing_id,shop_id,ad_timing.sale_channel,ad_timing.parent_user_id,ad_timing.user_id,start_time,end_time,bid,timing_type,timing_type_id,create_time,last_update_time,remarks,is_delete,timing_switch,group_concat(start_time,';',end_time,";",bid) as period from ad_timing
		inner join temp_shopId_ad_timing_data
		on ad_timing.shop_id=temp_shopId_ad_timing_data.shopId
		WHERE ad_timing.`user_id`= userId AND ad_timing.`sale_channel`= saleChannel GROUP BY timing_type,timing_type_id;