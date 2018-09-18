为了解决高并发、高可用 有了分库分表的解决方案

了解到：Mycat数据库分库分表中间件

分库：减少并发问题
分表：其实降低了分布式事务 QPS100：50  TPS 200 100

分表2种方式：
1.垂直拆分，
	方式：把一个表的不同属性的字段拆分到不同的表中	
	目的：降低单（库）表大小来提供性能
	特点：（1）.每个库（表）的结构都不一样 （2）.每个库（表）的数据都一样（至少是一列）（3）每个库（表）的并集是全量数据

	垂直拆分问题：
	1.部分业务表无法join,只能通过接口方式，提高了系统复杂度
	2.存在单表性能瓶颈，不易扩展
	3.事务处理复杂
2.水平拆分
	方式：以某个字段按照一定的规则将一个表的数据分到多个表中
	比如依以下方式以id取模，id结尾去分别存到不同的表中
	（id=001 user1;id=002 user2; id=003 user3）

	水平拆分问题：
	1.拆分规则难以抽象
	2.分片事务一致性难以解决
	3.维护难度极大
	4.跨库join性能差

3.垂直水平拆分


分库策略：
	Hash取模，通过表的一个字段进行散列
	Range范围区分2016 2017 2018 北京 a 上海 b 
	List 预定义（之前分布式id mysql 预定100库）步长来区分

创建了1，2，3，4四个分库

配置分表路由
application-context.xml
<bean id = "hashFunction" class="com.t1.router.hashFunction"></bean>
<bean id="internalRouter" class="com.caland.sun.client.router.config.InteralRouterXmlFactoryBean">
<!-- functionMap是在使用自定义路由规则函数的时候使用-->
	<property name="functionMap">
		<map>
		<entry key="hash" value-ref="hashFunction"><entry>
		</map>
	</property>
	<property name="configLocations">
		<list>
		<value>classpath:/rule/t1-sharding-rules.xml</value>
		</list>
	</property>
</bean>

//实现路由规则
HashFactory.java  

public class HashFunction{
	public int user(String username){
	int result = Math.abs(username.hashCode()%1024);
	if(0<result && result<255){
	return 1;
	}
	if(256<result && result<511){
	return 2;
	}
	if(512<result && result<767){
	return 3;
	}
	if(768<result && result<1023){
	return 4;
	}
	return result;
	}
}

假如没有了库2，如何实现高可用

分库分表之后的问题：
1.多数据管理
2.分布式跨库、join、事务
3.改写SQL
4.分布式全局id AUTO_INCREMENT 显然不行
内存计算（ES spark）

话费充值系统，采用了水平拆分，异构
电商：userid

userid = 001  ==>tl01库
userid = 002  ==>tl02库

查看我的订单
SELECT xxx FROM ORDER WHERE userid = "xxx";
后台：查看今天的所有订单


分库分表解决方案：
1.能不拆分尽量不拆分
2.如果要拆分一定要选择合适的拆分规则，提前规划好
3.数据拆分尽量通过数据冗余或表分组来降低跨库join的可能
4.跨库join是共同难题，所以业务读取尽量使用多表join

解决方案：
1.Proxy   - mycat proxy
	社区 Mycat -cobar *  阿里 ：Cobar（Proxy形式）TDDL 已停更
	数字：Atlas              金山：kingshard
	百度：heinsberge	商业版：Oneproxy
	Youtobe:vitess	当当：Sharding-jdbc *


2.Driver - jdbc做二次封装 mysql-driver自带了读写分离，分库分表 Connection set result


Sharding-jdbc 是当当网从关系型数据库模块dd-rdb中分离出来的数据库水平分片框架。
Sharding-jdbc直接封装jdbc协议，可理解为增强版的JDBC驱动，使用客户端直接连数据库，以jar包形式提供服务，无proxy层。

Sharding-JDBC
特点：
1.适用于任何基于java的orm框架  mybatis jap hibernate minidao ...
2.可以支持任何第三方数据库连接池  dbcp、c3p0、druid
3.理论上支持任意实现jdbc的数据库
4.分片策略灵活，sql解析强大 for update join
5.性能高，单库查询QPS为原生jdbc的99.8%，双库QPS比单库增加94%。