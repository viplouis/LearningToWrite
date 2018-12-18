Collection中带有All的方法： 

Collection list1 = new ArrayList();

Collection list2 = new ArrayList(); 

1. addAll（）：list1.addAll( list2 );  这句话的意思是：将list2集合中的所有的元素都一个个的添加进list1中。这样改变了list1的元素组成，但是没有改变list2的元素组成。

2. removeAll（）： list1.remove(list2) ;  这句话的意思是：list1集合与list2集合 先  找到 交集，然后 在 list1中删除 交集 ，然后将删除交集后的list1重新赋给list1，list2中的元素不变，然后打印list1，这样就会输出 删除交集后的 list1 。 removeAll删除的是 两个集合的交集 。 

3. containsAll（）: boolean flag = list1.containAlls(list2) ;  查看 list1中是否包含所有的list2中的元素，如果 list1 集合中 包含所有 的 list2集合中所有的元素，那么就返回 true ，否则返回 false 。

4. retainAll（）:  boolean flag = list1.retainAll(list2) ;  list1 和 list2 两个集合 先取 交集 。 然后 将交集 赋给 list1 ， 如果 list1集合元素组成发生了变化，那么就返回 true ， 否则返回 false 。特殊情况： list1 和 list2 两个集合 完全相同，所以 list1 和list2 的交集 就是他们 本身， 把交集 赋给 list1时 ，list1 没有发生任何的变化，所以返回 false 。综上所述：retainAll（）中 只要list1发生变化，就返回 true，不发生变化就返回false 。

示例代码如下:

import java.util.ArrayList;

import java.util.Collection;


public class Main {


@SuppressWarnings("unchecked")
public static void main(String[] args) {
/*
@SuppressWarnings("rawtypes")
Collection c1 = new ArrayList() ;
c1.add("a");
c1.add("b");
c1.add("c");
c1.add("d");
@SuppressWarnings("rawtypes")
Collection c2 = new ArrayList() ; 
c2.add("e");
c2.add("f");
boolean flag1 = c1.addAll(c2);
System.out.println(flag1); //true。 
System.out.println(c1); // 输出结果为：[a,b,c,d,e,f]
//addAll()将c2中的所有的元素都一个个的添加进了c1中。
System.out.println(c2);//输出结果为：[e,f]。
//addAll的原理是： 将 c2的元素添加进c1中，然后改变c1中的元素组成，但是不改变c2的元素组成。

*/
Collection c1 = new ArrayList() ;
c1.add("a");
c1.add("b");
c1.add("c");
c1.add("d");
@SuppressWarnings("rawtypes")
Collection c2 = new ArrayList() ; 
c2.add("e");
c2.add("f");

c1.add(c2);
System.out.println(c1);//输出结果为： [a, b, c, d, [e, f]]
//addAll() 与 add() 之间的区别： 
/*
* addAll()：是将c2中的元素一个个加入到c1中，改变c1的组成。 
* add（）：是将c2看作一个整体，然后将c2整体添加到c1中，然后改变c1的组成。
* */



  Collection c3 = new ArrayList() ; 
  c3.add("a"); 
  c3.add("b"); 
  c3.add("c"); 
  c3.add("d");
  Collection c4 = new ArrayList() ; 
  c4.add("a"); 
  c4.add("b"); 
  boolean flag2 = c3.removeAll(c4); 
  System.out.println(flag2);//结果：true
  System.out.println(c3); //[c,d]  
  System.out.println(c4); //[a,b]
  //由上面可知： removeAll()的作用原理：先找到 c3 和 c4 的交集，然后在c3中删除交集，c4里面的元素保持不变。
  //删除的是交集。 
  Collection c6 = new ArrayList() ; 
  c6.add("a");
  c6.add("b");
  c6.add("c"); 
  c6.add("d");
  Collection c7 = new ArrayList() ; 
  c6.add("a");
  c6.add("b");
  boolean flag3 = c6.containsAll(c7) ; //判断c6中是否包含了c7（包含了：c7的所有的元素 ，c6 都必须拥有）。 
  System.out.println(flag3); //结果 : true。
  System.out.println(c6); //[a, b, c, d, a, b] 其实也改变了 c6调用者的组成。但是这个方法不用想太多。
 /*
  Collection c8 = new ArrayList() ; 
  c8.add("a");
  c8.add("b");
  c8.add("z"); 
  boolean flag4 = c6.containsAll(c8); 
  System.out.println(flag4);//结果为： false 。 因为c6中不包括 “z” 这个元素。
  System.out.println(c6);
  */
  Collection c9 = new ArrayList(); 
  c9.add("a");
  c9.add("b");
  c9.add("c");
  c9.add("d");
  Collection c10 = new ArrayList();
  c10.add("c");
  c10.add("a");
  c10.add("z");
  boolean flag5 = c9.retainAll(c10);
  System.out.println(flag5);//true
  System.out.println(c9);//[a,c]。 之前的c9集合 元素组成是： [a,b,c,d]
  //retainAll() ：c9和c10取交集，然后将交集赋给c9。这时候c9 被改变了。

 

 //没有交集，但是改变了调用者集合（c11）的元素组成，所以返回true。 

          Collection c11 = new ArrayList(); 
  c11.add("a");
  c11.add("b");
  c11.add("c");
  c11.add("d");
  Collection c12 = new ArrayList();
  c12.add("z");
  boolean flag6 = c11.retainAll(c12);//保留交集
  System.out.println(flag6);//true
  System.out.println(c11);//[ ]。没有交集，但是还是返回 true 。

  
  //出现的问题有：有交集返回true，没有交集返回ture。
  //什么情况下返回true，什么情况下返回false？
  //改变 调用者元素组成 返回 true，不改变 调用者的 元素组成 就 返回false 。
  
  //false 的情况： 
  Collection c13 = new ArrayList(); 
  c13.add("a");
  c13.add("b");
  c13.add("c");
  c13.add("d");
  Collection c14 = new ArrayList();
  c14.add("a");
  c14.add("b");
  c14.add("c");
  c14.add("d");
  boolean flag7 = c13.retainAll(c14);
  System.out.println(flag7); // 结果为： false  ；
  System.out.println(c13); // 交集为： [a,b,c,d] ；  
  //没有改变 调用者 c13的 元素组成。
  
  //综上所述： retainAll（） ： 改变 调用者的集合（元素组成） 就返回true，否则是返回false。不管有没有交集。

  //重点：只要改变调用者集合的元素组成，不管有没有交集，都返回true，否则返回false 。

}


}
