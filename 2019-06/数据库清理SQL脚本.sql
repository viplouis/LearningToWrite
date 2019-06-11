-- DELETE * FROM table_name

-- 清空门店点赞表
DELETE * FROM store_praise
 
-- 清空门店评论表
DELETE * FROM store_collection
 
-- 清空门店收藏表
DELETE * FROM store_collection
 
-- 清空门店案例点赞表
DELETE * FROM store_case_praise
 
-- 清空门店案例评论表
DELETE * FROM store_case_comment

-- 清空门店案例收藏表（目前的业务已经不存在案例收藏的逻辑，可删除此表）
DELETE * FROM store_case_collection

-- 清空门店案例表
DELETE * FROM store_case

-- 清空门店加入联盟表
DELETE * FROM store_aliance_enter

-- 清空门店退出联盟表
DELETE * FROM store_aliance_out

-- 清空门店联盟关系表
DELETE * FROM store_body_aliance

-- 清空联盟收藏表
DELETE * FROM aliance_collection

-- 清空联盟表
DELETE * FROM store_aliance

-- 清空门店表
DELETE * FROM store_body


DELETE * FROM holder_sale
DELETE * FROM holder_store
DELETE * FROM holder_aliance


-- sys_minapp_user 表是否考虑重新授权一下






 