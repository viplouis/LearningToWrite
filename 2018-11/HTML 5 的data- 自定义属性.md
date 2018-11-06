HTML 5 增加了一项新功能是 自定义数据属性 ，也就是  data-* 自定义属性。在HTML5中我们可以使用以 data- 为前缀来设置我们需要的自定义属性，来进行一些数据的存放。当然高级浏览器下可通过脚本进行定义和数据存取。在项目实践中非常有用。

<div id="user" data-uid="12345" data-uname="愚人码头"> </div>

使用attribute方法存取 data-* 自定义属性的值
使用attributes方法存取 data-* 自定义属性的值非常方便：

javascript 代码:
// 使用getAttribute获取 data- 属性
var user = document . getElementById ( 'user' ) ;
var userName = plant . getAttribute ( 'data-uname' ) ; // userName = '愚人码头'
var userId = plant . getAttribute ( 'data-uid' ) ; // userId = '12345'
 
// 使用setAttribute设置 data- 属性
user . setAttribute ( 'data-site' , 'http://www.css88.com' ) ;
此方法能在所有的现代浏览器中正常工作，但它不是HTML 5 的自定义 data-*属性被使用目的，不然和我们以前使用的自定义属性就没有什么区别了，例如：

html 代码:
<div id = "user" uid = "12345" uname = "愚人码头" > </div>
<script>
// 使用getAttribute获取 data- 属性
var user = document . getElementById ( 'user' ) ;
var userName = plant . getAttribute ( 'uname' ) ; // userName = '愚人码头'
var userId = plant . getAttribute ( 'uid' ) ; // userId = '12345'
 
// 使用setAttribute设置 data- 属性
user . setAttribute ( 'site' , 'http://www.css88.com' ) ;
</script>
这种“原始”的自定义属性和上面 data-* 自定义属性没什么区别，知识属性名不一样。

dataset属性存取data-*自定义属性的值
这种方式通过访问一个元素的 dataset 属性来存取 data-* 自定义属性的值。这个 dataset 属性是HTML5 JavaScript API的一部分，用来返回一个所有选择元素 data- 属性的DOMStringMap对象。

使用这种方法时，不是使用完整的属性名，如 data-uid 来存取数据，应该去掉data- 前缀。

还有一点特别注意的是： data- 属性名如果包含了连字符，例如：data-date-of-birth ，连字符将被去掉，并转换为驼峰式的命名，前面的属性名转换后应该是： dateOfBirth 。

html 代码:
<div id="user" data-id="1234567890" data-name="愚人码头" data-date-of-birth>码头</div>
<script type="text/javascript">
var el = document.querySelector('#user');
console.log(el.id); // 'user'
console.log(el.dataset);//一个DOMStringMap
console.log(el.dataset.id); // '1234567890'
console.log(el.dataset.name); // '愚人码头'
console.log(el.dataset.dateOfBirth); // ''
el.dataset.dateOfBirth = '1985-01-05'; // 设置data-date-of-birth的值.
console.log('someDataAttr' in el.dataset);//false
el.dataset.someDataAttr = 'mydata';
console.log('someDataAttr' in el.dataset);//true
</script>
如果你想删掉一个 data-属性 ，可以这么做： delete el . dataset . id ;  或者 el .dataset . id = null ;  。

看起来很美，哈哈，但是不幸的是，新的 dataset 属性只有在Chrome 8+ Firefox(Gecko) 6.0+ Internet Explorer 11+ Opera 11.10+ Safari 6+浏览器中实现，所以在此期间最好用的getAttribute和setAttribute来操作。

关于data-属性选择器
在实际开发时，您可能会发现它很有用，你可以根据自定义的 data- 属性选择相关的元素。例如使用querySelectorAll选择元素：

javascript 代码:
// 选择所有包含 'data-flowering' 属性的元素
document . querySelectorAll ( '[data-flowering]' ) ;
 
// 选择所有包含 'data-text-colour' 属性值为red的元素
document . querySelectorAll ( '[data-text-colour="red"]' ) ;
同样的我们也可以通过 data- 属性值对相应的元素设置CSS样式，例如下面这个例子：

html 代码:
<style type ="text/css">
    .user {
         width : 256px ;
         height : 200px ;
     }
 
     .user[data-name='feiwen'] {
         color : brown
     }
 
     .user[data-name='css'] {
         color : red
     }
</style>
<div class = "user" data-id = "123" data-name = "feiwen" > 1 </div>
<div class = "user" data-id = "124" data-name = "css" > 码头 </div>