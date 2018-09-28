## 一、zookeeper入门
## 
## zookeeper概述：

Zookeeper是一个开源的分布式的额，为分布式应用提供协调服务的Apache项目。

Zookeeper从设计模式角度来理解：是一个基于观察者模式设计的分布式服务管理框架，它负责存储和管理大家都关心的数据，然后接受观察者的注册，
一旦这些数据的状态发生变化，Zookeeper就将负责通知已经在Zookeeper上注册的那些观察者做出相应的反应。

zookeeper = 文件系统 + 通知机制

## zookeeper特点：

1.zookeeper：一个领导者（Leader），多个跟随者（Followers）组成的集群。
2.集群中只要有半数以上的节点存活，zookeeper集群就能正常服务。
3.全局数据一致，每个Server保存一份相同的数据副本，Client无论连接到哪个Server，数据都是一致的。
4.更新请求顺序进行，来自同一个Client的更新请求按其发送顺序依次执行。
5.数据更新原子性，一次数据更新要么成功，要么失败。
6.实时性，在一定时间范围内，Client能读到最新数据。


## zookeeper数据结构

zookeeper数据模型的结构Unix文件系统很类似，整体上可以看作是一棵树，每个节点称做一个ZNode，每一个ZNode默认能够存储1MB
的数据，每个ZNode都可以通过其路径唯一标识。

## 应用场景

提供的服务包括：统一命名服务、统一配置管理、统一集群管理、服务器节点动态上下线、软负载均衡等。

### 统一命名服务
在分布式环境下，经常需要对应用/服务进行统一命名，便于识别。
例如：IP不容易记住，而域名容易记住。

### 统一配置管理
1.在分布式环境下，配置文件同步非常常见
	1）一般要求一个集群中，所有节点的配置信息是一致的，比如Kafka集群。
	2）对配置文件修改后，希望能够快速同步到各个节点上。
	
2.配置管理可交由zookeeper实现。
	1）可将配置信息写入Zookeeper上的一个ZNode。
	2）各个客户端服务端监听这个ZNode。
	3）一旦ZNode中的数据被修改，Zookeeper将通知各个客户端服务器。
### 统一集群管理
1.分布式环境下，实时掌握每个节点的状态是必要的。
	1）可根据节点实时状态做出一些调整。
2.Zookeeper可以实现实时监控节点状态变化
	1）可将节点信息写入Zookeeper上的一个ZNode。
	2）监听这个ZNode可获取它的实时状态变化。

### 服务器动态上下线
	客户端能实时洞察到服务器上下线的变化
	
	
### 软负载均衡
在Zookeeper中记录每台服务器的访问数，让访问数最少的服务器去处理最新的客户端请求。

## 下载地址

[官网下载] (https://zookeeper.apache.org/)

## 二、zookeeper安装使用
1.安装前准备
	1）安装JDK
	2）拷贝Zookeeper安装包到Linux系统下
	3）解压到指定目录
	[atguigu@hadoop102 software]$ tar -zxvf zookeeper-3.4.10.tar.gz -C /opt/module/
2.配置修改
 1）将/opt/module/zookeeper-3.4.10/conf这个路径下的zoo_sample.cfg修改为zoo.cfg:
	[atguigu@hadoop102 conf]$ mv zoo_sample.cfg zoo.cfg
 2）打开zoo.cfg文件，修改dataDir路径：
 [atguigu@hadoop102 zookeeper-3.4.10]$ vim zoo.cfg
	修改如下内容
	dataDir=/opt/module/zookeeper-3.4.10/zkData
	3）在/opt/module/zookeeper-3.4.10这个目录上创建zkData文件夹
	[atguigu@haddop102 zookeeper-3.4.10]$ mkdir zkData
3.操作Zookeeper
 1）启动Zookeeper
 [atguigu@haddop102 zookeeper-3.4.10]$ bin/zkServer.sh start
 2）查看进程是否启动
 [atguigu@hadoop102 zookeeper-3.4.10]$ jps
 1020 Jps
 4001 QuorumPeerMain
 3）查看状态：
 [atguigu@hadoop102 zookeeper-3.4.10]$ bin/zkServer.sh status
 ZooKeeper JMX enabled by default
 Using    config:     /opt/module/zookeeper-3.4.10/bin../conf/zoo.cfg
 Mode:standalone
 4）启动客户端：
 [atguigu@hadoop102 zookeeper-3.4.10]$ bin/zkCli.sh
 5）退出客户端
 [zk: localhost:2081(CONNECTED) 0] quit
 6）停止Zookeeper
 [atguigu@hadoop102 zookeeper-3.4.10]$ bin/zkServer.sh stop
 
## 2.2 配置文件解读
	zookeeper中的配置文件zoo.cfg中参数含义解读如下：
	1）tickTime = 2000 ;通信心跳数，Zookeeper服务器与客户端心跳时间，单位毫秒。
		Zookeeper使用的基本时间，服务器之间或客户端与服务器之间维持心跳的时间间隔，也就是每个tickTime时间
	就会发送一个心跳，时间单位为毫秒。
	它用于心跳机制，并且设置最小的session超时时间为两倍心跳时间。(session的最小超时时间是2*tickTime)
	2）initLimit = 10 ;LF初始通信时限
		集群中的Follower跟随着服务器与Leader领导者服务器之间初始连接时能容忍的最多心跳数（tickTime的数量），
	用它来限定集群中的Zookeeper服务器连接到Leader的时限。
	3）syncLimit = 5 ；LF同步通信时限
		集群中Leader与Follower之间的最大相应时间单位，加入响应超过syncLimit*tickTime,Leader认为Follwer死掉，
		从服务器列表中删除Follwer。
	4）dataDir: 数据文件目录+数据持久化路径
		主要用于保存Zookeeper中的数据。
	5）clientPort = 2181 ;客户端连接端口
		监听客户端连接的端口

 
## 三、Zookeeper的内部原理

### 3.1 选举机制（面试重点）
	1.半数机制：集群中半数以上机器存活，集群可用。所以Zookeeper适合安装在奇数台服务器。
	2.Zookeeper虽然在配置文件中并没有指定Master和Slave。但是Zookeeper工作时，是有一个节点为Leader，其它则为Follower，
Leader是通过内部的选举机制临时产生的。
	3.以一个简单的例子来说明整个选举的过程。
	假设有五台服务器组成的Zookeeper集群，他们的id从1-5，同时他们都是最新启动的，也急速hi没有历史数据，在存放数据量这一点上，
都是一样的。假设这些服务器依序启动，来看看会发生什么。图略
	1）服务器1启动，此时只有它一台服务器启动了，它发出去的报文没有任何响应，所以它的选举状态一直是LOOKING状态。
	2）服务器2启动，它与最开始启动的服务器1进行通信，互相交换自己的选举结果，由于两者都没有历史数据，所以id值较大的服务器2胜出，
	但是由于没有达到超过半数以上，依然没有Leader。
	3）服务器3启动，服务器3成为Leader，服务器4与服务器5启动，已经有了Leader。
	
### 3.2 节点类型
	持久（Persistent）：客户端和服务器断开连接后，创建的节点不删除
	短暂（Ephemeral）：客户端和服务器断开连接后，创建的节点自己删除
	
	1.持久化目录节点
		客户端与Zookeeper断开连接后，该节点依旧存在
	2.持久化顺序编号目录节点
		客户端与Zookeeper断开连接后，该节点依旧存在，只是Zookeeper给该节点名称进行顺序编号
	3.临时目录节点
		客户端与Zookeeper断开连接后，该节点即被删除
	4.临时顺序编号目录节点
		客户端与Zookeeper断开连接后，该节点被删除，只是Zookeeper给该节点名称顺序编号。
		
		说明：创建ZNode时设置顺序标识，ZNode名称后会附加一个值，顺序号是一个单调递增的计数器，由父节点维护
	注意：在分布式系统中，顺序号可以被用于为所有的事件进行全局排序，这样客户端可以通过顺序号推断事件的顺序。	
	
### 3.3 Stat结构体


### 3.4 监听器原理（面试重点）


### 3.5 写数据流程



## 四、Zookeeper实战（开发重点）
 
 ## 4.1 分布式安装部署
	1.集群规划
		在hadoop102、hadoop103和hadoop三个节点上部署Zookeeper
 
	2.解压安装
		1）解压Zookeeper安装包到/opt/module/目录下
			[atguigu@hadoop102 software]$ tar -zxvf zookeeper-3.4.10.tar.gz -C /opt/module/
		2）同步/opt/module/zookper-3.4.10 目录内容到hadoop103、hodoop104
			[atguigu@hadoop102 module]$ xsync zookeeper-3.4.10/
	3.配置服务器编号
		1）在/opt/module/zookeeper-3.4.10/这个目录下创建zkData
		2）在/opt/module/zookeeper-3.4.10/zkData目录下创建一个myid的文件
			[atguigu@hadoop102 zkData]$ touch myid
				添加myid文件，注意一定要在linux里面创建，在nodepad++里面很可能乱码。
		3）编辑myid文件
			[atguigu@hadoop102 zkData]$ vi myid
			在文件中添加与server对应的编号：
		4）拷贝配置好的Zookeeper到其它机器上
			[atguigu@hadoop102 zkData]$ xsync myid
			并分别在hadoop102、hadoop103上修改myid文件中为3、4
	4.配置zoo.cfg文件
		1）重命名/opt/module/zookeeper-3.4.10/conf这个目录下的zoo_sample.cfg
			[atguigu@hadoop102 conf]$ mv zoo_sample.cfg zoo.cfg
		2）打开zoo.cfg文件
			[atguigu@hadoop102 conf]$ vim zoo.cfg
			修改数据库存储路径配置
			dataDir=/opt/module/zookeeper-3.4.10/zkData
			增加如下配置
			#####################################cluster###########################
			server.2=hadoop102:2888:3888
			server.3=hadoop103:2888:3888
			server.4=hadoop104:2888:3888
		3）同步zoo.cfg配置文件
		[atguigu@hadoop102 conf]$ xsync zoo.cfg
		4）配置参数解读
			server.A=B:C:D
			A 是一个数字，表示这个是第几号服务器：
			集群模式下配置一个文件myid,这个文件在dataDir目录下，这个文件里面有一个数据就是A的值，
		Zookeeper启动时读取此文件，拿到里面的数据与zoo.cfg里面的配置信息比较从而判断到底是哪个server.
			B 是这个服务器的ip地址：
			C 是这个服务器与集群中的Leader服务器交换信息的端口;
			D 是万一集群中的Leader服务器挂了，需要一个端口来重新进行选举，选取一个新的Leader，而这个端口
		就是用来执行选举时服务器相互通信的端口。
			
	5.集群操作
			1）分别启动Zookeeper
			[atguigu@hadoop102 zookeeper-3.4.10]$ bin/zkServer.sh start
			
	
	
 
 ## 4.2 客户端命令操作
 
 
 
 ## 4.3 API应用
   ### 4.3.1 Eclipse环境搭建

   ### 4.3.2创建Zookeeper客户端

   ### 4.3.3创建字节点

   ### 4.3.4获取子节点并监听上数据

   ### 判断ZNode是否存在
 
 ## 

