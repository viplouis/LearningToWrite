List、Set中都有方法
addAll(Collection c) :
    对于set来说，是将c中所有元素添加到一个Set中，如果Set中已有某一元素，则不添加，因Set不允许有重复值
    对于List来说，是将c中元素append到一个List中
     //Appends all of the elements in the specified collection to the end of this list

retainAll(Collection c)
    两个集合求交集，只保留交集数据 
     //Retains(保留) only the elements in this list that are contained in the specified collection

 

Java代码  
		String[] ss = {"s1","s2","1"};  
        List str = Arrays.asList(ss);  
          
        List stList = new ArrayList();  
        stList.add("1");  
        stList.add("2");  
        stList.add("3");  
        stList.addAll(str);  
        System.out.println(stList);  
		
        //结果：[1, 2, 3, s1, s2, 1] 因List中允许重复值  
          
        Set s = new HashSet();  
        s.add("1");  
        //s.add(1);  
        s.add("2");  
        s.add("3");  
        s.addAll(str);
        System.out.println(s);  
		
        //结果：[3, 2, s2, 1, s1] 因Set中不允许重复值  
        //若为s.add(1) ,数组ss不变，则结果为：[3, 2, 1, 1, s2, s1] 因其中两个1类型不同  
 
Java代码  
		List lt1 = new ArrayList();  
        lt1.add("a");  
        lt1.add("b");  
        lt1.add("c");  
        List lt2 = new ArrayList();  
        lt2.add("b");  
        lt2.add("d");  
        lt2.add("f");  
          
        List lt3 = new ArrayList();  
        lt3.addAll(lt1);  
        lt3.retainAll(lt2);  
        System.out.println(lt3);  
		
        //结果：[b]  