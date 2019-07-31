1.数据源连接 ：spring.datasource.url=jdbc:mysql://127.0.0.1:3306/store_test?useUnicode=true&characterEncoding=utf8&useSSL=false&serverTimezone=UTC&rewriteBatchedStatements=true
（要加入时区）

2.修改maven jdbc版本
<mysql.connector.java.version>8.0.12</mysql.connector.java.version>

3.StringUtils包路径由 import com.mysql.jdbc.StringUtils; 改为 import com.mysql.cj.util.StringUtils;

4.This function has none of DETERMINISTIC, NO SQL, or READS SQL DATA in its de 错误解决办法
这是我们开启了bin-log, 我们就必须指定我们的函数是否是
(1).DETERMINISTIC 不确定的
(2). NO SQL 没有SQl语句，当然也不会修改数据
(3). READS SQL DATA 只是读取数据，当然也不会修改数据
(4). MODIFIES SQL DATA 要修改数据
(5). CONTAINS SQL 包含了SQL语句

其中在function里面，只有 DETERMINISTIC, NO SQL 和 READS SQL DATA 被支持。如果我们开启了 bin-log, 我们就必须为我们的function指定一个参数。

在MySQL中创建函数时出现这种错误的解决方法：
set global log_bin_trust_function_creators=TRUE;