package com.yunke.amazon.advertisingView.service.impl;

import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.yunke.amazon.advertisingView.dao.AdvertisingViewMapper;
import com.yunke.amazon.advertisingView.entity.ShopAdDataOverviewImageResult;
import com.yunke.amazon.advertisingView.service.AdvertisingViewService;
import com.yunke.amazon.advertisingView.utils.BigDecimalUtils;
import com.yunke.amazon.advertisingView.utils.PrintPercent;
import com.yunke.amazon.bind.dao.SubAccountDAO;
import com.yunke.amazon.client.util.NoteResult;
import com.yunke.amazon.util.StringToDate;
import com.yunke.amazon.util.SubPri;

@Service
public class AdvertisingViewServiceImpl implements AdvertisingViewService {

	@Resource
	private AdvertisingViewMapper advertisingViewMapper;
	@Resource
	private SubAccountDAO subAccountDAO;

	@Override
	public ShopAdDataOverviewImageResult shopAdDataOverviewImage(String user_id, String shop_id, String sale_channel,
			String startDate, String endDate, String shopAdDataOverviewType) {
		// TODO Auto-generated method stub

		ShopAdDataOverviewImageResult shopAdDataOverviewImageResult = new ShopAdDataOverviewImageResult();
		Map<Object, Object> map = new HashMap<>();
		SimpleDateFormat sdf = new SimpleDateFormat("yy-MM-dd");
		SimpleDateFormat sdf2 = new SimpleDateFormat("MM-dd");
		Date start = StringToDate.changeStringToDate(startDate);
		Date end = StringToDate.changeStringToDate(endDate);

		// Date end =new Date();
		// try {
		// end = sdf.parse(endDate);
		// } catch (ParseException e) {
		// e.printStackTrace();
		// }

		Calendar calendar = new GregorianCalendar();
		calendar.setTime(end);
		calendar.add(calendar.DATE, 1);
		end = calendar.getTime();
		String format2 = sdf.format(end);
		end = StringToDate.changeStringToDate(format2);
		map.put("start", start);
		map.put("end", end);
		SubPri subPri = SubPri.getSubPri(Integer.parseInt(user_id), subAccountDAO);
		if (subPri.getUserType() == 1) {
			map.put("userId", user_id);
			map.put("loginUserId", user_id);
			map.put("userType", "PriAccount");
		} else if (subPri.getUserType() == 0) {
			map.put("userId", subPri.getPriAccount());
			map.put("loginUserId", user_id);
			map.put("userType", "SubAccount");
		}
		map.put("shopId", shop_id);
		map.put("saleChannel", sale_channel);
		map.put("shopAdDataOverviewType", shopAdDataOverviewType);

		List<Map<String, String>> profitByDesigners = advertisingViewMapper.shopAdDataOverviewImage(map);
		// System.out.println("进入Impl调用存储过程");

		List<String> listDateX = new ArrayList<>();
		List<Integer> listExposureY = new ArrayList<>();
		List<Integer> listyClickY = new ArrayList<>();
		List<Double> listyOrderY = new ArrayList<>();

		Integer totalImpressions = 0;
		Integer totalClicks = 0;
		Integer totalOrders = 0;

		for (Map<?, ?> o : profitByDesigners) {
			listDateX.add((String) o.get("snapshotDate"));
			listExposureY.add(Integer.parseInt(o.get("impressions").toString()));
			listyClickY.add(Integer.parseInt(o.get("clicks").toString()));
			listyOrderY.add(Double.parseDouble(o.get("orders").toString()) * 100 / 100);

			totalImpressions += Integer.parseInt(o.get("impressions").toString());
			totalClicks += Integer.parseInt(o.get("clicks").toString());
			totalOrders += (int) Double.parseDouble(o.get("orders").toString()) * 100 / 100;
		}
		// System.out.println("totalImpressions = "+totalImpressions);
		// System.out.println("totalClicks = "+totalClicks);
		// System.out.println("totalOrders = "+totalOrders);

		shopAdDataOverviewImageResult.setX(listDateX);
		shopAdDataOverviewImageResult.setY1(listExposureY);
		shopAdDataOverviewImageResult.setY2(listyClickY);
		shopAdDataOverviewImageResult.setY3(listyOrderY);

		shopAdDataOverviewImageResult.setExposureTotal(totalImpressions);
		shopAdDataOverviewImageResult.setClickTotal(totalClicks);
		shopAdDataOverviewImageResult.setOrderTotal(totalOrders);

		return shopAdDataOverviewImageResult;

	}

	@Override
	public NoteResult shopAdReport(String userId, String shopId, String saleChannel, String startDate, String endDate,
			String shopAdDataOverviewType, String firstDimension, String secondDimension, String conditionalFilterKey,
			String conditionalFilterRelationship, String conditionalFilterValue, String currentPage, String pageSize,
			String sortVariable, String sortType) {
		// TODO Auto-generated method stub

		List<Map<String, String>> AdTableDate = new ArrayList<Map<String, String>>();
		List<Map<String, String>> AdTotalCount = new ArrayList<Map<String, String>>();
		
		switch (firstDimension) {
		case "campaigns":
			firstDimension = "campaign_id";
			break;
		case "adgroups":
			firstDimension = "ad_group_id";
			break;
		case "productads":
			firstDimension = "ad_id";
			break;
		case "keywords":
			firstDimension = "keyword_id";
			break;
		case "queryKeywords":
			firstDimension = "queryKeywords";
			break;
		case "SKU":
			firstDimension = "sku";
			break;

		default:
			break;
		}
		switch (secondDimension) {
		case "blank":
			secondDimension = null;
			break;
		case "campaigns":
			secondDimension = "campaign_id";
			break;
		case "adgroups":
			secondDimension = "ad_group_id";
			break;
		case "productads":
			secondDimension = "ad_id";
			break;
		case "keywords":
			secondDimension = "keyword_id";
			break;
		case "queryKeywords":
			secondDimension = "queryKeywords";
			break;
		case "SKU":
			secondDimension = "sku";
			break;

		default:
			break;
		}
		switch (conditionalFilterKey) {
		case "campaigns":
			conditionalFilterKey = "campaign_name";
			break;
		case "adgroups":
			conditionalFilterKey = "ad_group_name";
			break;
		case "ASIN":
			conditionalFilterKey = "asin";
			break;
		case "keywords":
			conditionalFilterKey = "keywordText";
			break;
		case "SKU":
			conditionalFilterKey = "sku";
			break;
		default:
			break;
		}

		switch (conditionalFilterRelationship) {
		case "equal":
			conditionalFilterRelationship = " = " + "'" + conditionalFilterValue + "' ";
			break;
		case "contain":
			conditionalFilterRelationship = " LIKE " + "'%" + conditionalFilterValue + "%' ";
			break;
		default:
			break;
		}

		System.out.println("firstDimension = " + firstDimension);
		System.out.println("secondDimension = " + secondDimension);
		NoteResult noteResult = new NoteResult();
		Map<Object, Object> map = new HashMap<>();
		SimpleDateFormat sdf = new SimpleDateFormat("yy-MM-dd");
		// SimpleDateFormat sdf2 = new SimpleDateFormat("MM-dd");
		Date start = StringToDate.changeStringToDate(startDate);
		Date end = StringToDate.changeStringToDate(endDate);

		Calendar calendar = new GregorianCalendar();
		calendar.setTime(end);
		calendar.add(calendar.DATE, 1);
		end = calendar.getTime();
		String format2 = sdf.format(end);
		end = StringToDate.changeStringToDate(format2);
		map.put("startDate", start);
		map.put("endDate", end);
		SubPri subPri = SubPri.getSubPri(Integer.parseInt(userId), subAccountDAO);
		if (subPri.getUserType() == 1) {
			map.put("userId", userId);
			map.put("loginUserId", userId);
			map.put("userType", "PriAccount");
		} else if (subPri.getUserType() == 0) {
			map.put("userId", subPri.getPriAccount());
			map.put("loginUserId", userId);
			map.put("userType", "SubAccount");
		}
		map.put("shopId", shopId);
		map.put("saleChannel", saleChannel);
		map.put("firstDimension", firstDimension);
		map.put("secondDimension", secondDimension);
		map.put("conditionalFilterKey", conditionalFilterKey);
		map.put("conditionalFilterRelationship", conditionalFilterRelationship);
		map.put("conditionalFilterValue", conditionalFilterValue);
		System.out.println("currentPage = " + currentPage);
		int currentPageStr = (Integer.parseInt(currentPage) - 1) * Integer.parseInt(pageSize);
		int pageSizeStr = Integer.parseInt(pageSize);
		map.put("currentPage", (Integer.parseInt(currentPage) - 1) * Integer.parseInt(pageSize) + "");
		map.put("pageSize", Integer.parseInt(pageSize) + "");
		map.put("sortVariable", sortVariable);
		map.put("sortType", sortType);
		String selectKeywordsWhere = "";
		String selectProductAdsWhere = "";
		String selectGroupby = firstDimension + "," + secondDimension;

		String limitStr = currentPageStr + "," + pageSizeStr;
		map.put("limitStr", limitStr);
		map.put("selectGroupby", selectGroupby);

		if ("blank".equals(conditionalFilterValue)) {
			selectKeywordsWhere = " keywords_report.`shop_id` = " + shopId + " AND keywords_report.`sale_channel` = '"
					+ saleChannel + "'";
		} else if (!"blank".equals(conditionalFilterValue)) {
			selectKeywordsWhere = " keywords_report.`shop_id` = " + shopId + " AND " + conditionalFilterKey + " "
					+ conditionalFilterRelationship + " " + " AND keywords_report.`sale_channel` = '" + saleChannel
					+ "'";
		} else {
			selectKeywordsWhere = " keywords_report.`shop_id` = " + shopId + " AND keywords_report.`sale_channel` = '"
					+ saleChannel + "'";
		}
		String selectKeywordsElement = "keywords_report.`shop_id`,keywords_report.`sale_channel`,"
				+ "keywords_report.`campaign_id`,keywords_report.`campaign_name`,keywords_report.`ad_group_id`,"
				+ "keywords_report.`ad_group_name`,keywords_report.`campaign_type`,keywords_report.`currency`,keywords_report.`query`,"
				+ "keywords_report.`segment`,keywords_report.`keyword_id`,keywords_report.`keywordText`,keywords_report.`matchType`,"
				+ "IF(SUM(keywords_report.`impressions`) IS NULL,0,SUM(keywords_report.`impressions`)) impressions,"
				+ "IF(SUM(keywords_report.`clicks`) IS NULL,0,SUM(keywords_report.`clicks`)) clicks,"
				+ "IF(SUM(keywords_report.`cost`) IS NULL,0,SUM(keywords_report.`cost`)) cost,"
				+ "IF(SUM(keywords_report.`attributed_sales7d`) IS NULL,0,SUM(keywords_report.`attributed_sales7d`)) attributed_sales7d,"
				+ "IF(SUM(keywords_report.`attributed_units_ordered7d`) IS NULL,0,SUM(keywords_report.`attributed_units_ordered7d`)) attributed_units_ordered7d,"
				+ "IF(SUM(keywords_report.`attributed_conversions7d`) IS NULL,0,SUM(keywords_report.`attributed_conversions7d`)) attributed_conversions7d,"
				+ "IF(SUM(keywords_report.`attributed_sales7d_sameSKU`) IS NULL,0,SUM(keywords_report.`attributed_sales7d_sameSKU`)) attributed_sales7d_sameSKU,"
				+ "IF(SUM(keywords_report.`attributed_conversions7d_sameSKU`) IS NULL,0,SUM(keywords_report.`attributed_conversions7d_sameSKU`)) attributed_conversions7d_sameSKU";

		if ("blank".equals(conditionalFilterValue)) {
			selectProductAdsWhere = " productads_report.`shop_id` = " + shopId
					+ " AND productads_report.`sale_channel` = '" + saleChannel + "'";
		} else if (!"blank".equals(conditionalFilterValue)) {
			selectProductAdsWhere = " productads_report.`shop_id` = " + shopId + " AND " + conditionalFilterKey + " "
					+ conditionalFilterRelationship + " " + " AND productads_report.`sale_channel` = '" + saleChannel
					+ "'";
		} else {
			selectProductAdsWhere = " productads_report.`shop_id` = " + shopId
					+ " AND productads_report.`sale_channel` = '" + saleChannel + "'";

		}
		String selectProductAdsElement = "productads_report.`shop_id`,productads_report.`sale_channel`,"
				+ "productads_report.`campaign_id`,productads_report.`campaign_name`,productads_report.`ad_group_id`,"
				+ "productads_report.`ad_group_name`,productads_report.`campaign_type`,productads_report.`currency`,"
				+ "productads_report.`segment`,productads_report.`ad_id`,productads_report.`sku`,productads_report.`asin`,"
				+ "IF(SUM(productads_report.`impressions`) IS NULL,0,SUM(productads_report.`impressions`)) impressions,"
				+ "IF(SUM(productads_report.`clicks`) IS NULL,0,SUM(productads_report.`clicks`)) clicks,"
				+ "IF(SUM(productads_report.`cost`) IS NULL,0,SUM(productads_report.`cost`)) cost,"
				+ "IF(SUM(productads_report.`attributed_sales7d`) IS NULL,0,SUM(productads_report.`attributed_sales7d`)) attributed_sales7d,"
				+ "IF(SUM(productads_report.`attributed_units_ordered7d`) IS NULL,0,SUM(productads_report.`attributed_units_ordered7d`)) attributed_units_ordered7d,"
				+ "IF(SUM(productads_report.`attributed_conversions7d`) IS NULL,0,SUM(productads_report.`attributed_conversions7d`)) attributed_conversions7d,"
				+ "IF(SUM(productads_report.`attributed_sales7d_sameSKU`) IS NULL,0,SUM(productads_report.`attributed_sales7d_sameSKU`)) attributed_sales7d_sameSKU,"
				+ "IF(SUM(productads_report.`attributed_conversions7d_sameSKU`) IS NULL,0,SUM(productads_report.`attributed_conversions7d_sameSKU`)) attributed_conversions7d_sameSKU";

		if (secondDimension == null && "blank".equals(conditionalFilterValue)) {
			if ("keyword_id".equals(firstDimension)) {
				System.out.println("查询关键词报告表");
				map.put("selectElement", selectKeywordsElement);
				map.put("selectWhere", selectKeywordsWhere);

				List<List<Map<String, String>>> adQueryKeywordsReport = advertisingViewMapper.adQueryKeywordsReport(map);

				if (adQueryKeywordsReport.size() != 0) {

					AdTableDate = adQueryKeywordsReport.get(0);
					AdTotalCount = adQueryKeywordsReport.get(1);

//					List<Map<String, String>> list2 = new ArrayList<Map<String, String>>();
//					for(int i =0;i<AdTableDate.size();i++){
//						Map<String, String> map1 = new HashMap<String,String>();
//						Map<String, String> map2 = new HashMap<String,String>();
//						Object obj0 = AdTableDate.get(i).get("currency");
//						Object obj1 = AdTableDate.get(i).get("impressions");
//						Object obj2 = AdTableDate.get(i).get("clicks");
//						Object obj3 = AdTableDate.get(i).get("cost");
//						map1 = AdTableDate.get(i);
//						
//						String currency =obj0.toString();
//						String currencyCode = "";
//						switch (currency) {
//						case "GBP":
//							currencyCode = "£";
//							break;
//						case "EUR":
//							currencyCode = "€";
//							break;
//						case "USD":
//							currencyCode = "$";
//							break;
//						case "JPY":
//							currencyCode = "￥";
//							break;
//						case "CAD":
//							currencyCode = "C$";
//							break;
//						case "MXN":
//							currencyCode = "$";
//							break;
//						default:
//							break;
//						}
//						
//						double impressions = Double.parseDouble(obj1.toString());
//						double clicks = Double.parseDouble(obj2.toString());
//						double cost = Double.parseDouble(obj3.toString());
//					
//						try {
//							double CPC = BigDecimalUtils.divide(cost, clicks);
//							map2.put("CPC", CPC+"");
//						} catch (Exception e) {
//							// TODO: handle exception
//							double CPC = 0;
//							map2.put("CPC", CPC+"");
//						}
//						NumberFormat nf = NumberFormat.getPercentInstance();
//						//保留几位小数
//						nf.setMaximumFractionDigits(2);
//						
//						map2.put("currencyCode", currencyCode);
//						map2.put("CTR", nf.format(clicks/impressions));
//						
//						
//						map1.putAll(map2);
//						list2.add(map1);
//					}
//					
//					noteResult.setStatus(0);
//					noteResult.setTotalCount(AdTotalCount.size());
//					noteResult.setPageCount((AdTotalCount.size() + Integer.parseInt(pageSize) - 1) / Integer.parseInt(pageSize));
//					noteResult.setData(AdTableDate);
				}

			}else if("queryKeywords".equals(firstDimension)){
				System.out.println("需要查询关键词表，买家搜索关键词");
				
			}else {
				System.out.println("查询广告报告表");
				map.put("selectElement", selectProductAdsElement);
				map.put("selectWhere", selectProductAdsWhere);

				List<List<Map<String, String>>> adQueryProductsAdsReport = advertisingViewMapper.adQueryProductsAdsReport(map);
				System.out.println("adQueryProductsAdsReport" + adQueryProductsAdsReport.toString());

				if (adQueryProductsAdsReport.size() != 0) {

					AdTableDate = adQueryProductsAdsReport.get(0);
					AdTotalCount = adQueryProductsAdsReport.get(1);

					
					noteResult.setStatus(0);
					noteResult.setTotalCount(AdTotalCount.size());
					noteResult.setPageCount((AdTotalCount.size() + Integer.parseInt(pageSize) - 1) / Integer.parseInt(pageSize));
					noteResult.setData(AdTableDate);
				}
			}

		} else if (secondDimension != null && "blank".equalsIgnoreCase(conditionalFilterValue)) {
			if("keyword_id".equals(firstDimension) && "sku".equals(secondDimension) || "sku".equalsIgnoreCase(firstDimension) && "keyword_id".equals(secondDimension)){
				System.out.println("需要查询asins报告表");
				
			}else if(("keyword_id".equals(firstDimension) || "keyword_id".equals(secondDimension)) && (! "sku".equalsIgnoreCase(firstDimension) && ! "sku".equalsIgnoreCase(secondDimension) && ! "ad_id".equals(firstDimension) && ! "ad_id".equals(secondDimension) && ! "queryKeywords".equalsIgnoreCase(firstDimension) && ! "queryKeywords".equalsIgnoreCase(secondDimension))){
				System.out.println("查询关键词报告表");
				map.put("selectElement", selectKeywordsElement);
				map.put("selectWhere", selectKeywordsWhere);

				List<List<Map<String, String>>> adQueryKeywordsReport = advertisingViewMapper.adQueryKeywordsReport(map);

				if (adQueryKeywordsReport.size() != 0) {

					AdTableDate = adQueryKeywordsReport.get(0);
					AdTotalCount = adQueryKeywordsReport.get(1);

					noteResult.setStatus(0);
					noteResult.setTotalCount(AdTotalCount.size());
					noteResult.setPageCount((AdTotalCount.size() + Integer.parseInt(pageSize) - 1) / Integer.parseInt(pageSize));
					noteResult.setData(AdTableDate);
				}
				
			}else if(("keyword_id".equals(firstDimension) && "ad_id".equals(secondDimension)) || ("ad_id".equals(firstDimension) && "keyword_id".equals(secondDimension))){
				System.out.println("暂不支持此种查询组合！");
				noteResult.setStatus(1);
				noteResult.setMsg("layer.alert('暂不支持此种查询组合！')");
				return noteResult;
			}else if("queryKeywords".equalsIgnoreCase(firstDimension) && "keyword_id".equals(secondDimension)){
				System.out.println("暂不支持此种查询组合,需要查询keywords报告中间表！");
				noteResult.setStatus(1);
				noteResult.setMsg("layer.alert('暂不支持此种查询组合！')");
				return noteResult;
			}else if("queryKeywords".equalsIgnoreCase(firstDimension) && ! "keyword_id".equals(secondDimension) ){
				noteResult.setStatus(1);
				noteResult.setMsg("layer.alert('暂未开通此种查询组合！')");
				return noteResult;
			}else{
				System.out.println("查询广告报告表");
				map.put("selectElement", selectProductAdsElement);
				map.put("selectWhere", selectProductAdsWhere);

				List<List<Map<String, String>>> adQueryProductsAdsReport = advertisingViewMapper.adQueryProductsAdsReport(map);
				System.out.println("adQueryProductsAdsReport" + adQueryProductsAdsReport.toString());

				if (adQueryProductsAdsReport.size() != 0) {

					AdTableDate = adQueryProductsAdsReport.get(0);
					AdTotalCount = adQueryProductsAdsReport.get(1);

					noteResult.setStatus(0);
					noteResult.setTotalCount(AdTotalCount.size());
					noteResult.setPageCount((AdTotalCount.size() + Integer.parseInt(pageSize) - 1) / Integer.parseInt(pageSize));
					noteResult.setData(AdTableDate);
				}
			}
		} else if (secondDimension == null && !"blank".equalsIgnoreCase(conditionalFilterValue)) {
			if("campaign_id".equals(firstDimension) && "campaign_name".equals(conditionalFilterKey) ){
				System.out.println("查询广告报告表");
				map.put("selectElement", selectProductAdsElement);
				map.put("selectWhere", selectProductAdsWhere);

				List<List<Map<String, String>>> adQueryProductsAdsReport = advertisingViewMapper.adQueryProductsAdsReport(map);
				System.out.println("adQueryProductsAdsReport" + adQueryProductsAdsReport.toString());

				if (adQueryProductsAdsReport.size() != 0) {

					AdTableDate = adQueryProductsAdsReport.get(0);
					AdTotalCount = adQueryProductsAdsReport.get(1);

					noteResult.setStatus(0);
					noteResult.setTotalCount(AdTotalCount.size());
					noteResult.setPageCount((AdTotalCount.size() + Integer.parseInt(pageSize) - 1) / Integer.parseInt(pageSize));
					noteResult.setData(AdTableDate);
				}
			}else if("ad_group_id".equals(firstDimension) && ("campaign_name".equals(conditionalFilterKey) || "ad_group_name".equals(conditionalFilterKey) )){
				System.out.println("查询广告报告表");
				map.put("selectElement", selectProductAdsElement);
				map.put("selectWhere", selectProductAdsWhere);

				List<List<Map<String, String>>> adQueryProductsAdsReport = advertisingViewMapper.adQueryProductsAdsReport(map);
				System.out.println("adQueryProductsAdsReport" + adQueryProductsAdsReport.toString());

				if (adQueryProductsAdsReport.size() != 0) {

					AdTableDate = adQueryProductsAdsReport.get(0);
					AdTotalCount = adQueryProductsAdsReport.get(1);

					noteResult.setStatus(0);
					noteResult.setTotalCount(AdTotalCount.size());
					noteResult.setPageCount((AdTotalCount.size() + Integer.parseInt(pageSize) - 1) / Integer.parseInt(pageSize));
					noteResult.setData(AdTableDate);
				}
			}else if("ad_id".equals(firstDimension) && ("campaign_name".equals(conditionalFilterKey) || "ad_group_name".equals(conditionalFilterKey) || "asin".equalsIgnoreCase(conditionalFilterKey) || "sku".equalsIgnoreCase(conditionalFilterKey) )){
				System.out.println("查询广告报告表");
				map.put("selectElement", selectProductAdsElement);
				map.put("selectWhere", selectProductAdsWhere);

				List<List<Map<String, String>>> adQueryProductsAdsReport = advertisingViewMapper.adQueryProductsAdsReport(map);
				System.out.println("adQueryProductsAdsReport" + adQueryProductsAdsReport.toString());

				if (adQueryProductsAdsReport.size() != 0) {

					AdTableDate = adQueryProductsAdsReport.get(0);
					AdTotalCount = adQueryProductsAdsReport.get(1);

					noteResult.setStatus(0);
					noteResult.setTotalCount(AdTotalCount.size());
					noteResult.setPageCount((AdTotalCount.size() + Integer.parseInt(pageSize) - 1) / Integer.parseInt(pageSize));
					noteResult.setData(AdTableDate);
				}
			}else if("sku".equalsIgnoreCase(firstDimension) && ("campaign_name".equals(conditionalFilterKey) || "ad_group_name".equals(conditionalFilterKey) || "asin".equalsIgnoreCase(conditionalFilterKey) || "sku".equalsIgnoreCase(conditionalFilterKey) )){
				System.out.println("查询广告报告表");
				map.put("selectElement", selectProductAdsElement);
				map.put("selectWhere", selectProductAdsWhere);

				List<List<Map<String, String>>> adQueryProductsAdsReport = advertisingViewMapper.adQueryProductsAdsReport(map);
				System.out.println("adQueryProductsAdsReport" + adQueryProductsAdsReport.toString());

				if (adQueryProductsAdsReport.size() != 0) {

					AdTableDate = adQueryProductsAdsReport.get(0);
					AdTotalCount = adQueryProductsAdsReport.get(1);

					noteResult.setStatus(0);
					noteResult.setTotalCount(AdTotalCount.size());
					noteResult.setPageCount((AdTotalCount.size() + Integer.parseInt(pageSize) - 1) / Integer.parseInt(pageSize));
					noteResult.setData(AdTableDate);
				}
			}else if("keyword_id".equalsIgnoreCase(firstDimension) && ("campaign_name".equals(conditionalFilterKey) || "ad_group_name".equals(conditionalFilterKey) || "keywordText".equals(conditionalFilterKey) )){
				System.out.println("查询关键词报告表");
				map.put("selectElement", selectKeywordsElement);
				map.put("selectWhere", selectKeywordsWhere);

				List<List<Map<String, String>>> adQueryKeywordsReport = advertisingViewMapper.adQueryKeywordsReport(map);

				if (adQueryKeywordsReport.size() != 0) {

					AdTableDate = adQueryKeywordsReport.get(0);
					AdTotalCount = adQueryKeywordsReport.get(1);

					noteResult.setStatus(0);
					noteResult.setTotalCount(AdTotalCount.size());
					noteResult.setPageCount((AdTotalCount.size() + Integer.parseInt(pageSize) - 1) / Integer.parseInt(pageSize));
					noteResult.setData(AdTableDate);
				}
			}else if("keyword_id".equalsIgnoreCase(firstDimension) && ("sku".equalsIgnoreCase(conditionalFilterKey) || "asin".equalsIgnoreCase(conditionalFilterKey))){
				System.out.println("查询asins报告表");
				
			}else if("keyword_id".equalsIgnoreCase(firstDimension) && "queryKeywords".equalsIgnoreCase(conditionalFilterKey) ){
				System.out.println("查询asins报告表");
				noteResult.setStatus(1);
				noteResult.setMsg("layer.alert('暂不支持此种查询组合！')");
				return noteResult;
				
			}else if("queryKeywords".equalsIgnoreCase(firstDimension)){
				if(("campaign_name".equals(conditionalFilterKey) || "ad_group_name".equals(conditionalFilterKey) || "keywordText".equalsIgnoreCase(conditionalFilterKey) || "queryKeywords".equals(conditionalFilterKey))){
					System.out.println("查询买家搜索关键词合成中间表");
				}
				else if("asin".equalsIgnoreCase(conditionalFilterKey) || "sku".equalsIgnoreCase(conditionalFilterKey)){
					noteResult.setStatus(1);
					noteResult.setMsg("layer.alert('查询条件有误，请确认后重新输入！')");
					return noteResult;
				}else{
					noteResult.setStatus(1);
					noteResult.setMsg("layer.alert('暂不支持此种查询组合！')");
					return noteResult;
				}
			}
			else{
				noteResult.setStatus(1);
				noteResult.setMsg("layer.alert('查询条件有误，请确认后重新输入！')");
				return noteResult;
			}
		} else if (secondDimension != null && !"blank".equalsIgnoreCase(conditionalFilterValue)) {
			if(("campaign_id".equals(firstDimension) && "campaign_id".equals(secondDimension)) || ("campaign_id".equals(secondDimension) && "campaign_id".equals(firstDimension))){
				if("campaign_name".equals(conditionalFilterKey)){
					System.out.println("查询广告报告表");
					map.put("selectElement", selectProductAdsElement);
					map.put("selectWhere", selectProductAdsWhere);

					List<List<Map<String, String>>> adQueryProductsAdsReport = advertisingViewMapper.adQueryProductsAdsReport(map);
					System.out.println("adQueryProductsAdsReport" + adQueryProductsAdsReport.toString());

					if (adQueryProductsAdsReport.size() != 0) {

						AdTableDate = adQueryProductsAdsReport.get(0);
						AdTotalCount = adQueryProductsAdsReport.get(1);

						noteResult.setStatus(0);
						noteResult.setTotalCount(AdTotalCount.size());
						noteResult.setPageCount((AdTotalCount.size() + Integer.parseInt(pageSize) - 1) / Integer.parseInt(pageSize));
						noteResult.setData(AdTableDate);
					}
				}else{
					noteResult.setStatus(1);
					noteResult.setMsg("layer.alert('查询条件有误，请确认后重新输入！')");
					return noteResult;
				}
				
				
			}else if(("campaign_id".equals(firstDimension) && "ad_group_id".equals(secondDimension)) || ("campaign_id".equals(secondDimension) && "ad_group_id".equals(firstDimension))){
				if("campaign_name".equals(conditionalFilterKey) || "ad_group_name".equals(conditionalFilterKey)){
					System.out.println("查询广告报告表");
					map.put("selectElement", selectProductAdsElement);
					map.put("selectWhere", selectProductAdsWhere);

					List<List<Map<String, String>>> adQueryProductsAdsReport = advertisingViewMapper.adQueryProductsAdsReport(map);
					System.out.println("adQueryProductsAdsReport" + adQueryProductsAdsReport.toString());

					if (adQueryProductsAdsReport.size() != 0) {

						AdTableDate = adQueryProductsAdsReport.get(0);
						AdTotalCount = adQueryProductsAdsReport.get(1);

						noteResult.setStatus(0);
						noteResult.setTotalCount(AdTotalCount.size());
						noteResult.setPageCount((AdTotalCount.size() + Integer.parseInt(pageSize) - 1) / Integer.parseInt(pageSize));
						noteResult.setData(AdTableDate);
					}
				}else{
					noteResult.setStatus(1);
					noteResult.setMsg("layer.alert('查询条件有误，请确认后重新输入！')");
					return noteResult;
				}
				
			}else if(("campaign_id".equals(firstDimension) && "ad_id".equals(secondDimension) || ("campaign_id".equals(firstDimension) && "sku".equals(secondDimension))) || ("campaign_id".equals(secondDimension) && "ad_id".equals(firstDimension) || ("campaign_id".equals(secondDimension) && "sku".equals(firstDimension)))){
				if("campaign_name".equals(conditionalFilterKey) || "ad_group_name".equals(conditionalFilterKey) || "asin".equals(conditionalFilterKey) || "sku".equalsIgnoreCase(conditionalFilterKey)){
					System.out.println("查询广告报告表");
					map.put("selectElement", selectProductAdsElement);
					map.put("selectWhere", selectProductAdsWhere);

					List<List<Map<String, String>>> adQueryProductsAdsReport = advertisingViewMapper.adQueryProductsAdsReport(map);
					System.out.println("adQueryProductsAdsReport" + adQueryProductsAdsReport.toString());

					if (adQueryProductsAdsReport.size() != 0) {

						AdTableDate = adQueryProductsAdsReport.get(0);
						AdTotalCount = adQueryProductsAdsReport.get(1);

						noteResult.setStatus(0);
						noteResult.setTotalCount(AdTotalCount.size());
						noteResult.setPageCount((AdTotalCount.size() + Integer.parseInt(pageSize) - 1) / Integer.parseInt(pageSize));
						noteResult.setData(AdTableDate);
					}
				}else{
					noteResult.setStatus(1);
					noteResult.setMsg("layer.alert('查询条件有误，请确认后重新输入！')");
					return noteResult;
				}
			}else if(("campaign_id".equals(firstDimension) && "keyword_id".equals(secondDimension)) || "campaign_id".equals(secondDimension) && "keyword_id".equals(firstDimension)){
				if("campaign_name".equals(conditionalFilterKey) || "ad_group_name".equals(conditionalFilterKey) || "keywordText".equalsIgnoreCase(conditionalFilterKey) && (! "asin".equals(conditionalFilterKey) || !"sku".equalsIgnoreCase(conditionalFilterKey) || !"queryKeywords".equalsIgnoreCase(conditionalFilterKey))){
					System.out.println("查询关键词报告表");
					map.put("selectElement", selectKeywordsElement);
					map.put("selectWhere", selectKeywordsWhere);

					List<List<Map<String, String>>> adQueryKeywordsReport = advertisingViewMapper.adQueryKeywordsReport(map);

					if (adQueryKeywordsReport.size() != 0) {

						AdTableDate = adQueryKeywordsReport.get(0);
						AdTotalCount = adQueryKeywordsReport.get(1);

						noteResult.setStatus(0);
						noteResult.setTotalCount(AdTotalCount.size());
						noteResult.setPageCount((AdTotalCount.size() + Integer.parseInt(pageSize) - 1) / Integer.parseInt(pageSize));
						noteResult.setData(AdTableDate);
					}
				}else if("asin".equals(conditionalFilterKey) || "sku".equalsIgnoreCase(conditionalFilterKey)){
					System.out.println("查询asins报告表");
					
				}else if("queryKeywords".equalsIgnoreCase(conditionalFilterKey)){
					noteResult.setStatus(1);
					noteResult.setMsg("layer.alert('暂不支持此种查询组合！')");
					return noteResult;
				}else{
					noteResult.setStatus(1);
					noteResult.setMsg("layer.alert('查询条件有误，请确认后重新输入！')");
					return noteResult;
				}
			}else if("ad_group_id".equals(firstDimension) && "ad_group_id".equals(secondDimension)){
				System.out.println("sddedddddddddddddd");
				if("campaign_name".equals(conditionalFilterKey) || "ad_group_name".equals(conditionalFilterKey)){
					System.out.println("查询广告报告表");
					map.put("selectElement", selectProductAdsElement);
					map.put("selectWhere", selectProductAdsWhere);

					List<List<Map<String, String>>> adQueryProductsAdsReport = advertisingViewMapper.adQueryProductsAdsReport(map);
					System.out.println("adQueryProductsAdsReport" + adQueryProductsAdsReport.toString());

					if (adQueryProductsAdsReport.size() != 0) {

						AdTableDate = adQueryProductsAdsReport.get(0);
						AdTotalCount = adQueryProductsAdsReport.get(1);

						noteResult.setStatus(0);
						noteResult.setTotalCount(AdTotalCount.size());
						noteResult.setPageCount((AdTotalCount.size() + Integer.parseInt(pageSize) - 1) / Integer.parseInt(pageSize));
						noteResult.setData(AdTableDate);
					}
				}else{
					noteResult.setStatus(1);
					noteResult.setMsg("layer.alert('查询条件有误，请确认后重新输入！')");
					return noteResult;
				}
				
			}else if(( "ad_group_id".equals(firstDimension) && "ad_id".equals(secondDimension)) || ("ad_group_id".equals(secondDimension) && "ad_id".equals(firstDimension) || ( "ad_group_id".equals(firstDimension) && "sku".equalsIgnoreCase(secondDimension)) || ( "ad_group_id".equals(secondDimension) && "sku".equalsIgnoreCase(firstDimension)) )){
				System.out.println("sddddvdddddddddddd");
				if("campaign_name".equals(conditionalFilterKey) || "ad_group_name".equals(conditionalFilterKey) || "asin".equalsIgnoreCase(conditionalFilterKey) || "sku".equalsIgnoreCase(conditionalFilterKey)){
					System.out.println("查询广告报告表");
					map.put("selectElement", selectProductAdsElement);
					map.put("selectWhere", selectProductAdsWhere);

					List<List<Map<String, String>>> adQueryProductsAdsReport = advertisingViewMapper.adQueryProductsAdsReport(map);
					System.out.println("adQueryProductsAdsReport" + adQueryProductsAdsReport.toString());

					if (adQueryProductsAdsReport.size() != 0) {

						AdTableDate = adQueryProductsAdsReport.get(0);
						AdTotalCount = adQueryProductsAdsReport.get(1);

						noteResult.setStatus(0);
						noteResult.setTotalCount(AdTotalCount.size());
						noteResult.setPageCount((AdTotalCount.size() + Integer.parseInt(pageSize) - 1) / Integer.parseInt(pageSize));
						noteResult.setData(AdTableDate);
					}
				}else if("keywordText".equalsIgnoreCase(conditionalFilterKey)){
					noteResult.setStatus(1);
					noteResult.setMsg("layer.alert('查询条件有误，请确认后重新输入！')");
					return noteResult;
				}else if("queryKeywords".equals(conditionalFilterKey)){
					noteResult.setStatus(1);
					noteResult.setMsg("layer.alert('查询条件有误，请确认后重新输入！')");
					return noteResult;
				}else{
					noteResult.setStatus(1);
					noteResult.setMsg("layer.alert('查询条件有误，请确认后重新输入！！！')");
					return noteResult;
				}
			}else if(( "ad_group_id".equals(firstDimension) && "keyword_id".equals(secondDimension)) || ("ad_group_id".equals(secondDimension) && "keyword_id".equals(firstDimension))){
				System.out.println("sddddddddddddddsdd");
				if("campaign_name".equals(conditionalFilterKey) || "ad_group_name".equals(conditionalFilterKey) || "keywordText".equalsIgnoreCase(conditionalFilterKey)){
					System.out.println("查询关键词报告表。");
					map.put("selectElement", selectKeywordsElement);
					map.put("selectWhere", selectKeywordsWhere);

					List<List<Map<String, String>>> adQueryKeywordsReport = advertisingViewMapper.adQueryKeywordsReport(map);

					if (adQueryKeywordsReport.size() != 0) {

						AdTableDate = adQueryKeywordsReport.get(0);
						AdTotalCount = adQueryKeywordsReport.get(1);
						noteResult.setStatus(0);
						noteResult.setTotalCount(AdTotalCount.size());
						noteResult.setPageCount((AdTotalCount.size() + Integer.parseInt(pageSize) - 1) / Integer.parseInt(pageSize));
						noteResult.setData(AdTableDate);
					}
				}else if("queryKeywords".equals(conditionalFilterKey)){
					noteResult.setStatus(1);
					noteResult.setMsg("layer.alert('暂不支持此种查询组合！')");
					return noteResult;
				}else if("asin".equals(conditionalFilterKey) || "sku".equals(conditionalFilterKey)){
					System.out.println("需要查询asins报告表");
				}else{
					noteResult.setStatus(1);
					noteResult.setMsg("layer.alert('查询条件有误，请确认后重新输入！')");
					return noteResult;
				}
				
			}else if( "ad_group_id".equals(firstDimension) && ("campaign_id".equals(firstDimension) || "ad_group_id".equals(firstDimension)) ){
				System.out.println("33333333333333333");
				if("campaign_name".equals(conditionalFilterKey) || "ad_group_name".equals(conditionalFilterKey) || "asin".equalsIgnoreCase(conditionalFilterKey) || "sku".equalsIgnoreCase(conditionalFilterKey)){
					System.out.println("查询广告报告表");
					map.put("selectElement", selectProductAdsElement);
					map.put("selectWhere", selectProductAdsWhere);

					List<List<Map<String, String>>> adQueryProductsAdsReport = advertisingViewMapper.adQueryProductsAdsReport(map);
					System.out.println("adQueryProductsAdsReport" + adQueryProductsAdsReport.toString());

					if (adQueryProductsAdsReport.size() != 0) {

						AdTableDate = adQueryProductsAdsReport.get(0);
						AdTotalCount = adQueryProductsAdsReport.get(1);

						noteResult.setStatus(0);
						noteResult.setTotalCount(AdTotalCount.size());
						noteResult.setPageCount((AdTotalCount.size() + Integer.parseInt(pageSize) - 1) / Integer.parseInt(pageSize));
						noteResult.setData(AdTableDate);
					}
				}else{
					noteResult.setStatus(1);
					noteResult.setMsg("layer.alert('查询条件有误，请确认后重新输入！')");
					return noteResult;
				}
			}else if("ad_id".equals(firstDimension) && ( "ad_id".equals(secondDimension) || "sku".equals(secondDimension))){
				if(! "keywordText".equalsIgnoreCase(conditionalFilterKey) && ! "queryKeywords".equalsIgnoreCase(conditionalFilterKey)){
					System.out.println("查询广告报告表");
					map.put("selectElement", selectProductAdsElement);
					map.put("selectWhere", selectProductAdsWhere);

					List<List<Map<String, String>>> adQueryProductsAdsReport = advertisingViewMapper.adQueryProductsAdsReport(map);
					System.out.println("adQueryProductsAdsReport" + adQueryProductsAdsReport.toString());

					if (adQueryProductsAdsReport.size() != 0) {

						AdTableDate = adQueryProductsAdsReport.get(0);
						AdTotalCount = adQueryProductsAdsReport.get(1);

						noteResult.setStatus(0);
						noteResult.setTotalCount(AdTotalCount.size());
						noteResult.setPageCount((AdTotalCount.size() + Integer.parseInt(pageSize) - 1) / Integer.parseInt(pageSize));
						noteResult.setData(AdTableDate);
					}
				}else{
					noteResult.setStatus(1);
					noteResult.setMsg("layer.alert('查询条件有误，请确认后重新输入！')");
					return noteResult;
				}
			}else if("keyword_id".equals(firstDimension) && "keyword_id".equals(secondDimension)){
				if("campaign_name".equalsIgnoreCase(conditionalFilterKey) || "ad_group_name".equalsIgnoreCase(conditionalFilterKey) || "keywordText".equalsIgnoreCase(conditionalFilterKey)){
					System.out.println("查询关键词报告表");
					map.put("selectElement", selectKeywordsElement);
					map.put("selectWhere", selectKeywordsWhere);

					List<List<Map<String, String>>> adQueryKeywordsReport = advertisingViewMapper.adQueryKeywordsReport(map);

					if (adQueryKeywordsReport.size() != 0) {

						AdTableDate = adQueryKeywordsReport.get(0);
						AdTotalCount = adQueryKeywordsReport.get(1);
						noteResult.setStatus(0);
						noteResult.setTotalCount(AdTotalCount.size());
						noteResult.setPageCount((AdTotalCount.size() + Integer.parseInt(pageSize) - 1) / Integer.parseInt(pageSize));
						noteResult.setData(AdTableDate);
					}
				}else if("queryKeywords".equals(conditionalFilterKey)){
					noteResult.setStatus(1);
					noteResult.setMsg("layer.alert('暂不支持此种查询组合！')");
					return noteResult;
				}else if("asin".equals(conditionalFilterKey) || "sku".equals(conditionalFilterKey)){
					System.out.println("需要查询asins报告表");
				}
			}
//			--------------维度包含SKU与过滤条件关键词的组合-------------------
			else{
				noteResult.setStatus(1);
				noteResult.setMsg("layer.alert('查询条件有误，请确认后重新输入！')");
				return noteResult;
			}
		}else {
			noteResult.setStatus(1);
			noteResult.setMsg("layer.alert('暂不支持此种查询组合,end！')");
			return noteResult;
		}
		List<Map<String, String>> list2 = new ArrayList<Map<String, String>>();
		for(int i =0;i<AdTableDate.size();i++){
			Map<String, String> map1 = new HashMap<String,String>();
			Map<String, String> map2 = new HashMap<String,String>();
			Object obj0 = AdTableDate.get(i).get("currency");
			Object obj1 = AdTableDate.get(i).get("impressions");
			Object obj2 = AdTableDate.get(i).get("clicks");
			Object obj3 = AdTableDate.get(i).get("cost");
			map1 = AdTableDate.get(i);
			
			String currency =obj0.toString();
			String currencyCode = "";
			switch (currency) {
			case "GBP":
				currencyCode = "£";
				break;
			case "EUR":
				currencyCode = "€";
				break;
			case "USD":
				currencyCode = "$";
				break;
			case "JPY":
				currencyCode = "￥";
				break;
			case "CAD":
				currencyCode = "C$";
				break;
			case "MXN":
				currencyCode = "$";
				break;
			default:
				break;
			}
			
			double impressions = Double.parseDouble(obj1.toString());
			double clicks = Double.parseDouble(obj2.toString());
			double cost = Double.parseDouble(obj3.toString());
		
			try {
				double CPC = BigDecimalUtils.divide(cost, clicks);
				map2.put("CPC", CPC+"");
			} catch (Exception e) {
				// TODO: handle exception
				double CPC = 0;
				map2.put("CPC", CPC+"");
			}
			NumberFormat nf = NumberFormat.getPercentInstance();
			//保留几位小数
			nf.setMaximumFractionDigits(2);
			
			map2.put("currencyCode", currencyCode);
			map2.put("CTR", nf.format(clicks/impressions));
			
			
			map1.putAll(map2);
			list2.add(map1);
		}
		
		noteResult.setStatus(0);
		noteResult.setTotalCount(AdTotalCount.size());
		noteResult.setPageCount((AdTotalCount.size() + Integer.parseInt(pageSize) - 1) / Integer.parseInt(pageSize));
		noteResult.setData(AdTableDate);
		return noteResult;
	}
}
