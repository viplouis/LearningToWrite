/*
 Navicat Premium Data Transfer

 Source Server         : 120.24.24.227 [成果云 root]
 Source Server Type    : MySQL
 Source Server Version : 80019
 Source Host           : 120.24.24.227:36030
 Source Schema         : nacos

 Target Server Type    : MySQL
 Target Server Version : 80019
 File Encoding         : 65001

 Date: 26/02/2021 01:24:13
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for config_info
-- ----------------------------
DROP TABLE IF EXISTS `config_info`;
CREATE TABLE `config_info`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `data_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT 'data_id',
  `group_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL,
  `content` longtext CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT 'content',
  `md5` varchar(32) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT 'md5',
  `gmt_create` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `gmt_modified` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  `src_user` text CHARACTER SET utf8 COLLATE utf8_bin NULL COMMENT 'source user',
  `src_ip` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT 'source ip',
  `app_name` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL,
  `tenant_id` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT '' COMMENT '租户字段',
  `c_desc` varchar(256) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL,
  `c_use` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL,
  `effect` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL,
  `type` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL,
  `c_schema` text CHARACTER SET utf8 COLLATE utf8_bin NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_configinfo_datagrouptenant`(`data_id`, `group_id`, `tenant_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 95 CHARACTER SET = utf8 COLLATE = utf8_bin COMMENT = 'config_info' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of config_info
-- ----------------------------
INSERT INTO `config_info` VALUES (1, 'application-gateway.yaml', 'DEFAULT_GROUP', '\r\nspring:\r\n  application:\r\n    name: chengguoyun-gateway\r\n  datasource:\r\n    url: jdbc:mysql://db:3306/chengguoyun?serverTimezone=GMT%2B8&zeroDateTimeBehavior=convertToNull&useUnicode=true&characterEncoding=utf8&useSSL=false&allowMultiQueries=true\r\n    username: chengguoyun\r\n    password: )!N52@=^%(rh\r\n    driver-class-name: com.mysql.cj.jdbc.Driver\r\n    druid:\r\n      \r\n      initial-size: 5\r\n      \r\n      min-idle: 5\r\n      \r\n      max-active: 20\r\n      \r\n      max-wait: 60000\r\n     \r\n      test-while-idle: true\r\n      \r\n      time-between-eviction-runs-millis: 60000\r\n      \r\n      min-evictable-idle-time-millis: 30000\r\n      \r\n      validation-query: select \'x\'\r\n      \r\n      test-on-borrow: false\r\n      \r\n      test-on-return: false\r\n      \r\n      \r\n      pool-prepared-statements: true\r\n      \r\n      max-pool-prepared-statement-per-connection-size: 20\r\n     \r\n      filters: stat #,wall\r\n      \r\n      connection-properties: druid.stat.mergeSql=true;druid.stat.slowSqlMillis=5000\r\n      \r\n      use-global-data-source-stat: true\r\n      \r\n      stat-view-servlet.login-username: admin\r\n      stat-view-servlet.login-password: admin\r\n      keepAlive: true\r\n  redis:\r\n \r\n    host: redis-1\r\n    port: 6379\r\n    timeout: 60000\r\n    password: +CDvdHkuUcsN\r\n   \r\n\r\n  cloud:\r\n    gateway:\r\n      discovery:\r\n        locator:\r\n          enabled: false  \r\n          lower-case-service-id: true  \r\n      routes:\r\n      \r\n        - id: chengguoyun-center\r\n          uri: lb://chengguoyun-center\r\n          predicates:\r\n            - Path=/center/** \r\n          filters:\r\n            - StripPrefix=1\r\n       \r\n        - id: chengguoyun-policy\r\n          uri: lb://chengguoyun-policy\r\n          predicates:\r\n            - Path=/policy/**\r\n          filters:\r\n            - StripPrefix=1\r\n       \r\n        - id: chengguoyun-crm\r\n          uri: lb://chengguoyun-crm\r\n          predicates:\r\n            - Path=/crm/**\r\n          filters:\r\n            - StripPrefix=1\r\n\r\n        - id: chengguoyun-filelibrary\r\n          uri: lb://chengguoyun-filelibrary\r\n          predicates:\r\n            - Path=/filelibrary/**\r\n          filters:\r\n            - StripPrefix=1    \r\n\r\n        - id: chengguoyun-message\r\n          uri: lb://chengguoyun-message\r\n          predicates:\r\n            - Path=/message/**\r\n          filters:\r\n            - StripPrefix=1    \r\n\r\n\r\nfeign:\r\n  hystrix:\r\n    enabled: true\r\n  client:\r\n    config:\r\n      default:\r\n        connectTimeout: 60000\r\n        readTimeout: 20000\r\n        loggerLevel: full\r\n       \r\n\r\nhystrix:\r\n  shareSecurityContext: true\r\n\r\nsecurity:\r\n  oauth2:\r\n    resource:\r\n      loadBalanced: true\r\n      id: gateway-policy-dev\r\n      user-info-uri: http://chengguoyun-center/auth-controller/user/member\r\n      prefer-token-info: false\r\n\r\nlogging: \r\n  config: classpath:logback-custom.xml', '2e85700404c3fd8efdd34f16558f45cf', '2020-06-23 04:28:52', '2020-12-29 17:56:37', NULL, '119.126.114.96', '', '', '', '', '', 'yaml', '');
INSERT INTO `config_info` VALUES (8, 'application-center.yaml', 'DEFAULT_GROUP', '\r\nuser:\r\n  password:\r\n   \r\n    maxRetryCount: 5\r\n\r\n\r\nspring:\r\n  application:\r\n    name: chengguoyun-center\r\n  messages:\r\n    basename: static/i18n/messages\r\n  jackson:\r\n    time-zone: GMT+8\r\n    date-format: yyyy-MM-dd HH:mm:ss\r\n    default-property-inclusion: non_null\r\n  servlet:\r\n    multipart:\r\n     \r\n      max-file-size:  10MB\r\n\r\n      max-request-size:  20MB\r\n  datasource:\r\n    type: com.alibaba.druid.pool.DruidDataSource\r\n    driverClassName: com.mysql.cj.jdbc.Driver\r\n    druid:\r\n      url: jdbc:mysql://db:3306/chengguoyun?serverTimezone=GMT%2B8&zeroDateTimeBehavior=convertToNull&useUnicode=true&characterEncoding=utf8&useSSL=false&allowMultiQueries=true\r\n      username: chengguoyun\r\n      password: )!N52@=^%(rh\r\n      initialSize: 5\r\n      minIdle: 10\r\n      maxActive: 20\r\n      maxWait: 60000\r\n\r\n      timeBetweenEvictionRunsMillis: 60000\r\n\r\n      minEvictableIdleTimeMillis: 300000\r\n\r\n      maxEvictableIdleTimeMillis: 900000\r\n \r\n      pool-prepared-statements: true\r\n      \r\n      max-pool-prepared-statement-per-connection-size: 20\r\n      validationQuery: SELECT 1 FROM DUAL\r\n      testWhileIdle: true\r\n      testOnBorrow: false\r\n      testOnReturn: false\r\n      webStatFilter:\r\n        enabled: true\r\n      statViewServlet:\r\n        enabled: true\r\n    \r\n        allow:\r\n        url-pattern: /druid/*\r\n        \r\n        login-username:\r\n        login-password:\r\n      filter:\r\n        stat:\r\n          enabled: true\r\n         \r\n          log-slow-sql: true\r\n          slow-sql-millis: 1000\r\n          merge-sql: true\r\n        wall:\r\n          config:\r\n            multi-statement-allow: true\r\n\r\n  redis:\r\n\r\n    port: 6379\r\n    timeout: 60000\r\n    host: redis-1\r\n    password: +CDvdHkuUcsN\r\nmybatis-plus:\r\n\r\n  typeAliasesPackage: com.pdm.**.domain\r\n\r\n  mapperLocations: classpath*:mapper/**/*Mapper.xml\r\n\r\n  configLocation: classpath:mybatis/mybatis-config.xml\r\n  global-config:\r\n    id-type: 2\r\n    field-strategy: 2\r\n    db-column-underline: true\r\n    refresh-mapper: true\r\n    enableSqlRunner: true\r\npagehelper:\r\n  helperDialect: mysql\r\n  reasonable: true\r\n  supportMethodsArguments: true\r\n  params: count=countSql\r\n\r\n\r\nxss:\r\n\r\n  enabled: true\r\n\r\n  excludes: /system/notice/*\r\n\r\n  urlPatterns: /system/*,/monitor/*,/tool/*\r\n\r\nhystrix:\r\n  shareSecurityContext: true\r\n\r\nlingxin:\r\n  controllerEncryptEnabled: false\r\n  sysLogEnabled: true\r\n  sysQueryLogEnabled: false\r\n\r\noauth2:\r\n  social:\r\n    wechat:\r\n      #网页授权ClientId\r\n      clientId: wx2b4fbf55e9b81616\r\n      #网页授权密钥\r\n      clientSecret: 6f06f4c347250d29a9cc7f383d592866\r\n      #成功登录后跳转地址\r\n      redirectUri: http://www.chengguoyun.cn/center/social/login/weixin\r\n      #回调地址\r\n      bindingCallBackUri: http://www.chengguoyun.cn/center/social/socialWechatCallback\r\n\r\nweChatMini:\r\n  #小程序appId\r\n  appId: wx689076165649860c\r\n  #小程序密钥\r\n  appSecret: 3ddbea702b633127ca8a16e67bae6305\r\n  grantType: authorization_code\r\n\r\nlogging: \r\n  config: classpath:logback-custom.xml', '5aea7dd258be6540591bc77f58a96575', '2020-06-23 21:23:53', '2021-01-22 18:29:15', NULL, '113.72.18.224', '', '', '', '', '', 'yaml', '');
INSERT INTO `config_info` VALUES (10, 'application-policy.yaml', 'DEFAULT_GROUP', '\r\nspring:\r\n  application:\r\n    name: chengguoyun-policy\r\n  datasource:\r\n    url: jdbc:mysql://db:3306/chengguoyun?serverTimezone=GMT%2B8&zeroDateTimeBehavior=convertToNull&useUnicode=true&characterEncoding=utf8&useSSL=false&allowMultiQueries=true\r\n    username: chengguoyun\r\n    password: )!N52@=^%(rh\r\n    driver-class-name: com.mysql.cj.jdbc.Driver\r\n    druid:\r\n      \r\n      initialSize: 5\r\n      \r\n      minIdle: 10\r\n      \r\n      maxActive: 20\r\n      \r\n      maxWait: 60000\r\n      \r\n      timeBetweenEvictionRunsMillis: 60000\r\n     \r\n      minEvictableIdleTimeMillis: 300000\r\n      \r\n      maxEvictableIdleTimeMillis: 900000\r\n      \r\n      validationQuery: SELECT 1 FROM DUAL\r\n      testWhileIdle: true\r\n      testOnBorrow: false\r\n      testOnReturn: false\r\n      webStatFilter:\r\n        enabled: true\r\n      statViewServlet:\r\n        enabled: true\r\n        \r\n        allow:\r\n        url-pattern: /druid/*\r\n       \r\n        login-username:\r\n        login-password:\r\n      filter:\r\n        stat:\r\n          enabled: true\r\n          \r\n          log-slow-sql: true\r\n          slow-sql-millis: 1000\r\n          merge-sql: true\r\n        wall:\r\n          config:\r\n            multi-statement-allow: true\r\n\r\n  \r\n  redis:\r\n    \r\n    host: redis-1\r\n    port: 6379\r\n    timeout: 60000\r\n    password: +CDvdHkuUcsN\r\n\r\n\r\nfeign:\r\n  okhttp:\r\n    enabled: true\r\n  hystrix:\r\n    enabled: true\r\n  client:\r\n    config:\r\n      default:\r\n        connectTimeout: 60000\r\n        readTimeout: 60000\r\n        loggerLevel: BASIC\r\n##hystrix的超时时间\r\nhystrix:\r\n  shareSecurityContext: true\r\n  command: \r\n    default:\r\n      execution:\r\n        isolation: \r\n          thread: \r\n            timeoutInMilliseconds: 60000\r\n\r\n\r\nsecurity:\r\n  oauth2:\r\n    resource:\r\n      loadBalanced: true\r\n      id: gateway-policy-dev\r\n      user-info-uri: http://chengguoyun-center/auth-controller/user/member\r\n      prefer-token-info: true\r\n\r\n# 防止XSS攻击\r\nxss:\r\n  # 过滤开关\r\n  enabled: true\r\n  # 排除链接（多个用逗号分隔）\r\n  excludes: /system/notice/*\r\n  # 匹配链接\r\n  urlPatterns: /system/*,/monitor/*,/tool/*\r\n\r\n# logging:\r\n#   level:\r\n#     com.lingxin: debug\r\n#     org.springframework: debug\r\n# http://120.24.205.135:8888/center/auth-controller/user/member\r\n\r\nlingxin:\r\n  controllerEncryptEnabled: false\r\n  sysLogEnabled: false\r\n  sysQueryLogEnabled: false\r\n\r\nmybatis-plus:\r\n  global-config:\r\n    enableSqlRunner: true\r\n\r\naliyun:\r\n    oss:\r\n        accessKeyId: LTAI4FfimpNszv46oBxR51jk\r\n        accessKeySecret: 2SxfRFa54cZvFFeWQGw4ua6AikrkMx\r\n        bucketName: chengguoyun-java\r\n        callbackUrl: \'\'\r\n        endpoint: oss-cn-shenzhen.aliyuncs.com\r\n#        3分钟过期\r\n#        expireTime: 180000\r\n#        10分钟过期\r\n        expireTime: 600000\r\n        host: https://chengguoyun.oss-cn-shenzhen.aliyuncs.com/\r\n\r\n# cloudtoken 当前使用的测试账号的token，正式环境需要使用正式账号的token(需购买)\r\n# https://cloudconvert.com/\r\ncloudconvert:\r\n    cloudapi:\r\n        cloudtoken: eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjIwNjVmOGEyOGUxZmQwMTcwNmE1YTZkMmY2YjQ0ZmJmM2RkYzcwYmRkZTU4Y2RiOThiNGRlMTU5NGM3ODE4YWQzNjY5ZmNkZjgzZTgxYTk3In0.eyJhdWQiOiIxIiwianRpIjoiMjA2NWY4YTI4ZTFmZDAxNzA2YTVhNmQyZjZiNDRmYmYzZGRjNzBiZGRlNThjZGI5OGI0ZGUxNTk0Yzc4MThhZDM2NjlmY2RmODNlODFhOTciLCJpYXQiOjE1ODMzNzc1NDcsIm5iZiI6MTU4MzM3NzU0NywiZXhwIjo0NzM5MDUxMTQ3LCJzdWIiOiI0MDYwNjUyMCIsInNjb3BlcyI6WyJ1c2VyLnJlYWQiLCJ1c2VyLndyaXRlIiwidGFzay5yZWFkIiwidGFzay53cml0ZSIsIndlYmhvb2sucmVhZCIsIndlYmhvb2sud3JpdGUiLCJwcmVzZXQucmVhZCIsInByZXNldC53cml0ZSJdfQ.jodm_GFl8dEBWFoUr_HNbsCpZufiS0pV9Es364Trso8glqIm66VxWtECpDQOzcMl1ZBx7apB81ZDadNU0_cFnn6dAJo7a_alh76ifOTdfohjwtdu8-8s8mvcygXwqmRErq-SqalfGYpGxbx-whlgnbhlr7g7zhbsBqNznTRPg8mixc1_SwoRUdR3riqXajLeQ19fHxb1XgN24TBx-MXNFdO84GZXZwdSYeFZAmhwsN8ZNu5_qP3Us9nzQfQqXH97xPXwJkUTp5sXjpUa37WU2caFQxGSxCQrCxnlt6Vq-CbEs_b729AwdP-gpeff8ZpZotDu3ZmkDmPk2oy_NKzpjPGvRvWLLbQp7K6IwDjK-pV2PDCTEF3BHMXYWluVOqwE-UwDHpuKO8qB_QA7KHzGbo-LjoGNqvUqzKU5NOPfxT3SwB2asCK3lErYrIe2ZoGALCL6e-nwGhL3nfHjU_KL-77md5x7Cj6YI7oBWHaQiNsfnbYheJd-gn929psh9EROxLi2qc89gSYOEGthhCI3YzVhTjUj8h7xaBB0zOptmCMTTY7HGT8pZ7ZdKT0eqz9zl2FoF_Bk-7-FjTpa40K03OTG0QAelCADoj-s0eYcyhze7TRZLpddiNFA6AtbDlXsR7gTlMCXyIvu4Hs3P8diTQIbIST9_UP3I0zrJWNG82g\r\n#        cloudtoken: eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImZmNTA1OGI3Y2E1MTIwMGZiZTlhOGVjMThmNzljNDI2ZTg3YjExYTRmNTNmZWE5YjBjZGFlYTA0ZWUxOWZjZDM2MDNhMmJlZDcxYmYxYzgwIn0.eyJhdWQiOiIxIiwianRpIjoiZmY1MDU4YjdjYTUxMjAwZmJlOWE4ZWMxOGY3OWM0MjZlODdiMTFhNGY1M2ZlYTliMGNkYWVhMDRlZTE5ZmNkMzYwM2EyYmVkNzFiZjFjODAiLCJpYXQiOjE1ODM0NTcwODMsIm5iZiI6MTU4MzQ1NzA4MywiZXhwIjo0NzM5MTMwNjgzLCJzdWIiOiI0MDY1MDI4NCIsInNjb3BlcyI6WyJ1c2VyLnJlYWQiLCJ1c2VyLndyaXRlIiwidGFzay5yZWFkIiwidGFzay53cml0ZSIsIndlYmhvb2sucmVhZCIsIndlYmhvb2sud3JpdGUiLCJwcmVzZXQucmVhZCIsInByZXNldC53cml0ZSJdfQ.U8wzK_8SCIUffc4hrE_OusG21-OVMtVRjkeVt0pbLXMqKvXS3vCc56z_Vwfp4aSIx0t4uk_nG_-D4PQkfaHmjUiIcj2f8LFvpwUs3KczN6nSoCN-Vu2PjsVWhwVrllWrhMkT5WGnHLAqB6VzQ3mhFML_QeGDlKdTJeUTsq0pNjCvzYkc00vZyTNyD_Z7xMnc4450NHONcHfFWv82x_exX2D3qxPkFnpo1Fe-zedZ4hjrOypDdTNEJ0gbhR4x7gofsXCyRS8mPtrqnAs49uevIikoeAJDwJVY9gs7Jn7231ZUa9IXoFSOZQ6eV02NagWzIvwkuuMlVV4L7jot9OviN3lCbDMTWBao7pMQoB250mUPeYzFiibUXsvf6HJp8cpzTznKwFVqensKeD9zL9gAZfegekxpO3R4cd0W7H7DAsh790Elp_ChBZfs04BkEDI-pzxuBBf466yxQk7BFZN_rX0ENp60sLb5_1PQ5xRXklNYfpY0_qPGyo8QY57mLytvxe05udaL65R63n6e4xfBfxVZvnZEcxek_RElQY0lC7KdGWfssd0IJZ3x8QK_aDSTmUXWLGANELeVFWJ9aQdQgoYFFRSBkuwRk7b8xSt8K8Xw1WsDwwnvPZX8jfp1xnrjlFI9dsf28LIWTeZdoMXll8oNoTDgGppzQ2SUT-Y7PCU\r\n\r\nlogging: \r\n  config: classpath:logback-custom.xml\r\n\r\noauth2:\r\n  social:\r\n    wechat:\r\n      #网页授权ClientId\r\n      clientId: wx2b4fbf55e9b81616\r\n      #网页授权密钥\r\n      clientSecret: 6f06f4c347250d29a9cc7f383d592866\r\n      #成功登录后跳转地址\r\n      redirectUri: http://www.chengguoyun.cn/center/social/login/weixin\r\n      #回调地址\r\n      bindingCallBackUri: http://www.chengguoyun.cn/center/social/socialWechatCallback\r\n\r\nweChatMini:\r\n  #小程序appId\r\n  appId: wx689076165649860c\r\n  #小程序密钥\r\n  appSecret: 3ddbea702b633127ca8a16e67bae6305\r\n  grantType: authorization_code', 'c20a5868289ef5c7fc368084000f73f7', '2020-06-24 00:49:36', '2021-02-01 11:29:14', NULL, '119.126.113.182', '', '', '', '', '', 'yaml', '');
INSERT INTO `config_info` VALUES (12, 'application-crm.yaml', 'DEFAULT_GROUP', '\r\nspring:\r\n  application:\r\n    name: chengguoyun-crm\r\n  datasource:\r\n    url: jdbc:mysql://db:3306/chengguoyun?serverTimezone=GMT%2B8&zeroDateTimeBehavior=convertToNull&useUnicode=true&characterEncoding=utf8&useSSL=false&allowMultiQueries=true\r\n    username: chengguoyun\r\n    password: )!N52@=^%(rh\r\n    driver-class-name: com.mysql.cj.jdbc.Driver\r\n    druid:\r\n      \r\n      initialSize: 5\r\n      \r\n      minIdle: 10\r\n      \r\n      maxActive: 20\r\n      \r\n      maxWait: 60000\r\n      \r\n      timeBetweenEvictionRunsMillis: 60000\r\n     \r\n      minEvictableIdleTimeMillis: 300000\r\n      \r\n      maxEvictableIdleTimeMillis: 900000\r\n      \r\n      validationQuery: SELECT 1 FROM DUAL\r\n      testWhileIdle: true\r\n      testOnBorrow: false\r\n      testOnReturn: false\r\n      webStatFilter:\r\n        enabled: true\r\n      statViewServlet:\r\n        enabled: true\r\n        \r\n        allow:\r\n        url-pattern: /druid/*\r\n       \r\n        login-username:\r\n        login-password:\r\n      filter:\r\n        stat:\r\n          enabled: true\r\n          \r\n          log-slow-sql: true\r\n          slow-sql-millis: 1000\r\n          merge-sql: true\r\n        wall:\r\n          config:\r\n            multi-statement-allow: true\r\n\r\n  \r\n  redis: \r\n    host: redis-1\r\n    port: 6379\r\n    timeout: 60000\r\n    password: +CDvdHkuUcsN\r\n\r\n\r\nfeign:\r\n  okhttp:\r\n    enabled: true\r\n  hystrix:\r\n    enabled: false\r\n  client:\r\n    config:\r\n      default:\r\n        connectTimeout: 60000\r\n        readTimeout: 20000\r\n        loggerLevel: BASIC\r\n      chengguoyun-policy: # 设定chengguoyun-policy 服务调用的超时设置\r\n        connectTimeout: 30000\r\n        readTimeout: 1800000\r\n        loggerLevel: BASIC\r\n        \r\n##hystrix的超时时间\r\nhystrix:\r\n  shareSecurityContext: true\r\n  command: \r\n    default:\r\n      execution:\r\n        isolation: \r\n          thread: \r\n            timeoutInMilliseconds: 1800000\r\n\r\n\r\nsecurity:\r\n  oauth2:\r\n    resource:\r\n      loadBalanced: true\r\n      id: gateway-policy-dev\r\n      user-info-uri: http://chengguoyun-center/auth-controller/user/member\r\n      prefer-token-info: true\r\n\r\n# 防止XSS攻击\r\nxss:\r\n  # 过滤开关\r\n  enabled: true\r\n  # 排除链接（多个用逗号分隔）\r\n  excludes: /system/notice/*\r\n  # 匹配链接\r\n  urlPatterns: /system/*,/monitor/*,/tool/*\r\n\r\n# logging:\r\n#   level:\r\n#     com.lingxin: debug\r\n#     org.springframework: debug\r\n# http://120.24.205.135:8888/center/auth-controller/user/member\r\n\r\nlingxin:\r\n  controllerEncryptEnabled: false\r\n  sysLogEnabled: true\r\n  sysQueryLogEnabled: false\r\n\r\nmybatis-plus:\r\n  global-config:\r\n    enableSqlRunner: true\r\n\r\naliyun:\r\n    oss:\r\n        accessKeyId: LTAI4FfimpNszv46oBxR51jk\r\n        accessKeySecret: 2SxfRFa54cZvFFeWQGw4ua6AikrkMx\r\n        bucketName: chengguoyun-java\r\n        callbackUrl: \'\'\r\n        endpoint: oss-cn-shenzhen.aliyuncs.com\r\n#        3分钟过期\r\n#        expireTime: 180000\r\n#        10分钟过期\r\n        expireTime: 600000\r\n        host: https://chengguoyun-java.oss-cn-shenzhen.aliyuncs.com/\r\n\r\n# cloudtoken 当前使用的测试账号的token，正式环境需要使用正式账号的token(需购买)\r\n# https://cloudconvert.com/\r\n\r\nqichacha:\r\n    appkey: ae3352d398a345c6a3bb1d8a74ef4a41\r\n    seckey: 78222EF101E5464E05A23249458F3857\r\n\r\nlogging: \r\n  config: classpath:logback-custom.xml\r\n\r\n\r\noauth2:\r\n  social:\r\n    wechat:\r\n      #网页授权ClientId\r\n      clientId: wx2b4fbf55e9b81616\r\n      #网页授权密钥\r\n      clientSecret: 6f06f4c347250d29a9cc7f383d592866\r\n      #成功登录后跳转地址\r\n      redirectUri: http://www.chengguoyun.cn/center/social/login/weixin\r\n      #回调地址\r\n      bindingCallBackUri: http://www.chengguoyun.cn/center/social/socialWechatCallback\r\n\r\nweChatMini:\r\n  #小程序appId\r\n  appId: wx689076165649860c\r\n  #小程序密钥\r\n  appSecret: 3ddbea702b633127ca8a16e67bae6305\r\n  grantType: authorization_code', 'ccda2d67d2c89bca24d541ccfbad7181', '2020-06-24 01:09:26', '2021-02-01 11:29:30', NULL, '119.126.113.182', '', '', '', '', '', 'yaml', '');
INSERT INTO `config_info` VALUES (14, 'application-filelibrary.yaml', 'DEFAULT_GROUP', '\r\nspring:\r\n  application:\r\n    name: chengguoyun-filelibrary\r\n  datasource:\r\n    url: jdbc:mysql://db:3306/chengguoyun?serverTimezone=GMT%2B8&zeroDateTimeBehavior=convertToNull&useUnicode=true&characterEncoding=utf8&useSSL=false&allowMultiQueries=true\r\n    username: chengguoyun\r\n    password: )!N52@=^%(rh\r\n    driver-class-name: com.mysql.cj.jdbc.Driver\r\n    druid:\r\n      \r\n      initialSize: 5\r\n      \r\n      minIdle: 10\r\n      \r\n      maxActive: 20\r\n      \r\n      maxWait: 60000\r\n      \r\n      timeBetweenEvictionRunsMillis: 60000\r\n     \r\n      minEvictableIdleTimeMillis: 300000\r\n      \r\n      maxEvictableIdleTimeMillis: 900000\r\n      \r\n      validationQuery: SELECT 1 FROM DUAL\r\n      testWhileIdle: true\r\n      testOnBorrow: false\r\n      testOnReturn: false\r\n      webStatFilter:\r\n        enabled: true\r\n      statViewServlet:\r\n        enabled: true\r\n        \r\n        allow:\r\n        url-pattern: /druid/*\r\n       \r\n        login-username:\r\n        login-password:\r\n      filter:\r\n        stat:\r\n          enabled: true\r\n          \r\n          log-slow-sql: true\r\n          slow-sql-millis: 1000\r\n          merge-sql: true\r\n        wall:\r\n          config:\r\n            multi-statement-allow: true\r\n  servlet:\r\n    multipart:\r\n      max-file-size: 100MB\r\n      max-request-size: 100MB\r\n  redis: \r\n    host: redis-1\r\n    port: 6379\r\n    timeout: 60000\r\n    password: +CDvdHkuUcsN\r\nmybatis-plus:\r\n  global-config:\r\n    enableSqlRunner: true\r\n  \r\n  \r\n\r\n\r\nfeign:\r\n  okhttp:\r\n    enabled: true\r\n  hystrix:\r\n    enabled: true\r\n  client:\r\n    config:\r\n      default:\r\n        connectTimeout: 60000\r\n        readTimeout: 20000\r\n        loggerLevel: full\r\n\r\nsecurity:\r\n  oauth2:\r\n    resource:\r\n      loadBalanced: true\r\n      id: gateway-policy-dev\r\n      user-info-uri: http://chengguoyun-center/auth-controller/user/member\r\n      prefer-token-info: true\r\n\r\n##hystrix的超时时间\r\nhystrix:\r\n  shareSecurityContext: true\r\n  command: \r\n    default:\r\n      execution:\r\n        isolation: \r\n          thread: \r\n            timeoutInMilliseconds: 5000\r\n\r\nlingxin:\r\n  controllerEncryptEnabled: false\r\n  sysLogEnabled: true\r\n  sysQueryLogEnabled: false\r\n\r\n\r\n\r\nxss:\r\n\r\n  enabled: true\r\n\r\n  excludes: /system/notice/*\r\n\r\n  urlPatterns: /system/*,/monitor/*,/tool/*\r\n\r\n\r\nlogging: \r\n  config: classpath:logback-custom.xml\r\n\r\noauth2:\r\n  social:\r\n    wechat:\r\n      #网页授权ClientId\r\n      clientId: wx2b4fbf55e9b81616\r\n      #网页授权密钥\r\n      clientSecret: 6f06f4c347250d29a9cc7f383d592866\r\n      #成功登录后跳转地址\r\n      redirectUri: http://www.chengguoyun.cn/center/social/login/weixin\r\n      #回调地址\r\n      bindingCallBackUri: http://www.chengguoyun.cn/center/social/socialWechatCallback\r\n\r\nweChatMini:\r\n  #小程序appId\r\n  appId: wx689076165649860c\r\n  #小程序密钥\r\n  appSecret: 3ddbea702b633127ca8a16e67bae6305\r\n  grantType: authorization_code\r\n\r\n\r\n\r\n', 'e9318cdfac615dfca5870ea4975585cf', '2020-06-24 02:05:27', '2021-02-01 11:29:43', NULL, '119.126.113.182', '', '', '', '', '', 'yaml', '');
INSERT INTO `config_info` VALUES (15, 'application-message.yaml', 'DEFAULT_GROUP', '\r\nspring:\r\n  application:\r\n    name: chengguoyun-message\r\n  datasource:\r\n    url: jdbc:mysql://db:3306/chengguoyun?serverTimezone=GMT%2B8&zeroDateTimeBehavior=convertToNull&useUnicode=true&characterEncoding=utf8&useSSL=false&allowMultiQueries=true\r\n    username: chengguoyun\r\n    password: )!N52@=^%(rh\r\n\r\n    driver-class-name: com.mysql.cj.jdbc.Driver\r\n    druid:\r\n      \r\n      initialSize: 5\r\n      \r\n      minIdle: 10\r\n      \r\n      maxActive: 20\r\n      \r\n      maxWait: 60000\r\n      \r\n      timeBetweenEvictionRunsMillis: 60000\r\n     \r\n      minEvictableIdleTimeMillis: 300000\r\n      \r\n      maxEvictableIdleTimeMillis: 900000\r\n      \r\n      validationQuery: SELECT 1 FROM DUAL\r\n      testWhileIdle: true\r\n      testOnBorrow: false\r\n      testOnReturn: false\r\n      webStatFilter:\r\n        enabled: true\r\n      statViewServlet:\r\n        enabled: true\r\n        \r\n        allow:\r\n        url-pattern: /druid/*\r\n       \r\n        login-username:\r\n        login-password:\r\n      filter:\r\n        stat:\r\n          enabled: true\r\n          \r\n          log-slow-sql: true\r\n          slow-sql-millis: 1000\r\n          merge-sql: true\r\n        wall:\r\n          config:\r\n            multi-statement-allow: true\r\n\r\n  \r\n  redis:\r\n    host: redis-1\r\n    port: 6379\r\n    timeout: 60000\r\n    password: +CDvdHkuUcsN\r\n\r\nmybatis-plus:\r\n  global-config:\r\n    enableSqlRunner: true\r\n\r\nfeign:\r\n  okhttp:\r\n    enabled: true\r\n  hystrix:\r\n    enabled: true\r\n  client:\r\n    config:\r\n      default:\r\n        connectTimeout: 60000\r\n        readTimeout: 20000\r\n        loggerLevel: full\r\n\r\nhystrix:\r\n  shareSecurityContext: true\r\n\r\n\r\nsecurity:\r\n  oauth2:\r\n    resource:\r\n      loadBalanced: true\r\n      id: gateway-policy-dev\r\n      user-info-uri: http://chengguoyun-center/auth-controller/user/member\r\n      prefer-token-info: true\r\n\r\nxss:\r\n\r\n  enabled: true\r\n\r\n  excludes: /system/notice/*\r\n\r\n  urlPatterns: /system/*,/monitor/*,/tool/*\r\n\r\n# logging:\r\n#   level:\r\n#     com.lingxin: debug\r\n#     org.springframework: debug\r\n# http://120.24.205.135:8888/center/auth-controller/user/member\r\n\r\n\r\nlingxin:\r\n  controllerEncryptEnabled: false\r\n  sysLogEnabled: true\r\n  sysQueryLogEnabled: false\r\n\r\nlogging: \r\n  config: classpath:logback-custom.xml\r\n\r\noauth2:\r\n  social:\r\n    wechat:\r\n      #网页授权ClientId\r\n      clientId: wx2b4fbf55e9b81616\r\n      #网页授权密钥\r\n      clientSecret: 6f06f4c347250d29a9cc7f383d592866\r\n      #成功登录后跳转地址\r\n      redirectUri: http://www.chengguoyun.cn/center/social/login/weixin\r\n      #回调地址\r\n      bindingCallBackUri: http://www.chengguoyun.cn/center/social/socialWechatCallback\r\n\r\nweChatMini:\r\n  #小程序appId\r\n  appId: wx689076165649860c\r\n  #小程序密钥\r\n  appSecret: 3ddbea702b633127ca8a16e67bae6305\r\n  grantType: authorization_code\r\n\r\n\r\n\r\n', '2fbc29490e86f0e390893fe3b04aee33', '2020-06-24 02:38:20', '2021-02-01 11:29:53', NULL, '119.126.113.182', '', '', '', '', '', 'yaml', '');

-- ----------------------------
-- Table structure for config_info_aggr
-- ----------------------------
DROP TABLE IF EXISTS `config_info_aggr`;
CREATE TABLE `config_info_aggr`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `data_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT 'data_id',
  `group_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT 'group_id',
  `datum_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT 'datum_id',
  `content` longtext CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '内容',
  `gmt_modified` datetime(0) NOT NULL COMMENT '修改时间',
  `app_name` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL,
  `tenant_id` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT '' COMMENT '租户字段',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_configinfoaggr_datagrouptenantdatum`(`data_id`, `group_id`, `tenant_id`, `datum_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_bin COMMENT = '增加租户字段' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of config_info_aggr
-- ----------------------------

-- ----------------------------
-- Table structure for config_info_beta
-- ----------------------------
DROP TABLE IF EXISTS `config_info_beta`;
CREATE TABLE `config_info_beta`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `data_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT 'data_id',
  `group_id` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT 'group_id',
  `app_name` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT 'app_name',
  `content` longtext CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT 'content',
  `beta_ips` varchar(1024) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT 'betaIps',
  `md5` varchar(32) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT 'md5',
  `gmt_create` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `gmt_modified` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  `src_user` text CHARACTER SET utf8 COLLATE utf8_bin NULL COMMENT 'source user',
  `src_ip` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT 'source ip',
  `tenant_id` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT '' COMMENT '租户字段',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_configinfobeta_datagrouptenant`(`data_id`, `group_id`, `tenant_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_bin COMMENT = 'config_info_beta' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of config_info_beta
-- ----------------------------

-- ----------------------------
-- Table structure for config_info_tag
-- ----------------------------
DROP TABLE IF EXISTS `config_info_tag`;
CREATE TABLE `config_info_tag`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `data_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT 'data_id',
  `group_id` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT 'group_id',
  `tenant_id` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT '' COMMENT 'tenant_id',
  `tag_id` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT 'tag_id',
  `app_name` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT 'app_name',
  `content` longtext CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT 'content',
  `md5` varchar(32) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT 'md5',
  `gmt_create` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `gmt_modified` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  `src_user` text CHARACTER SET utf8 COLLATE utf8_bin NULL COMMENT 'source user',
  `src_ip` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT 'source ip',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_configinfotag_datagrouptenanttag`(`data_id`, `group_id`, `tenant_id`, `tag_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_bin COMMENT = 'config_info_tag' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of config_info_tag
-- ----------------------------

-- ----------------------------
-- Table structure for config_tags_relation
-- ----------------------------
DROP TABLE IF EXISTS `config_tags_relation`;
CREATE TABLE `config_tags_relation`  (
  `id` bigint(0) NOT NULL COMMENT 'id',
  `tag_name` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT 'tag_name',
  `tag_type` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT 'tag_type',
  `data_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT 'data_id',
  `group_id` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT 'group_id',
  `tenant_id` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT '' COMMENT 'tenant_id',
  `nid` bigint(0) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`nid`) USING BTREE,
  UNIQUE INDEX `uk_configtagrelation_configidtag`(`id`, `tag_name`, `tag_type`) USING BTREE,
  INDEX `idx_tenant_id`(`tenant_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_bin COMMENT = 'config_tag_relation' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of config_tags_relation
-- ----------------------------

-- ----------------------------
-- Table structure for group_capacity
-- ----------------------------
DROP TABLE IF EXISTS `group_capacity`;
CREATE TABLE `group_capacity`  (
  `id` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `group_id` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT 'Group ID，空字符表示整个集群',
  `quota` int(0) UNSIGNED NOT NULL DEFAULT 0 COMMENT '配额，0表示使用默认值',
  `usage` int(0) UNSIGNED NOT NULL DEFAULT 0 COMMENT '使用量',
  `max_size` int(0) UNSIGNED NOT NULL DEFAULT 0 COMMENT '单个配置大小上限，单位为字节，0表示使用默认值',
  `max_aggr_count` int(0) UNSIGNED NOT NULL DEFAULT 0 COMMENT '聚合子配置最大个数，，0表示使用默认值',
  `max_aggr_size` int(0) UNSIGNED NOT NULL DEFAULT 0 COMMENT '单个聚合数据的子配置大小上限，单位为字节，0表示使用默认值',
  `max_history_count` int(0) UNSIGNED NOT NULL DEFAULT 0 COMMENT '最大变更历史数量',
  `gmt_create` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `gmt_modified` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_group_id`(`group_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_bin COMMENT = '集群、各Group容量信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of group_capacity
-- ----------------------------

-- ----------------------------
-- Table structure for his_config_info
-- ----------------------------
DROP TABLE IF EXISTS `his_config_info`;
CREATE TABLE `his_config_info`  (
  `id` bigint(0) UNSIGNED NOT NULL,
  `nid` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT,
  `data_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `group_id` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `app_name` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT 'app_name',
  `content` longtext CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `md5` varchar(32) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL,
  `gmt_create` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  `gmt_modified` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  `src_user` text CHARACTER SET utf8 COLLATE utf8_bin NULL,
  `src_ip` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL,
  `op_type` char(10) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL,
  `tenant_id` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT '' COMMENT '租户字段',
  PRIMARY KEY (`nid`) USING BTREE,
  INDEX `idx_gmt_create`(`gmt_create`) USING BTREE,
  INDEX `idx_gmt_modified`(`gmt_modified`) USING BTREE,
  INDEX `idx_did`(`data_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 95 CHARACTER SET = utf8 COLLATE = utf8_bin COMMENT = '多租户改造' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of his_config_info
-- ----------------------------
INSERT INTO `his_config_info` VALUES (10, 91, 'application-policy.yaml', 'DEFAULT_GROUP', '', '\r\nspring:\r\n  application:\r\n    name: chengguoyun-policy\r\n  datasource:\r\n    url: jdbc:mysql://db:3306/chengguoyun?serverTimezone=GMT%2B8&zeroDateTimeBehavior=convertToNull&useUnicode=true&characterEncoding=utf8&useSSL=false&allowMultiQueries=true\r\n    username: chengguoyun\r\n    password: )!N52@=^%(rh\r\n    driver-class-name: com.mysql.cj.jdbc.Driver\r\n    druid:\r\n      \r\n      initialSize: 5\r\n      \r\n      minIdle: 10\r\n      \r\n      maxActive: 20\r\n      \r\n      maxWait: 60000\r\n      \r\n      timeBetweenEvictionRunsMillis: 60000\r\n     \r\n      minEvictableIdleTimeMillis: 300000\r\n      \r\n      maxEvictableIdleTimeMillis: 900000\r\n      \r\n      validationQuery: SELECT 1 FROM DUAL\r\n      testWhileIdle: true\r\n      testOnBorrow: false\r\n      testOnReturn: false\r\n      webStatFilter:\r\n        enabled: true\r\n      statViewServlet:\r\n        enabled: true\r\n        \r\n        allow:\r\n        url-pattern: /druid/*\r\n       \r\n        login-username:\r\n        login-password:\r\n      filter:\r\n        stat:\r\n          enabled: true\r\n          \r\n          log-slow-sql: true\r\n          slow-sql-millis: 1000\r\n          merge-sql: true\r\n        wall:\r\n          config:\r\n            multi-statement-allow: true\r\n\r\n  \r\n  redis:\r\n    \r\n    host: redis-1\r\n    port: 6379\r\n    timeout: 60000\r\n    password: +CDvdHkuUcsN\r\n\r\n\r\nfeign:\r\n  okhttp:\r\n    enabled: true\r\n  hystrix:\r\n    enabled: true\r\n  client:\r\n    config:\r\n      default:\r\n        connectTimeout: 60000\r\n        readTimeout: 60000\r\n        loggerLevel: BASIC\r\n##hystrix的超时时间\r\nhystrix:\r\n  shareSecurityContext: true\r\n  command: \r\n    default:\r\n      execution:\r\n        isolation: \r\n          thread: \r\n            timeoutInMilliseconds: 60000\r\n\r\n\r\nsecurity:\r\n  oauth2:\r\n    resource:\r\n      loadBalanced: true\r\n      id: gateway-policy-dev\r\n      user-info-uri: http://chengguoyun-center/auth-controller/user/member\r\n      prefer-token-info: true\r\n\r\n# 防止XSS攻击\r\nxss:\r\n  # 过滤开关\r\n  enabled: true\r\n  # 排除链接（多个用逗号分隔）\r\n  excludes: /system/notice/*\r\n  # 匹配链接\r\n  urlPatterns: /system/*,/monitor/*,/tool/*\r\n\r\n# logging:\r\n#   level:\r\n#     com.lingxin: debug\r\n#     org.springframework: debug\r\n# http://120.24.205.135:8888/center/auth-controller/user/member\r\n\r\nlingxin:\r\n  controllerEncryptEnabled: false\r\n  sysLogEnabled: false\r\n  sysQueryLogEnabled: false\r\n\r\nmybatis-plus:\r\n  global-config:\r\n    enableSqlRunner: true\r\n\r\naliyun:\r\n    oss:\r\n        accessKeyId: LTAI4FfimpNszv46oBxR51jk\r\n        accessKeySecret: 2SxfRFa54cZvFFeWQGw4ua6AikrkMx\r\n        bucketName: chengguoyun-java\r\n        callbackUrl: \'\'\r\n        endpoint: oss-cn-shenzhen.aliyuncs.com\r\n#        3分钟过期\r\n#        expireTime: 180000\r\n#        10分钟过期\r\n        expireTime: 600000\r\n        host: https://chengguoyun.oss-cn-shenzhen.aliyuncs.com/\r\n\r\n# cloudtoken 当前使用的测试账号的token，正式环境需要使用正式账号的token(需购买)\r\n# https://cloudconvert.com/\r\ncloudconvert:\r\n    cloudapi:\r\n        cloudtoken: eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjIwNjVmOGEyOGUxZmQwMTcwNmE1YTZkMmY2YjQ0ZmJmM2RkYzcwYmRkZTU4Y2RiOThiNGRlMTU5NGM3ODE4YWQzNjY5ZmNkZjgzZTgxYTk3In0.eyJhdWQiOiIxIiwianRpIjoiMjA2NWY4YTI4ZTFmZDAxNzA2YTVhNmQyZjZiNDRmYmYzZGRjNzBiZGRlNThjZGI5OGI0ZGUxNTk0Yzc4MThhZDM2NjlmY2RmODNlODFhOTciLCJpYXQiOjE1ODMzNzc1NDcsIm5iZiI6MTU4MzM3NzU0NywiZXhwIjo0NzM5MDUxMTQ3LCJzdWIiOiI0MDYwNjUyMCIsInNjb3BlcyI6WyJ1c2VyLnJlYWQiLCJ1c2VyLndyaXRlIiwidGFzay5yZWFkIiwidGFzay53cml0ZSIsIndlYmhvb2sucmVhZCIsIndlYmhvb2sud3JpdGUiLCJwcmVzZXQucmVhZCIsInByZXNldC53cml0ZSJdfQ.jodm_GFl8dEBWFoUr_HNbsCpZufiS0pV9Es364Trso8glqIm66VxWtECpDQOzcMl1ZBx7apB81ZDadNU0_cFnn6dAJo7a_alh76ifOTdfohjwtdu8-8s8mvcygXwqmRErq-SqalfGYpGxbx-whlgnbhlr7g7zhbsBqNznTRPg8mixc1_SwoRUdR3riqXajLeQ19fHxb1XgN24TBx-MXNFdO84GZXZwdSYeFZAmhwsN8ZNu5_qP3Us9nzQfQqXH97xPXwJkUTp5sXjpUa37WU2caFQxGSxCQrCxnlt6Vq-CbEs_b729AwdP-gpeff8ZpZotDu3ZmkDmPk2oy_NKzpjPGvRvWLLbQp7K6IwDjK-pV2PDCTEF3BHMXYWluVOqwE-UwDHpuKO8qB_QA7KHzGbo-LjoGNqvUqzKU5NOPfxT3SwB2asCK3lErYrIe2ZoGALCL6e-nwGhL3nfHjU_KL-77md5x7Cj6YI7oBWHaQiNsfnbYheJd-gn929psh9EROxLi2qc89gSYOEGthhCI3YzVhTjUj8h7xaBB0zOptmCMTTY7HGT8pZ7ZdKT0eqz9zl2FoF_Bk-7-FjTpa40K03OTG0QAelCADoj-s0eYcyhze7TRZLpddiNFA6AtbDlXsR7gTlMCXyIvu4Hs3P8diTQIbIST9_UP3I0zrJWNG82g\r\n#        cloudtoken: eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImZmNTA1OGI3Y2E1MTIwMGZiZTlhOGVjMThmNzljNDI2ZTg3YjExYTRmNTNmZWE5YjBjZGFlYTA0ZWUxOWZjZDM2MDNhMmJlZDcxYmYxYzgwIn0.eyJhdWQiOiIxIiwianRpIjoiZmY1MDU4YjdjYTUxMjAwZmJlOWE4ZWMxOGY3OWM0MjZlODdiMTFhNGY1M2ZlYTliMGNkYWVhMDRlZTE5ZmNkMzYwM2EyYmVkNzFiZjFjODAiLCJpYXQiOjE1ODM0NTcwODMsIm5iZiI6MTU4MzQ1NzA4MywiZXhwIjo0NzM5MTMwNjgzLCJzdWIiOiI0MDY1MDI4NCIsInNjb3BlcyI6WyJ1c2VyLnJlYWQiLCJ1c2VyLndyaXRlIiwidGFzay5yZWFkIiwidGFzay53cml0ZSIsIndlYmhvb2sucmVhZCIsIndlYmhvb2sud3JpdGUiLCJwcmVzZXQucmVhZCIsInByZXNldC53cml0ZSJdfQ.U8wzK_8SCIUffc4hrE_OusG21-OVMtVRjkeVt0pbLXMqKvXS3vCc56z_Vwfp4aSIx0t4uk_nG_-D4PQkfaHmjUiIcj2f8LFvpwUs3KczN6nSoCN-Vu2PjsVWhwVrllWrhMkT5WGnHLAqB6VzQ3mhFML_QeGDlKdTJeUTsq0pNjCvzYkc00vZyTNyD_Z7xMnc4450NHONcHfFWv82x_exX2D3qxPkFnpo1Fe-zedZ4hjrOypDdTNEJ0gbhR4x7gofsXCyRS8mPtrqnAs49uevIikoeAJDwJVY9gs7Jn7231ZUa9IXoFSOZQ6eV02NagWzIvwkuuMlVV4L7jot9OviN3lCbDMTWBao7pMQoB250mUPeYzFiibUXsvf6HJp8cpzTznKwFVqensKeD9zL9gAZfegekxpO3R4cd0W7H7DAsh790Elp_ChBZfs04BkEDI-pzxuBBf466yxQk7BFZN_rX0ENp60sLb5_1PQ5xRXklNYfpY0_qPGyo8QY57mLytvxe05udaL65R63n6e4xfBfxVZvnZEcxek_RElQY0lC7KdGWfssd0IJZ3x8QK_aDSTmUXWLGANELeVFWJ9aQdQgoYFFRSBkuwRk7b8xSt8K8Xw1WsDwwnvPZX8jfp1xnrjlFI9dsf28LIWTeZdoMXll8oNoTDgGppzQ2SUT-Y7PCU\r\n\r\nlogging: \r\n  config: classpath:logback-custom.xml\r\n', '184568a73f9833462c718d5eb76797a1', '2021-02-01 11:29:13', '2021-02-01 11:29:14', NULL, '119.126.113.182', 'U', '');
INSERT INTO `his_config_info` VALUES (12, 92, 'application-crm.yaml', 'DEFAULT_GROUP', '', '\r\nspring:\r\n  application:\r\n    name: chengguoyun-crm\r\n  datasource:\r\n    url: jdbc:mysql://db:3306/chengguoyun?serverTimezone=GMT%2B8&zeroDateTimeBehavior=convertToNull&useUnicode=true&characterEncoding=utf8&useSSL=false&allowMultiQueries=true\r\n    username: chengguoyun\r\n    password: )!N52@=^%(rh\r\n    driver-class-name: com.mysql.cj.jdbc.Driver\r\n    druid:\r\n      \r\n      initialSize: 5\r\n      \r\n      minIdle: 10\r\n      \r\n      maxActive: 20\r\n      \r\n      maxWait: 60000\r\n      \r\n      timeBetweenEvictionRunsMillis: 60000\r\n     \r\n      minEvictableIdleTimeMillis: 300000\r\n      \r\n      maxEvictableIdleTimeMillis: 900000\r\n      \r\n      validationQuery: SELECT 1 FROM DUAL\r\n      testWhileIdle: true\r\n      testOnBorrow: false\r\n      testOnReturn: false\r\n      webStatFilter:\r\n        enabled: true\r\n      statViewServlet:\r\n        enabled: true\r\n        \r\n        allow:\r\n        url-pattern: /druid/*\r\n       \r\n        login-username:\r\n        login-password:\r\n      filter:\r\n        stat:\r\n          enabled: true\r\n          \r\n          log-slow-sql: true\r\n          slow-sql-millis: 1000\r\n          merge-sql: true\r\n        wall:\r\n          config:\r\n            multi-statement-allow: true\r\n\r\n  \r\n  redis: \r\n    host: redis-1\r\n    port: 6379\r\n    timeout: 60000\r\n    password: +CDvdHkuUcsN\r\n\r\n\r\nfeign:\r\n  okhttp:\r\n    enabled: true\r\n  hystrix:\r\n    enabled: false\r\n  client:\r\n    config:\r\n      default:\r\n        connectTimeout: 60000\r\n        readTimeout: 20000\r\n        loggerLevel: BASIC\r\n      chengguoyun-policy: # 设定chengguoyun-policy 服务调用的超时设置\r\n        connectTimeout: 30000\r\n        readTimeout: 1800000\r\n        loggerLevel: BASIC\r\n        \r\n##hystrix的超时时间\r\nhystrix:\r\n  shareSecurityContext: true\r\n  command: \r\n    default:\r\n      execution:\r\n        isolation: \r\n          thread: \r\n            timeoutInMilliseconds: 1800000\r\n\r\n\r\nsecurity:\r\n  oauth2:\r\n    resource:\r\n      loadBalanced: true\r\n      id: gateway-policy-dev\r\n      user-info-uri: http://chengguoyun-center/auth-controller/user/member\r\n      prefer-token-info: true\r\n\r\n# 防止XSS攻击\r\nxss:\r\n  # 过滤开关\r\n  enabled: true\r\n  # 排除链接（多个用逗号分隔）\r\n  excludes: /system/notice/*\r\n  # 匹配链接\r\n  urlPatterns: /system/*,/monitor/*,/tool/*\r\n\r\n# logging:\r\n#   level:\r\n#     com.lingxin: debug\r\n#     org.springframework: debug\r\n# http://120.24.205.135:8888/center/auth-controller/user/member\r\n\r\nlingxin:\r\n  controllerEncryptEnabled: false\r\n  sysLogEnabled: true\r\n  sysQueryLogEnabled: false\r\n\r\nmybatis-plus:\r\n  global-config:\r\n    enableSqlRunner: true\r\n\r\naliyun:\r\n    oss:\r\n        accessKeyId: LTAI4FfimpNszv46oBxR51jk\r\n        accessKeySecret: 2SxfRFa54cZvFFeWQGw4ua6AikrkMx\r\n        bucketName: chengguoyun-java\r\n        callbackUrl: \'\'\r\n        endpoint: oss-cn-shenzhen.aliyuncs.com\r\n#        3分钟过期\r\n#        expireTime: 180000\r\n#        10分钟过期\r\n        expireTime: 600000\r\n        host: https://chengguoyun-java.oss-cn-shenzhen.aliyuncs.com/\r\n\r\n# cloudtoken 当前使用的测试账号的token，正式环境需要使用正式账号的token(需购买)\r\n# https://cloudconvert.com/\r\n\r\nqichacha:\r\n    appkey: ae3352d398a345c6a3bb1d8a74ef4a41\r\n    seckey: 78222EF101E5464E05A23249458F3857\r\n\r\nlogging: \r\n  config: classpath:logback-custom.xml\r\n', '8670cfb6777e5336e436d7d76dfd7309', '2021-02-01 11:29:30', '2021-02-01 11:29:30', NULL, '119.126.113.182', 'U', '');
INSERT INTO `his_config_info` VALUES (14, 93, 'application-filelibrary.yaml', 'DEFAULT_GROUP', '', '\r\nspring:\r\n  application:\r\n    name: chengguoyun-filelibrary\r\n  datasource:\r\n    url: jdbc:mysql://db:3306/chengguoyun?serverTimezone=GMT%2B8&zeroDateTimeBehavior=convertToNull&useUnicode=true&characterEncoding=utf8&useSSL=false&allowMultiQueries=true\r\n    username: chengguoyun\r\n    password: )!N52@=^%(rh\r\n    driver-class-name: com.mysql.cj.jdbc.Driver\r\n    druid:\r\n      \r\n      initialSize: 5\r\n      \r\n      minIdle: 10\r\n      \r\n      maxActive: 20\r\n      \r\n      maxWait: 60000\r\n      \r\n      timeBetweenEvictionRunsMillis: 60000\r\n     \r\n      minEvictableIdleTimeMillis: 300000\r\n      \r\n      maxEvictableIdleTimeMillis: 900000\r\n      \r\n      validationQuery: SELECT 1 FROM DUAL\r\n      testWhileIdle: true\r\n      testOnBorrow: false\r\n      testOnReturn: false\r\n      webStatFilter:\r\n        enabled: true\r\n      statViewServlet:\r\n        enabled: true\r\n        \r\n        allow:\r\n        url-pattern: /druid/*\r\n       \r\n        login-username:\r\n        login-password:\r\n      filter:\r\n        stat:\r\n          enabled: true\r\n          \r\n          log-slow-sql: true\r\n          slow-sql-millis: 1000\r\n          merge-sql: true\r\n        wall:\r\n          config:\r\n            multi-statement-allow: true\r\n  servlet:\r\n    multipart:\r\n      max-file-size: 100MB\r\n      max-request-size: 100MB\r\n  redis: \r\n    host: redis-1\r\n    port: 6379\r\n    timeout: 60000\r\n    password: +CDvdHkuUcsN\r\nmybatis-plus:\r\n  global-config:\r\n    enableSqlRunner: true\r\n  \r\n  \r\n\r\n\r\nfeign:\r\n  okhttp:\r\n    enabled: true\r\n  hystrix:\r\n    enabled: true\r\n  client:\r\n    config:\r\n      default:\r\n        connectTimeout: 60000\r\n        readTimeout: 20000\r\n        loggerLevel: full\r\n\r\nsecurity:\r\n  oauth2:\r\n    resource:\r\n      loadBalanced: true\r\n      id: gateway-policy-dev\r\n      user-info-uri: http://chengguoyun-center/auth-controller/user/member\r\n      prefer-token-info: true\r\n\r\n##hystrix的超时时间\r\nhystrix:\r\n  shareSecurityContext: true\r\n  command: \r\n    default:\r\n      execution:\r\n        isolation: \r\n          thread: \r\n            timeoutInMilliseconds: 5000\r\n\r\nlingxin:\r\n  controllerEncryptEnabled: false\r\n  sysLogEnabled: true\r\n  sysQueryLogEnabled: false\r\n\r\n\r\n\r\nxss:\r\n\r\n  enabled: true\r\n\r\n  excludes: /system/notice/*\r\n\r\n  urlPatterns: /system/*,/monitor/*,/tool/*\r\n\r\n\r\nlogging: \r\n  config: classpath:logback-custom.xml\r\n\r\n\r\n\r\n\r\n\r\n', 'd928954ce8ca9b65b012a2850bc72c43', '2021-02-01 11:29:42', '2021-02-01 11:29:43', NULL, '119.126.113.182', 'U', '');
INSERT INTO `his_config_info` VALUES (15, 94, 'application-message.yaml', 'DEFAULT_GROUP', '', '\r\nspring:\r\n  application:\r\n    name: chengguoyun-message\r\n  datasource:\r\n    url: jdbc:mysql://db:3306/chengguoyun?serverTimezone=GMT%2B8&zeroDateTimeBehavior=convertToNull&useUnicode=true&characterEncoding=utf8&useSSL=false&allowMultiQueries=true\r\n    username: chengguoyun\r\n    password: )!N52@=^%(rh\r\n\r\n    driver-class-name: com.mysql.cj.jdbc.Driver\r\n    druid:\r\n      \r\n      initialSize: 5\r\n      \r\n      minIdle: 10\r\n      \r\n      maxActive: 20\r\n      \r\n      maxWait: 60000\r\n      \r\n      timeBetweenEvictionRunsMillis: 60000\r\n     \r\n      minEvictableIdleTimeMillis: 300000\r\n      \r\n      maxEvictableIdleTimeMillis: 900000\r\n      \r\n      validationQuery: SELECT 1 FROM DUAL\r\n      testWhileIdle: true\r\n      testOnBorrow: false\r\n      testOnReturn: false\r\n      webStatFilter:\r\n        enabled: true\r\n      statViewServlet:\r\n        enabled: true\r\n        \r\n        allow:\r\n        url-pattern: /druid/*\r\n       \r\n        login-username:\r\n        login-password:\r\n      filter:\r\n        stat:\r\n          enabled: true\r\n          \r\n          log-slow-sql: true\r\n          slow-sql-millis: 1000\r\n          merge-sql: true\r\n        wall:\r\n          config:\r\n            multi-statement-allow: true\r\n\r\n  \r\n  redis:\r\n    host: redis-1\r\n    port: 6379\r\n    timeout: 60000\r\n    password: +CDvdHkuUcsN\r\n\r\nmybatis-plus:\r\n  global-config:\r\n    enableSqlRunner: true\r\n\r\nfeign:\r\n  okhttp:\r\n    enabled: true\r\n  hystrix:\r\n    enabled: true\r\n  client:\r\n    config:\r\n      default:\r\n        connectTimeout: 60000\r\n        readTimeout: 20000\r\n        loggerLevel: full\r\n\r\nhystrix:\r\n  shareSecurityContext: true\r\n\r\n\r\nsecurity:\r\n  oauth2:\r\n    resource:\r\n      loadBalanced: true\r\n      id: gateway-policy-dev\r\n      user-info-uri: http://chengguoyun-center/auth-controller/user/member\r\n      prefer-token-info: true\r\n\r\nxss:\r\n\r\n  enabled: true\r\n\r\n  excludes: /system/notice/*\r\n\r\n  urlPatterns: /system/*,/monitor/*,/tool/*\r\n\r\n# logging:\r\n#   level:\r\n#     com.lingxin: debug\r\n#     org.springframework: debug\r\n# http://120.24.205.135:8888/center/auth-controller/user/member\r\n\r\n\r\nlingxin:\r\n  controllerEncryptEnabled: false\r\n  sysLogEnabled: true\r\n  sysQueryLogEnabled: false\r\n\r\nlogging: \r\n  config: classpath:logback-custom.xml\r\n\r\n\r\n\r\n\r\n\r\n', 'acbd431e76a55e5bb4dea28bdced0568', '2021-02-01 11:29:53', '2021-02-01 11:29:53', NULL, '119.126.113.182', 'U', '');

-- ----------------------------
-- Table structure for permissions
-- ----------------------------
DROP TABLE IF EXISTS `permissions`;
CREATE TABLE `permissions`  (
  `role` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `resource` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `action` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  UNIQUE INDEX `uk_role_permission`(`role`, `resource`, `action`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of permissions
-- ----------------------------

-- ----------------------------
-- Table structure for roles
-- ----------------------------
DROP TABLE IF EXISTS `roles`;
CREATE TABLE `roles`  (
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `role` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  UNIQUE INDEX `idx_user_role`(`username`, `role`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of roles
-- ----------------------------
INSERT INTO `roles` VALUES ('nacos', 'ROLE_ADMIN');

-- ----------------------------
-- Table structure for tenant_capacity
-- ----------------------------
DROP TABLE IF EXISTS `tenant_capacity`;
CREATE TABLE `tenant_capacity`  (
  `id` bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `tenant_id` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT 'Tenant ID',
  `quota` int(0) UNSIGNED NOT NULL DEFAULT 0 COMMENT '配额，0表示使用默认值',
  `usage` int(0) UNSIGNED NOT NULL DEFAULT 0 COMMENT '使用量',
  `max_size` int(0) UNSIGNED NOT NULL DEFAULT 0 COMMENT '单个配置大小上限，单位为字节，0表示使用默认值',
  `max_aggr_count` int(0) UNSIGNED NOT NULL DEFAULT 0 COMMENT '聚合子配置最大个数',
  `max_aggr_size` int(0) UNSIGNED NOT NULL DEFAULT 0 COMMENT '单个聚合数据的子配置大小上限，单位为字节，0表示使用默认值',
  `max_history_count` int(0) UNSIGNED NOT NULL DEFAULT 0 COMMENT '最大变更历史数量',
  `gmt_create` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `gmt_modified` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_tenant_id`(`tenant_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_bin COMMENT = '租户容量信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tenant_capacity
-- ----------------------------

-- ----------------------------
-- Table structure for tenant_info
-- ----------------------------
DROP TABLE IF EXISTS `tenant_info`;
CREATE TABLE `tenant_info`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `kp` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT 'kp',
  `tenant_id` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT '' COMMENT 'tenant_id',
  `tenant_name` varchar(128) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT '' COMMENT 'tenant_name',
  `tenant_desc` varchar(256) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT 'tenant_desc',
  `create_source` varchar(32) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT 'create_source',
  `gmt_create` bigint(0) NOT NULL COMMENT '创建时间',
  `gmt_modified` bigint(0) NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_tenant_info_kptenantid`(`kp`, `tenant_id`) USING BTREE,
  INDEX `idx_tenant_id`(`tenant_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_bin COMMENT = 'tenant_info' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tenant_info
-- ----------------------------

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `enabled` tinyint(1) NOT NULL,
  PRIMARY KEY (`username`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES ('nacos', '$2a$10$yoqP8.BILYUoywionW2OP.ttFftFoz6zbhjN0jepsgnEdeRyWctWe', 1);

SET FOREIGN_KEY_CHECKS = 1;
