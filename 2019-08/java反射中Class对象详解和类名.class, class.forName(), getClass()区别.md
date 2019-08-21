java反射中Class对象详解和类名.class, class.forName(), getClass()区别
1.获得类型类
可以看到，对象a是A的一个实例，A是某一个类，在if语句中使用a.getClass()返回的结果正是类A的类型类，在Java中表示一个特定类型的类型类可以用“类型.class”的方式获得，因为a.getClass()获得是A的类型类，也就是A.class，因此上面的代码执行的结果就是打印出“equal”。特别注意的是，类型类是一一对应的，父类的类型类和子类的类型类是不同的，因此，假设A是B的子类，那么如下的代码将得到“unequal”的输出：
因此，如果你知道一个实例，那么你可以通过实例的“getClass()”方法获得该对象的类型类，如果你知道一个类型，那么你可以使用“.class”的方法获得该类型的类型类。
2.获得类型的信息
在获得类型类之后，你就可以调用其中的一些方法获得类型的信息了，主要的方法有：
getName():String：获得该类型的全称名称。
getSuperClass():Class：获得该类型的直接父类，如果该类型没有直接父类，那么返回null。
getInterfaces():Class[]：获得该类型实现的所有接口。
isArray():boolean：判断该类型是否是数组。
isEnum():boolean：判断该类型是否是枚举类型。
isInterface():boolean：判断该类型是否是接口。
isPrimitive():boolean：判断该类型是否是基本类型，即是否是int，boolean，double等等。
isAssignableFrom(Classcls):boolean：判断这个类型是否是类型cls的父（祖先）类或父（祖先）接口。
getComponentType():Class：如果该类型是一个数组，那么返回该数组的组件类型。
 
3.Class对象的生成方式如下：
01.类名.class
JVM将使用类装载器, 将类装入内存(前提是:类还没有装入内存),不做类的初始化工作.返回Class的对象
02.Class.forName("类名字符串")  （注：类名字符串是包名+类名）
装入类,并做类的静态初始化，返回Class的对象
03.实例对象.getClass()  
对类进行静态初始化、非静态初始化；返回引用运行时真正所指的对象(因为:子对象的引用可能会赋给父对象的引用变量中)所属的类的Class的对象