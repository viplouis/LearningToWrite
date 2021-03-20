#!/bin/bash
# 这里可替换为jar包名字
APP_NAME=halo-1.4.5.jar
# 使用说明,用来提示输入参数
usage() {
    # echo "Usage: sh 执行脚本.sh [start|stop|restart|status|log|backup]"
	echo "===============一卡通面板命令行=================="
	echo "(start) 启动服务           	(restart) 重启服务"
	echo "(stop) 停止服务           	(status) 服务状态"
	echo "(0) 取消"
	echo "================================================="
    exit 1
}
# 检查程序是否在运行
is_exist() {
    pid=`ps -ef|grep $APP_NAME|grep -v grep|awk '{print $2}' ` 
    # 如果不存在返回1,存在返回0
    if [ -z "${pid}" ]; then
        return 1
    else
        return 0
    fi
}

#启动方法
start() {
    is_exist
    if [ $? -eq "0" ]; then
        echo "${APP_NAME} is already running. pid=${pid} ."
    else
        # 后台启动jar包，且控制环境变量，根据实际情况修改吧。
		# nohup java -Dspring.profiles.active=prod -jar $APPFILE_PATH $APP_NAME >/dev/null 2>error.log &
		# 如果错误信息也不想要的话
		nohup java -jar $APPFILE_PATH $APP_NAME >/dev/null 2>&1 &
        # nohup java -Dspring.profiles.active=prod -jar $APP_NAME > $APP_NAME.log 2>&1 &
    fi
}

# 停止方法
stop() {
    is_exist
    if [ $? -eq "0" ]; then
        kill -9 $pid
    else
        echo "${APP_NAME} is not running"
    fi
}

# 输出运行状态
status() {
    is_exist
    if [ $? -eq "0" ]; then
        echo "${APP_NAME} is running. Pid is ${pid}"
    else
        echo "${APP_NAME} is NOT running."
    fi
}
# 重启
restart() {
    stop
    start
}

# 日志
log() {
        # 输出实时日志
    tail -n 100 -f /usr/test/hefen/logs/RobotDataService.log
}


# 根据输入参数,选择执行对应方法,不输入则执行使用说明
case "$1" in
    "start")
        start
        ;;
    "stop")
        stop
        ;;
    "status")
        status
        ;;
    "restart")
        restart
        ;;
    "log")
        log
        ;;
    *)
usage
;;
esac



# nohup ./program >/dev/null 2>log &
# 如果错误信息也不想要的话：
# nohup ./program >/dev/null 2>&1 &
