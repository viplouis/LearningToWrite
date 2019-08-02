最近在做事务添加时  发现自己的事务没有新建，上网查到   仅用作收藏。

其二  注意  事务的注解  应该在 内层的事务上面

一、描述
Spring遇到嵌套事务时，当被嵌套的事务被定义为“PROPAGATION_REQUIRES_NEW”时，
内层Service的方法被调用时，外层方法的事务被挂起；
内层事务相对于外层事务是完全独立的，有独立的隔离性等等。

二、实验
但实验时却遇到一个奇怪的问题：
1、当ServiceA.a()方法调用ServiceB.b()方法时，内层事务提交和回滚，都不受外层事务提交或回滚的影响。
2、当ServiceA.a()方法调用ServiceA.c()方法时，内层事务不能正确地提交或回滚。

三、演示代码
XXXService中，有下面两个方法：
@Transactional 
method_One() {
    method_Two();
}

@Transactional(propagation = Propagation.REQUIRES_NEW) 
method_Two(){
    //do something
}

四、分析和结论
1、method_Two()会不会创建一个新事务？ 
答：不会创建。仔细查看了日志，没有找到类似creating new transaction的输出，应该是因为在同一个Service类中，spring并不重新创建新事务，如果是两不同的Service，就会创建新事务了。 
那么为什么spring只对跨Service的方法才生效？ 
Debug代码发现跨Service调用方法时，都会经过org.springframework.aop.framework.CglibAopProxy.DynamicAdvisedInterceptor.intercept()方法，只有经过此处，才能对事务进行控制。 

2、不同的Service调用方法时：
如果被调用方法是Propagation.REQUIRES_NEW，被catch后不抛出，事务可以正常提交； 
如果被调用方法是Propagation.REQUIRED，被catch后不抛出，后面的代码虽然可以执行下去，但最终还是会分出rollback-only异常；

3、同一个Service中调用方法时：
不论注解是Propagation.REQUIRES_NEW 还是 Propagation.REQUIRED，
其结果都是一样的，就是都被忽略掉了，等于没写。
当其抛出异常时，只需catch住不抛出，事务就可以正常提交。