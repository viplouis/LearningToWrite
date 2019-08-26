mysql查询一周内的数据，解决一周的起始日期是从星期日(星期天|周日|周天)开始的问题

原文链接：https://blog.csdn.net/qq_27471405/article/details/84935791

前言
今天又遇到很坑的问题了，因为外国友人每一周的起始日期是周日，跟我们的不一样，我们每一周的起始日期是星期一，这样导致我要用mysql统计一周的数据的时候，对于我们来说，查询的记录包括：上周日的记录+本周的数据到星期六 这样的数据，这就不符合我们的要求，把上周日的数据也统计进来了。

所以也是找了好久的资料，才终于解决

 

一、问题发现：
默认我一开始写的测试查询本周上周数据的语句是这样的：

#查询本周
select A.sushenum,cast(A.dfdata as DECIMAL (10,3)) dfdatanumber,A.dfdata,
        cast(A.dfmoney as DECIMAL (10,3)) dfmoneynumber,A.dfmoney,DATE_FORMAT(A.lrrq,'%Y-%m-%d %H:%i:%S') lrrq
        from tablename_test A
        where YEARWEEK(date_format(A.lrrq,'%Y-%m-%d')) = YEARWEEK(now())
        and A.sushenum = '1309'
 
 
#查询上周
select A.sushenum,cast(A.dfdata as DECIMAL (10,3)) dfdatanumber,A.dfdata,
        cast(A.dfmoney as DECIMAL (10,3)) dfmoneynumber,A.dfmoney,DATE_FORMAT(A.lrrq,'%Y-%m-%d %H:%i:%S') lrrq
        from tablename_test A
        where YEARWEEK(date_format(A.lrrq,'%Y-%m-%d')) = YEARWEEK(now())-1
        and A.sushenum = '1309'
顺便提一下，查询本周和上周的区别，大家可以对照上面两条sql语句，区别就是

本周是 YEARWEEK(now())-0 

上周是 YEARWEEK(now())-1

上上周也就是 YEARWEEK(now())-2,以此类推。

大家可以很明显的看到2018年12月2日的记录也查出来了，12月2日是星期日。为了让大家更直观的看，我把12月的月份截出来

所以这样查询出来的记录，对于我们来说是有问题的。接下来教大家解决办法。

 

二、问题解决
可以清楚的知道，mysql查询本周，上周用到的是YEARWEEK()这个函数，具体使用教程可以看链接：http://www.runoob.com/mysql/mysql-functions.html
 ———————————————— 
版权声明：本文为CSDN博主「小小鱼儿小小林」的原创文章，遵循CC 4.0 by-sa版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/qq_27471405/article/details/84935791

从上面YEARWEEK()函数API可以知道，还有mode这个字段是可以自己设置一周是从星期几开始的，不写的话默认是星期日为一周的开始日期，这里为了适用我们的系统，将星期一设置为一周的开始日期，我们就给mode设为1就可以啦。

修改后：

#查询本周
select A.sushenum,cast(A.dfdata as DECIMAL (10,3)) dfdatanumber,A.dfdata,
        cast(A.dfmoney as DECIMAL (10,3)) dfmoneynumber,A.dfmoney,DATE_FORMAT(A.lrrq,'%Y-%m-%d %H:%i:%S') lrrq
        from tablename_test A
        where YEARWEEK(date_format(A.lrrq,'%Y-%m-%d'),1) = YEARWEEK(now(),1)
        and A.sushenum = '1309'
 
 
#查询上周
select A.sushenum,cast(A.dfdata as DECIMAL (10,3)) dfdatanumber,A.dfdata,
        cast(A.dfmoney as DECIMAL (10,3)) dfmoneynumber,A.dfmoney,DATE_FORMAT(A.lrrq,'%Y-%m-%d %H:%i:%S') lrrq
        from tablename_test A
        where YEARWEEK(date_format(A.lrrq,'%Y-%m-%d'),1) = YEARWEEK(now(),1)-1
        and A.sushenum = '1309'
修改后查询到的记录是：


大家可以对比上面的查询记录的图片，可以看到12月2日的这条记录没有了，而是12月3日的这条记录了，至此解决。

 
三、总结
所以，大家在使用sql函数的时候，一定要看看这个函数的API，这样才能将这个函数使用的融会贯通，比别人更加的掌握。

所以这里考大家一个问题，oracle怎么查询本周、上周的记录呢？



 ———————————————— 
版权声明：本文为CSDN博主「小小鱼儿小小林」的原创文章，遵循CC 4.0 by-sa版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/qq_27471405/article/details/84935791



到了周末了，查询本周(本周一至周日)数据竟然出错！！！

原因中外周末起始时间不一样，国外周日算第一天

select * from table_name where YEARWEEK(date_format(work_time,'%Y-%m-%d') - INTERVAL 1 DAY) = YEARWEEK(now() - INTERVAL 1 DAY)

国外周日算第一天，相当于早了一天，到周日时计算到下一周了，减去1天计算本周。