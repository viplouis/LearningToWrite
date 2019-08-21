package com.example.classloader.loader;

/**
 * @Author zhangbaiquan
 * @Email zbaiquan@163.com
 * @Description
 * @Date 2019/8/21 14:55
 * @Version 1.0
 **/
public class D extends C {
    // D的普通成员变量
    public String sd1 = getSd1();
    // D的静态成员变量
    public static String sd = getSd();
    // D的静态代码块
    static {
        System.out.println("7执行 D 的 static 块(D 继承 C)");
    }
    // D的匿名代码块
    {
        System.out.println("16执行 D 实例的普通初始化块");
    }
    // D的构造器
    D() {
        System.out.println("17执行 D 的构造函数(D 继承 C);父类 B 的实 例成员变量 sb 的值为：" + sb + ";本类 D 的 static 成员变量 sd 的值为：" + sd
                + "; 本类 D 的实例成员变量 sd1 的值是：" + sd1);
    }
    // D的静态成员方法（调用时才加载）
    static public String getSd() {
        System.out.println("6初始化 D 的 static 成员变量 sd");
        return "sd";
    }
    // D的普通成员方法
    public String getSd1() {
        System.out.println("15初始化 D 的实例成员变量 sd1");
        return "sd1";
    }

}
