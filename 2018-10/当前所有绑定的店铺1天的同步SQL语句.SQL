/*
 Navicat Premium Data Transfer

 Source Server         : amz1.yunkecrm.com
 Source Server Type    : MySQL
 Source Server Version : 50615
 Source Host           : amz1.yunkecrm.com:1818
 Source Schema         : amazon

 Target Server Type    : MySQL
 Target Server Version : 50615
 File Encoding         : 65001

 Date: 25/10/2018 21:34:47
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for ad_syn_ctrl
-- ----------------------------
DROP TABLE IF EXISTS `ad_syn_ctrl`;
CREATE TABLE `ad_syn_ctrl`  (
  `shop_id` int(11) NOT NULL,
  `sale_channel` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `user_id` int(11) NOT NULL,
  `report_date` date NOT NULL COMMENT '同步报告查询参数,列表默认为此参数前一天',
  `campaignsReportParm` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '同步查询参数,多个参数以JSON形式存入',
  `adgroupsReportParm` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '同步查询参数,多个参数以JSON形式存入',
  `keywordsReportParm` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '同步查询参数,多个参数以JSON形式存入',
  `productadsReportParm` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '同步查询参数,多个参数以JSON形式存入',
  `asinsReportParm` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '同步查询参数,多个参数以JSON形式存入',
  `campaigns` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `campaigns_report` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `adgroups` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `adgroups_report` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `keywords` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `keywords_report` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `productads` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `productads_report` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `asins_report` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `synBatch` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `is_delete` varchar(5) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `site_local_date` datetime(0) DEFAULT NULL COMMENT '站点当地时间',
  `last_update_time` datetime(0) DEFAULT NULL COMMENT '同步中国北京时间',
  `remarks` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '数据操作备注',
  PRIMARY KEY (`shop_id`, `sale_channel`, `user_id`, `report_date`, `synBatch`, `campaignsReportParm`, `adgroupsReportParm`, `keywordsReportParm`, `productadsReportParm`, `asinsReportParm`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of ad_syn_ctrl
-- ----------------------------
INSERT INTO `ad_syn_ctrl` VALUES (4, 'Amazon.ca', 4, '2018-10-24', '{\"campaignType\":\"sponsoredProducts\",\"reportDate\":\"20181024\",\"segment\":\"placement\"}', '{\"campaignType\":\"sponsoredProducts\",\"reportDate\":\"20181024\",\"segment\":\"\"}', '{\"campaignType\":\"sponsoredProducts\",\"reportDate\":\"20181024\",\"segment\":\"query\"}', '{\"campaignType\":\"sponsoredProducts\",\"reportDate\":\"20181024\",\"segment\":\"\"}', '{\"campaignType\":\"sponsoredProducts\",\"reportDate\":\"20181024\",\"segment\":\"\"}', 'success', 'success', 'success', 'unSent', 'unSent', 'unSent', 'unSent', 'unSent', 'unSent', 'one', '0', '2018-10-25 06:34:42', '2018-10-25 21:34:48', '20181025');
INSERT INTO `ad_syn_ctrl` VALUES (17, 'Amazon.com', 2000001003, '2018-10-24', '{\"campaignType\":\"sponsoredProducts\",\"reportDate\":\"20181024\",\"segment\":\"placement\"}', '{\"campaignType\":\"sponsoredProducts\",\"reportDate\":\"20181024\",\"segment\":\"\"}', '{\"campaignType\":\"sponsoredProducts\",\"reportDate\":\"20181024\",\"segment\":\"query\"}', '{\"campaignType\":\"sponsoredProducts\",\"reportDate\":\"20181024\",\"segment\":\"\"}', '{\"campaignType\":\"sponsoredProducts\",\"reportDate\":\"20181024\",\"segment\":\"\"}', 'unSent', 'unSent', 'unSent', 'unSent', 'unSent', 'unSent', 'unSent', 'unSent', 'unSent', 'one', '0', NULL, NULL, '20181025');
INSERT INTO `ad_syn_ctrl` VALUES (38, 'Amazon.com', 2000001003, '2018-10-24', '{\"campaignType\":\"sponsoredProducts\",\"reportDate\":\"20181024\",\"segment\":\"placement\"}', '{\"campaignType\":\"sponsoredProducts\",\"reportDate\":\"20181024\",\"segment\":\"\"}', '{\"campaignType\":\"sponsoredProducts\",\"reportDate\":\"20181024\",\"segment\":\"query\"}', '{\"campaignType\":\"sponsoredProducts\",\"reportDate\":\"20181024\",\"segment\":\"\"}', '{\"campaignType\":\"sponsoredProducts\",\"reportDate\":\"20181024\",\"segment\":\"\"}', 'unSent', 'unSent', 'unSent', 'unSent', 'unSent', 'unSent', 'unSent', 'unSent', 'unSent', 'one', '0', NULL, NULL, '20181025');
INSERT INTO `ad_syn_ctrl` VALUES (39, 'Amazon.com', 2000001003, '2018-10-24', '{\"campaignType\":\"sponsoredProducts\",\"reportDate\":\"20181024\",\"segment\":\"placement\"}', '{\"campaignType\":\"sponsoredProducts\",\"reportDate\":\"20181024\",\"segment\":\"\"}', '{\"campaignType\":\"sponsoredProducts\",\"reportDate\":\"20181024\",\"segment\":\"query\"}', '{\"campaignType\":\"sponsoredProducts\",\"reportDate\":\"20181024\",\"segment\":\"\"}', '{\"campaignType\":\"sponsoredProducts\",\"reportDate\":\"20181024\",\"segment\":\"\"}', 'unSent', 'unSent', 'unSent', 'unSent', 'unSent', 'unSent', 'unSent', 'unSent', 'unSent', 'one', '0', NULL, NULL, '20181025');
INSERT INTO `ad_syn_ctrl` VALUES (1527739293, 'Amazon.co.uk', 2000001003, '2018-10-24', '{\"campaignType\":\"sponsoredProducts\",\"reportDate\":\"20181024\",\"segment\":\"placement\"}', '{\"campaignType\":\"sponsoredProducts\",\"reportDate\":\"20181024\",\"segment\":\"\"}', '{\"campaignType\":\"sponsoredProducts\",\"reportDate\":\"20181024\",\"segment\":\"query\"}', '{\"campaignType\":\"sponsoredProducts\",\"reportDate\":\"20181024\",\"segment\":\"\"}', '{\"campaignType\":\"sponsoredProducts\",\"reportDate\":\"20181024\",\"segment\":\"\"}', 'unSent', 'unSent', 'unSent', 'unSent', 'unSent', 'unSent', 'unSent', 'unSent', 'unSent', 'one', '0', NULL, NULL, '20181025');
INSERT INTO `ad_syn_ctrl` VALUES (1533902413, 'Amazon.com', 2000001003, '2018-10-24', '{\"campaignType\":\"sponsoredProducts\",\"reportDate\":\"20181024\",\"segment\":\"placement\"}', '{\"campaignType\":\"sponsoredProducts\",\"reportDate\":\"20181024\",\"segment\":\"\"}', '{\"campaignType\":\"sponsoredProducts\",\"reportDate\":\"20181024\",\"segment\":\"query\"}', '{\"campaignType\":\"sponsoredProducts\",\"reportDate\":\"20181024\",\"segment\":\"\"}', '{\"campaignType\":\"sponsoredProducts\",\"reportDate\":\"20181024\",\"segment\":\"\"}', 'unSent', 'unSent', 'unSent', 'unSent', 'unSent', 'unSent', 'unSent', 'unSent', 'unSent', 'one', '0', NULL, NULL, '20181025');

SET FOREIGN_KEY_CHECKS = 1;
