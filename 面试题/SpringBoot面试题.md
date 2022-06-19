- Spring有哪些特点？

  IOC，Inversion of Control，其实是一种新的设计模式，根据对象的依赖关系，进行注入，具体的表型形式有依赖注入DI，和依赖查找。

  AOP，Aspect Oriented Programming，面向切面编程，Spring在创建对象时，可以代理该对象，并在调用方法前后，做一些处理。

  依赖查找，Dependency Lookup，和依赖注入的区别是，依赖注入由容器自动进行，依赖查找需要配合容器的API进行。

  

- 为什么要用SpringBoot？

  作为单例工厂的脚手架，从Spring延续而来，减少开发成本。

  早期的Spring框架，对象的依赖注入、控制反转，需要通过配置文件进行配置，当项目工程比较庞大时，非常消磨开发人员精力。比较常用的WEB开发，还需要再集成Spring MVC，比较繁琐。SpringBoot则极大的简化了配置，并且内嵌了SpringMVC和Tomcat容器，能够快速构建项目，进行敏捷式开发。

  

- 什么是MVC？

  MVC是一种系统设计思想，M指Model业务模型，View指视图界面，C指控制器。用户通过视图界面查看数据，并通过控制器进行请求，系统根据Model进行业务处理。

  

- SpringBoot与SpringCloud 区别是什么？

  SpringBoot是快速开发的框架，SpringCloud是完整的微服务框架，SpringCloud依赖于SpringBoot，其实就是加上了各种微服务的Starter。

  

- SpringBoot 有哪些优缺点？

  优点：

  - 开箱即用，简化了繁琐的配置，提升了开发效率。
  - 集成了SpringMVC、Tomcat容器，并且可以很方便的集成各种组件。

  缺点：屏蔽了很多技术细节，没有接触过早期Spring框架，不了解原理的话，出现问题排查会比较困难。

  

- spring-boot-starter-parent 有什么用 ?

  - 定义了JDK的依赖版本和UTF-8的编码格式
  - 集成自spring-boot-dependencies，管理各种常用依赖的版本
  - 定义了application配置文件，集成了打包操作的配置

  

- Spring Boot 的核心注解是哪个？它主要由哪几个注解组成的？

  启动类注解是@SpringBootApplication。由@SpringBootConfiguration，@EnableAutoConfiguration，@ComponentScan组成

  

- Spring Boot 支持哪些日志框架？推荐和默认的日志框架是哪个？

  支持Java Util Logging，Log4j，Logback，默认使用Logback作为日志框架。并且不管哪个框架，都支持输出到控制台和文件中。

  

- Java SPI和SpringBoot SPI有什么区别？

  SPI，Service Provider Interface

  Java SPI，在加载lib时，读取META-INF/services目录中的文件，文件中包含具体实现类的全路径类名，根据读取到的全路径类名进行加载。

  SpringBoot SPI，读取META-INF/spring.factories文件，文件中包含各种Starter的全路径类名，根据其中的全路径类名进行加载。

  

- SpringBoot支持哪些前端模板？

  thymeleaf、freemarker、jsp

  

- 运行 Spring Boot 有哪几种方式？

  有编译好的字节码文件的话，可以直接通过java命令进行运行，开发中常用

  已经达成jar包的话，可以通过java jar命令进行运行，生产部署常用

  

- SpringBoot如何开启事务？

  在启动类中加上@EnableTransactionManagement注解，在具体的业务类中，加上@Transactional注解

  

- 如何在 Spring Boot 启动的时候运行一些特定的代码？

  实现ApplicationRunner接口，在run中可以运行特定的代码。

  

- 在Spring AOP中关注点(concern)和横切关注点(cross-cutting concern)有什么不同？

  关注点为具体的业务方法，横切关注点为一种伴随的行为，如日志打印。

  

- AOP有哪些可用的实现？

  基于Java的AOP实现有，AspectJ、Spring AOP、JBoss AOP

  

- Spring中有哪些不同的通知类型(advice types)？

  - 前置通知，@Before，在方法调用前执行，异常则中断
  - 返回后通知，@AfterReturning，方法执行完后后执行
  - 异常后通知，@AfterThrowing，方法异常时执行
  - 后置通知，@After，异常或者正常返回都执行
  - 围绕通知，@Around，在方法执行前后都可以执行

  

- Spring AOP 代理是什么？

  Spring中默认使用JDK动态代理，也可以使用CGLIB字节码增强代理

  

- 连接点(Joint Point)和切入点(Point Cut)是什么？有什么区别？

  连接点可以认为是一个方法。切入点可以认为是一个表达式，对连接点进行匹配，如@Execution

  

- JDK动态代理和CGLIB代理有什么区别？

  JDK动态代理基于接口，通过反射生成代理接口的匿名类，核心是Proxy类。CGLIB通过修改类的字节码文件，并创建相应的对象进行代理，核心是Enhance类。

  

- 什么是 JavaConfig？

  使用Java对象、Java代码进行配置，而不是使用XML文件。可以充分使用Java面向对象的特点，减少Java代码和XML文件间的切换。

  

- Spring Boot 有哪几种读取配置的方式？

  @Value、@ConfigurationProperties注册配置类。

  Spring读取配置文件，主要是通过ResourceUtils加载配置文件，通过PropertiesLoaderUtils替换占位符等。

  

- Spring Boot 配置加载顺序是怎样的？

  properties文件、yaml文件、环境变量、命令行参数

  

- 使用@Async需要注意什么？

  默认的线程池大小有限，负载重时会挤占Spring程序的执行时间

  默认的队列是无界队列，负载重时可能会发生OOM

  

- Spring Boot 是否可以使用 XML 配置 ?

  可以，通过@ImportResource导入，不过官方推荐还是使用Java配置。

  

- springBoot 核心配置文件是什么？

  bootstrap、application两个配置文件

  

- bootstrap.properties 和 application.properties 有何区别 ?

  bootstrap配置在应用程序上下文的引导阶段就能生效，且不能被覆盖。

  

- 什么是 Spring Profiles？

  有些配置文件，在开发、测试等不同环境，可能是不同的，Spring Profiles允许用户根据配置文件的profiles来注册bean，或者切换配置。

  

- 如何进行SpringBoot多数据源拆分？

  在配置文件中配置多数据源，在代码中创建对应多个DataSource和SqlSessionFactory实例。通过@MapperScan配置扫描的包路径和SqlSessionFactory。

  

- SpringBoot多数据源事务如何管理？

  在多数据源创建DataSource对象时，手动注入TransactionManager

  

- 如何实现 Spring Boot 应用程序的安全性？

  SpringBoot程序，可以很比较简单的集成Spring Security，依靠Spring Security强大的安全管理，保障程序的安全。

  

- Spring Security 和 Shiro 各自的优缺点是什么?

  Spring Security是一个重量级的安全管理框架，功能全面。Shiro是一个轻量级的框架，。

  Spring Security概念复杂、配置繁琐，Shiro概念简单、配置简单

  

- Spring Boot 中如何解决跨域问题 ?

  实现WebMvcConfigurer接口，重写addCorsMappings()方法，对跨域的资源放行

  

- 如何使用 Spring Boot 实现全局异常处理？

  使用@ControllerAdvice修饰异常控制类，在方法加上@ExceptionHandler，对异常进行处理。早期的项目，没有使用SpringBoot，也可以在拦截器中拦截异常，并进行处理。

  

- 如何监视所有 Spring Boot 微服务？

  我们依赖和集成actuator的组件，以http的方式，对外提供采集信息的接口。通过普罗米修斯进行采集，通过Grafana进行查看。

  

- SpringBoot性能如何优化？

  初始堆和最大堆配置成一样，避免扩容导致的时间开销

  将SpringBoot内置的tomcat替换成undertow

  

- SpringBoot项目如何热部署？

  集成devtools，devtools中有两个ClassLoader，一个用于加载不会变化的第三方依赖，另一个被称为Restart ClassLoader，当代码发生变更时，直接丢弃Restart ClassLoader，重新创建一个新的，以替换原先的代码。

  

- SpringBoot微服务中如何实现 session 共享 ?

  我们一般在将session用redis进行存储，并在拦截器中，拦截微服务的请求，检查请求所带的鉴权信息，与redis存储的session进行比对，实现session的共享。

  

- SpringBoot 中如何实现定时任务 ?

  使用@Scheduled，或者使用定时任务线程池

  

- SpringBoot 打成的 jar 和普通的 jar 有什么区别 ?

  SpringBoot打出的jar，可以通过java jar方式运行，并且不能被其他项目依赖