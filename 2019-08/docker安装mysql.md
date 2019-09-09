【Docker】Docker安装Mysql5.7
 docker  278 次阅读  ·  读完需要 8 分钟
1 拉取mysql镜像，采用网易加速地址
docker pull hub.c.163.com/library/mysql:5.7
2 重命名镜像名
docker tag hub.c.163.com/library/mysql:5.7 mysql:5.7
3 创建容器且安装镜像.启动。
docker run --name mysql-main -p3306:3306 -e MYSQL_ROOT_PASSWORD=123456 -d mysql:5.7
-name:容器名称mysql-main
-p：将端口号映射到主机
最后设置密码123456
4 通过命令进入mysql-main容器
docker exec -it mysql-main bash
5 然后进入MySQL。并设置远程的授权等信息。
 mysql -uroot -p
 
 grant all privileges on *.* to root@"%" identified by "123456" with grant option; 
 
 ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY '123456';
  
 flush privileges;
  
6 取消Mysql查询大小写的问题。
进入docker的MySQL容器，编辑/etc/mysql/mysql.conf.d/mysqld.cnf文件，在[mysqld]下添加如下：
[mysqld] 
lower_case_table_names=1
保存，退出容器；执行sudo docker restart MySQL ，重启MySQL即可查看。
7 解决Mysql5.7的查询兼容问题。此设置重启失效。
如：Expression #1 of SELECT list is not in GROUP BY clause and contains nonaggregated column
MySQL 5.7.5和up实现了对功能依赖的检测。如果启用了only_full_group_by SQL模式(在默认情况下是这样)，那么MySQL就会拒绝选择列表、条件或顺序列表引用的查询，这些查询将引用组中未命名的非聚合列，而不是在功能上依赖于它们。(在5.7.5之前，MySQL没有检测到功能依赖项，only_full_group_by在默认情况下是不启用的。

解决方案1：

set global sql_mode='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';

set session sql_mode='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';


解决方案2（写配置文件，重启不失效。去除NO_ZERO_IN_DATE,NO_ZERO_DATE，解决时间戳的问题）：

进入docker的MySQL容器，编辑/etc/mysql/mysql.conf.d/mysqld.cnf文件，在[mysqld]下添加如下：

sql-mode='STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION'

8 解决Mysql5.7的密码修改不兼容问题。
Mysql5.7更改密码，以前的方式会报错。代码如下：

update mysql.user  set password=password('root') where user='root'

提示ERROR 1054 (42S22): Unknown column 'password' in 'field list'

最新的更改密码代码是：

update mysql.user set authentication_string=password('root') where user='root' 
备注：
启动docker中 MySQL的时候可以加参数。含义是：
--restart=always 跟随docker启动
--privileged=true 容器root用户享有主机root用户权限
-v 映射主机路径到容器
-e MYSQL_ROOT_PASSWORD=root 设置root用户密码
-d 后台启动
--lower_case_table_names=1 设置表名参数名等忽略大小写
--------------------- 