left join 后 on/where 的区别:
on 不会对连接查询后的结果进行过滤，where 会对查询后的结果进行过滤

首先，在SQL中(以SQL Server为例)，查询存在一个表而不在另一个表中的数据记录的方法有很多，介绍其中4种：

1、方法一(仅适用单个字段)：使用 not in ,比较容易理解,缺点是效率低

如：select A.ID from A where A.ID not in (select ID from B)；

2、方法二（适用多个字段匹配）：使用 left join...on... , "B.ID isnull" 表示左连接之后在B.ID 字段为 null的记录。

如：select A.ID from A left join B on A.ID=B.ID where B.ID is null ；

3、方法三（适用多个字段匹配）

如：select * from B where (select count(1) as num from A where A.ID = B.ID) = 0；

4、方法四（适用多个字段匹配）

如：select * from A where not exists(select 1 from B where A.ID=B.ID)
接着，我们来分析你的SQL语句为什么返回数据不准确的原因。

从你的SQL基础语句来看，你使用了方法一和方法四这两种，两种语法本身都是正确的，但是却没有达到预期的效果，初步分析，问题可能出在gsdj和swdj这两张表的qymc字段的判断比较上。

举个例子：'企业名称'和'企业名称  '这两个字符串看似相同，实际却并不相同，因为第二个“企业名称 ”的后面跟了一个空格字符。就因为这个空格字符导致这个"'企业名称'='企业名称 '"等式不成立。

考虑到你qymc这个字段的类型是字符型，建议你在原有sql基础上做一个微调如下：

select * from gsdj  gs where not exists (select * from swdj sw where rtrim(ltrim(sw.qymc )) )=rtrim(ltrim(gs.qymc )))；

其中Ltrim()可以去除左侧空格，rtrim()可以去除右侧的空格，也就是说我们是对去除空格后的企业名称进行比较，排除了空格的干扰。


扩展资料：

在SQL中，对于字符型文本数据，经常需要用到去空格的操作，对ORACLE数据来说可以通过TRIM（）函数来简单实现，而SQL SERVER中并没有TRIM（）函数，只有LTRIM（）和RTRIM（）两个函数。

SQL 中使用ltrim()去除左边空格 ，rtrim()去除右边空格 ，没有同时去除左右空格的函数，要去除所有空格可以用replace(字符串,' ','')，将字符串里的空格替换为空。 

例：去除空格函数

declare @temp char(50)

set @temp = ' hello sql '

print ltrim(@temp)     --去除左边空格 

print rtrim(@temp)     --去除右边空格 

print replace(@temp,' ','') --去除字符串里所有空格 

print @temp

>> 输出结果 hello sql 

hello sql

hellosql

hello sql