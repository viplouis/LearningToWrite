package com.example.classloader.loader;

/**
 * @Author zhangbaiquan
 * @Email zbaiquan@163.com
 * @Description
 * @Date 2019/8/21 14:54
 * @Version 1.0
 **/
public class C extends B {
    // C的静态代码块
    static {
        System.out.println("5执行 C 的 static 块(C 继承 B)");
    }
    // C的匿名代码块
    {
        System.out.println("13执行 C 的普通初始化块");
    }

    // C的构造器
    C() {
        System.out.println("14执行 C 的构造函数(C 继承 B)");
    }

}
