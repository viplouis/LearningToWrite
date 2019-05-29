package com.kunda.store.sta.utils;

import com.kunda.store.sta.entity.DataValue;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * @Author zhangbaiquan
 * @Email zbaiquan@163.com
 * @Description
 * @Date 2019/5/17 17:26
 * @Version 1.0
 **/
public class CalendarUtil {

    //结果集合
    private ArrayList<DataValue> dateResult = new ArrayList<DataValue>();

    /**
     * 得到几天前的时间
     * 
     * @param date
     * @param day
     * @return
     */
    public String getDateBefore(Date date, int day) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Calendar no = Calendar.getInstance();
        no.setTime(date);
        no.set(Calendar.DATE, no.get(Calendar.DATE) - day);
        return sdf.format(no.getTime());
    }

    /**
     * 得到月份日期范围
     * 
     * @param
     * @return
     */
    public String getMonthDateRange() {
        // 获取当前年份、月份、日期
        Calendar cale = Calendar.getInstance();

        // 获取当月第一天和最后一天
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        String firstday, lastday;
        // 获取前月的第一天
        cale = Calendar.getInstance();
        cale.add(Calendar.MONTH, 0);
        cale.set(Calendar.DAY_OF_MONTH, 1);
        firstday = format.format(cale.getTime());
        // 获取前月的最后一天
        cale = Calendar.getInstance();
        cale.add(Calendar.MONTH, 1);
        cale.set(Calendar.DAY_OF_MONTH, 0);
        lastday = format.format(cale.getTime());
        System.out.println("本月第一天和最后一天分别是 ： " + firstday + " - " + lastday);
        return firstday + " - " + lastday;
    }

    public List<DataValue> getDataCompletion (List<DataValue> list, Map<String, Object> paraMap) {

        Date dateBegin, dateEnd;
        int days = 0;
        Calendar calendar10 = Calendar.getInstance();
        Calendar calendar5 = Calendar.getInstance();

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        try {
            dateBegin = sdf.parse(paraMap.get("startDate").toString());
            dateEnd = sdf.parse(paraMap.get("endDate").toString());
            /*
             * 计算开始时间和结束时间之间有几天
             * 如果想显示 01, 02, 03 三天的数据 结束日期需要传04, 因为01日 00:00 -- 04日 00:00 并不包括04
             */
            days = (int) ((dateEnd.getTime() - dateBegin.getTime()) / (1000*3600*24));
            calendar10.setTime(dateBegin);

        } catch (ParseException e) {
            e.printStackTrace();
        }

        //循环处理日期数据，把缺失的日期补全。days是时间段内的天数, beforList.size()是要处理的日期集合的天数
        for (int curr = 0; curr < days; curr++) {

            boolean dbDataExist = false;
            int index = 0;

            for(int i = 0 ; i < list.size() ; i++){

                try {
                    DataValue dataValue = list.get(i);

                    Date date2 = sdf.parse(dataValue.getDataLine());
                    calendar5.setTime(date2);
                } catch (ParseException e) {
                    e.printStackTrace();
                }

                if(calendar10.compareTo(calendar5) == 0){
                    dbDataExist  = true;
                    index = i;
                    break;
                }
            }
            if(dbDataExist){
                DataValue testbb = list.get(index);

                dateResult.add(testbb);
            }else{
                DataValue testbb = new DataValue();
                testbb.setDataLine(sdf.format(calendar10.getTime()));
                testbb.setValue(0.0);

                dateResult.add(testbb);
            }
            //修改外层循环变量, 是calendar10 +1天, 一天后的日期
            calendar10.add(Calendar.DAY_OF_MONTH, 1 );
        }

        //打印结果

//        for(DataValue str : dateResult){
//            System.out.println(str);
//        }
        return dateResult;
    }


}
