package com.example.classloader.loader;

/**
 * @Author zhangbaiquan
 * @Email zbaiquan@163.com
 * @Description
 * @Date 2019/8/21 14:53
 * @Version 1.0
 **/
public class ExaminationDemo {
    public static void main(String[] args) {
        System.out.println("1运行 ExaminationDemo 中的 main 函数， 创建 D 类实例");
        new D();
    }

}
