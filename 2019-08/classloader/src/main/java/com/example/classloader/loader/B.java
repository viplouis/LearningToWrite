package com.example.classloader.loader;

/**
 * @Author zhangbaiquan
 * @Email zbaiquan@163.com
 * @Description
 * @Date 2019/8/21 14:54
 * @Version 1.0
 **/
public class B {
    //new了一个E对象
    E e = new E();

    //B的静态成员变量
    static F f = new F();
    //B的普通成员变量
    public String sb = getSb();
    //B的静态代码块
    static {
        System.out.println("3执行 B 类的 static 块(B 包含 E 类的成员 变量,包含静态 F 类成员变量)");
        f.funcOfF();
    }
    //B的匿名代码块
    {
        System.out.println("10执行 B 实例的普通初始化块");
    }
    //B的构造器
    B() {
        System.out.println("11执行 B 类的构造函数(B 包含 E 类的成员变 量,包含静态 F 类成员变量)");
    }
    //B的普通成员方法
    public String getSb() {
        System.out.println("9初始化 B 的实例成员变量 sb");
        return "sb";
    }

}
