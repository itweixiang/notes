- MyBatis和Hibernate的适用场景?

  Mybatis比较关注SQL本身，是一个比较灵活、方便的半自动化持久层框架。Hibernate是一个强大、高效的全自动化持久层框架。

  Hibernate比较适合需求相对稳定的中小型项目，如办公自动化系统。Mybatis比较适合需求变更频繁的大象项目，如电子商务系统。

  

- Mybatis有哪些优缺点？

  优点有，减少了原生JDBC的代码量，不用手动的开关数据库连接。SQL与mapper接口分开，相对比较灵活，并且可以使用内嵌的标签生成动态SQL。与Spring的集成也非常简单。

  缺点有，比较关注SQL，对开发人员的SQL能力要求较高。SQL比较依赖于数据库，导致SQL的可以执行比较差，不能随意更换数据库。

  

- MyBatis的架构设计是怎么样的？

  MyBatis的功能架构有三层。

  API层，提供给外部使用的API，接收调用请求，并调用数据处理层完成数据的查询和处理。

  数据处理层，负责具体的SQL查找、SQL解析、SQL执行、执行结果映射等。

  基础支撑层，包括连接管理、事务管理、配置加载、和缓存处理等。

  

- MyBatis执行的过程是怎样的？

  - 读取Mybatis的配置文件，并封装成Configuration对象

  - 加载对应的SQL文件，并与Mapper接口进行关联

  - 构造SqlSessionFactory工厂对象，并创建Session对象
  - 使用session对象，获取mapper接口的代理对象，并执行方法。实际通过Executor执行SQL。
  - 根据参数映射，封装结果集

  

- 原生的JDBC编程有哪些不足之处，MyBatis是如何解决的？

  数据库连接复用性较差，频繁的创建和释放，会造成系统资源的浪费。Mybatis使用数据库连接池进行管理和复用。

  SQL写在代码中，不方便维护。Mybaits将SQL调用声明在Mapper接口中，将具体的SQL放在XML文件中。

  结果集需要手动遍历、解析、封装成对象。Mybatis则能根据配置自动进行解析和封装。

  

- Mybatis动态sql是做什么的？都有哪些动态sql？能简述一下动态sql的执行原理吗？

  Mybatis的动态SQL，可以以标签的方式编写动态SQL，完成逻辑判断和SQL拼接的功能。常用的标签有trim、where、foreach、choose、when、otherwise等。Mybatis通过OGNL从SQL参数对象中计算表达式中的值，根据表达式的值动态拼接SQL。

  

- Mybatis如何执行批量操作？

  一般使用foreach标签进行批处理操作，并且批处理需要在jdbc.url中添加allowMulitiQueries=true。在SessionFactory打开SqlSession时，指定ExecutorType为BATCH，性能会更高。

  

- mapper中如何传递多个参数？

  数字传参，以数字的顺序，代表入参的顺序，但是表达不够直观，参数调整时，容易出错。

  注解传参，使用@Param()注解，手动指定参数的名字，在SQL中可以直接引用。

  map传参，使用Map，key代表参数名，value代表值名。或者将参数封装成一个实体类，字段名为参数名。

  

- 模糊查询like语句该怎么写？

  直接拼接%号，或者使用bind标签（<bind name="name" value="'%'+name+'%'">）可能会引起SQL注入。

  一般需要使用CONCAT函数进行拼接，如concat("%",#{},"%")

  

- Mybatis是如何进行分页的？分页插件的原理是什么？

  可以在SQL中，传入limit的参数，自己完成分页。Mybatis本身的分页，需要将数据全部查出来，然后根据在接口中传入RowRounds对象，在Java堆内存中做截取分页，非常不优雅。分页插件的原理是拦截重写了SQL，加上了limit参数。

  

- Mybatis都有哪些Executor执行器？如何指定使用哪一种Executor执行器？

  SIMPLE，默认普通的执行器。 REUSE，重用预处理的语句。BATCH，批处理优化的执行器。

  在SessionFactory创建SqlSession时，指定ExecutorType。

  

- 接口的工作原理是什么？mapper接口里的方法，参数不同时，方法能重载吗？

  mapper接口的原理是Mybatis通过JDK动态代理，创建对应的对象，在实行方法时进行拦截，转而执行MappedStatement所代表的SQL。

  不能重载，因为以全限定名+方法名的方式保存和寻找。

  

- 什么是MyBatis的接口绑定？有哪些实现方式？

  就是把Java接口的方法与SQL语句绑定，比直接操作SqlSession提供的方法更灵活，更工程化。

  可以通过@Select、@Update注解，在接口上直接写SQL。也可以通过写xml文件，通过namespace关联接口。

  

- Mybatis的插件运行原理是怎样的？以及如何编写一个插件？

  插件相当于拦截器，Mybatis可以针对ParameterHander、ResultSetHander、StatementHander、Executor，四种接口编写拦截器，Mybatis在执行这四种对象的方法时，就会进入拦截器。

  实现Mybatis中的Interceptor接口，重写intercept()方法，并使用@Intercepts注解指定切入点，可以用这种方法，统计SQL的执行时间等。

  

- Mybatis的一级、二级缓存是怎样的？

  Mybatis的一级缓存是一个session级别的缓存，基于无大小限制的HashMap，在session flush或者close时会清空缓存，默认打开。

  Mybatis的二级缓存是一个namespace级别的缓存，session间可以共享，也是一个无大小限制的HashMap，也可以自定义存储源，默认关闭。

  脏数据比性能更可怕，我们全部关了。cacheEnabled=false

  

- 如何防止SQL 注入？

  - 参数过滤

  - 过滤和转义特殊字符

  - 开启预编译机制

    

- 为什么需要预编译？

  主要是为了防止SQL注入，传入的参数只会被看作纯文本，不会被当做SQL指定。复用了SQL对象，也可以提升一点性能。

  

- 如何获取生成的主键？

  数据库支持主键回显的话，可以在insert的标签中，加上useGeneratedKeys="true" keyColumn="id" keyProperty="id"

  

- Mybatis是如何将sql执行结果封装为目标对象并返回的？都有哪些映射形式？

  使用<resultMap>标签，逐一定义列名和属性名之间的关系。或者在SQL查询时，使用对象的字段名作为别名。

  

- Mybatis是否支持延迟加载？它的实现原理是什么？

  Mybatis仅支持一对一和一对多的延迟加载，默认关闭。在调用代理对象的方法时，发现方法对象为空，就会先调用原先关联的查询方法，把方法对象查出来。

  

- #{}和${}的区别是什么？

  #{}是占位符，预编译时会进行处理，并Mybatis在处理时会加上单引号，并将参数作为字符串处理。可以有效的防止SQL注入。

  ${}时拼接符，预编译时不会处理，可能引起SQL注入。
