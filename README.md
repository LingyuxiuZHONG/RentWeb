# Rental ads board
The system to design intended to be an ads board for a rental offers. 
It is targeted for users wanting to rent an apartment or any other residential property. 
If you are an owner of an unoccupied livin
g apartments or some estate, which you want to rent out, you can use the system to publish an ad on the board, 
so that it would be available for your potential tenants.
## Technologies overview

### Three-tier architecture

- Presentation tier: User interface and data visualization
- Application tier: Perform operation:process data, computations
- Data tier: Retrieve data from data storage and prepare resultset
![three-tier.png](imgs%2Fthree-tier.png)
### JDBC
#### Base classes and interfaces
![jdbc.png](imgs%2Fjdbc.png)
#### Run SQL statement with JDBC
1. Import specific driver and load specific draver class
2. Establish a connection
3. Create a statement object
4. Execute SQL statement(the query)
5. Process the ResultSet object
6. Close the connection: close Connection,Statement,and ResultSet objects

`Statement` Used to implement simple SQL statements with no parameters.

`PreparedStatement` Used for precompiling SQL statements that might contain input parameters.

`CallableStatement` Used to execute stored procedures that may contain both input and output parameters.

`execute`: Returns true if the first object that the query returns is a ResultSet object.

`executeQuery`: Returns one ResultSet object.

`executeUpdate`: Returns an integer representing the number of rows affected by the SQL statement.

##### Simple example
```java
public class jdbcDemo{
    public static void viewCoffeess() throws SQLException {
        Connection con = DriverManager.getConnection("jdbc:myDriver:myDatabase",
                "dbusername", "dbpassword");
        String query = "select COF_NAME, SUP_ID, PRICE, SALES, TOTAL from COFFEES";
        try (PreparedStatement stmt = con.prepareStatement(query)) { 
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                String coffeeName = rs.getString("COF_NAME"); 
                int supplierID = rs.getInt("SUP_ID");
                float price = rs.getFloat("PRICE");
                int sales = rs.getInt("SALES");
                int total = rs.getInt("TOTAL");
                System.out.println(coffeeName + ", " + supplierID + ", " + price +
                        ", " + sales + ", " + total); }
        } catch (SQLException e) { 
            printSQLException(e);
        } finally { 
            con.close();
        } 
    }
    public static void printSQLException(SQLException ex) { 
        for (Throwable e : ex) {
            if (e instanceof SQLException) {
                e.printStackTrace(System.err); 
                System.err.println("SQLState: " + ((SQLException)e).getSQLState()); 
                System.err.println("Error Code: " + ((SQLException)e).getErrorCode()); 
                System.err.println("Message: " + e.getMessage());
                Throwable t = ex.getCause();
                while(t != null) {
                    System.out.println("Cause: " + t);
                    t = t.getCause(); 
                }
            } 
        }
    }
}
```
---------------------
Data Object

```java
public class Coffee {
    private int id;
    private String coffeeName; 
    private int supplierId; 
    private float price;
    private int sales;
    private int total;
    public Coffee(int id, String coffeeName, int supplierId, float price, int sales, int total) { 
        this.id = id;
    this.coffeeName = coffeeName;
    this.supplierId = supplierId;
    this.price = price; 
    this.sales = sales; 
    this.total = total;
}
//getters and setters
}
```
-------------
Database Manager abstraction
```java
public class DbManager implements AutoCloseable { 
    private final Connection connection;
    private final CoffeesRepository coffeesRepository;
    public DbManager(Connection connection) {
        this.connection = connection;
        this.coffeesRepository = new CoffeesRepositoryImpl(connection);
    }
    public static DbManager connect(String url, String username, String pwd) throws SQLException {
        Connection connection = DriverManager.getConnection(url, username, pwd);
        return new DbManager(connection); 
    }
    public CoffeesRepository coffees() { 
        return coffeesRepository; 
    }
    public void close() throws Exception {
        try { 
            connection.close();
        } catch (SQLException e) { 
            DbManager.printSQLException(e); 
        }
    }
    public static void printSQLException(SQLException ex) { ... } 
}
```

-------------
Repository pattern
```java
public interface CoffeesRepository {
    Coffee create(String coffeeName, int supplierId, float price, int sales, int total) throws SQLException; 
    Coffee find(int id) throws SQLException;
    List<Coffee> readAll() throws SQLException;
}

```
```java
public class CoffeesRepositoryImpl implements CoffeesRepository {
    private final Connection connection;
    public CoffeesRepositoryImpl(Connection connection) { t
        his.connection = connection; 
    }
    public List<Coffee> readAll() throws SQLException {
        List<Coffee> coffees = new ArrayList<Coffee>();
        String query = "select COF_NAME, SUP_ID, PRICE, SALES, TOTAL from COFFEES"; PreparedStatement stmt = connection.prepareStatement(query);
        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {
            coffees.add(new Coffee(rs.getInt("ID"), rs.getString("COF_NAME"), rs.getInt("SUP_ID"), rs.getFloat("PRICE"), rs.getInt("SALES"), rs.getInt("TOTAL")));
        }
        return coffees; 
    }
    public Coffee create(String coffeeName, int supplierId, float price, int sales, int total) { 
        // id = insert (coffeeName, supplierId, price, sales, total) into ... ;
        return new Coffee(id, coffeeName, supplierId, price, sales, total);
    }
    public Coffee find(int id) {
        // select * from .. where id = ? ;
        return new Coffee(id, coffeeName, supplierId, price, sales, total); 
    }
 }
```

### Servlet
```ascii
                 ┌───────────┐
                 │My Servlet │
                 ├───────────┤
                 │Servlet API│
┌───────┐  HTTP  ├───────────┤
│Browser│<──────>│Web Server │
└───────┘        └───────────┘

```
Servlets are indeed a server-side technology used to create dynamic web pages in web applications.

Servlets run within a servlet container, which is also known as a web container or servlet engine. 
The servlet container is responsible for managing the lifecycle of servlets, handling incoming HTTP requests, 
and generating HTTP responses. It provides the necessary infrastructure for servlets to operate, 
including managing servlet instances, mapping URLs to servlets, 
and handling multithreading issues.

The servlet container can host multiple servlets simultaneously, 
allowing web applications to contain multiple servlets that handle different aspects of functionality. 
This enables the development of modular, scalable, and maintainable web applications. 
Popular servlet containers include Apache Tomcat, Jetty, and IBM WebSphere.

![handle request process.png](imgs%2Fhandle%20request%20process.png)

#### Servlet lifecycle
![servlet lifecycle.png](imgs%2Fservlet%20lifecycle.png)

#### ServeletContext
ServletContext is an API that a servlet can use to interact with its container. 

1. General context of a servlet API based web application:
    - The ServletContext represents the entire web application deployed on the server. 
   It provides information and services that are common to all servlets in the application.
2. Sharing information common to all servlets:
   - Servlets within the same web application can use the ServletContext to share information among themselves. 
   This can be achieved using methods like setAttribute() and getAttribute() to store and retrieve attributes.
3. Accessing parameters with which the server was started:
   - The ServletContext allows servlets to access initialization parameters that were specified when the server was started. 
   Servlets can retrieve these parameters using methods like getInitParameter() and getInitParameterNames().
4. Accessing the request processing pipeline:
   - Servlets can use the ServletContext to access the request processing pipeline of the web application. 
   This includes creating and configuring filters, servlets, and listeners, as well as managing their lifecycle.

### Java Server Pages(JSP)
- JSP pages are text files containing static HTML and JSP elements. 
- JSP elements allow you to create dynamic content.
- When loaded into a web container, JSP pages are translated by the compiler (jasper) into servlets.
- Allow you to separate the business logic from the presentation layer (if combined with servlets).

## Java Bean
Bean is a class in the java language written according to certain rules:
- There is a constructor that does not accept any parameters
- Getters and setters for all the properties used in jsp
- The names of getters and setters must follow the conventions: get and set are added before the variable name, and the variable name is capitalized(variable Name, then getName and setName)
- implement a Serializable or Externalizable interface

## Spring Framework
The Spring framework is a set of libraries for enterprise Java development

### Sprint's Dependency Injection Containers -- Application Context
#### What is an ApplicationContext?

That is someone, who has control over all classes and can manage them appropriately


#### How to create an ApplicationContext?
```java
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
@Configuration
public class MyApplicationContextConfiguration { // (1)
    @Bean
    public DataSource dataSource() { // (2)
        PGSimpleDataSource dataSource = new PGSimpleDataSource();
        dataSource.setUser("root");
        dataSource.setPassword("s3cr3t");
        dataSource.setURL("jdbc:mysql://localhost:3306/myDatabase");
        return dataSource;
    }

    @Bean
    public UserDao userDao() { // (3)
        return new UserDao(dataSource());
    }
}
```
```java

import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext; 
import javax.sql.DataSource;
public class MyApplication {
    public static void main(String[] args) {
        ApplicationContext ctx = new AnnotationConfigApplicationContext(
                MyApplicationContextConfiguration.class); // (1)
        UserDao userDao = ctx.getBean(UserDao.class); // (2) User user1 = userDao.findById(1);
        User user2 = userDao.findById(2);
        
        DataSource dataSource = ctx.getBean(DataSource.class); // (3)
        // etc ...
    } 
}
```
#### What do @Component & @Autowired do?
`@Component` 是 Spring 框架中最基本的注解之一，用于将一个普通的 Java 类标识为 Spring 管理的组件（即 Bean）。
通过 @Component 注解，Spring 容器会自动扫描并加载被标记的类，并将其实例化为 Bean，使得这些 Bean 可以在应用程序中被注入和使用。
`@Autowired` 是 Spring 框架中的一个注解，用于自动装配（即自动连接）Bean。通过 @Autowired 注解，
Spring 容器会自动在应用上下文中查找匹配某个特定需求的 Bean，并自动将其注入到需要它的地方，比如属性、构造函数、或者方法参数。

### Spring MVC
Spring MVC is a Java framework that is used to build web applications

It follows the Model-View-Controller design pattern

- The Model encapsulates the application state independently of the UI. It manages the data, logic and rules of the application.
- The View is responsible for rendering the data coming from model data and presenting it to the user through the UI
  (by preparing HTML for example).
- The Controller is responsible for processing user requests and performing operations with model as well as taking its part in preparation of view actualization.

![MVC.png](imgs%2FMVC.png)

controller takes care of receiving request data and processes it accordingly

model contains the data that you want to render in your view.

view is just an HTML template
#### The DispatcherServlet
![DispatcherServlet.png](imgs%2FDispatcherServlet.png)

![MVC process.png](imgs%2FMVC%20process.png)
1. DispatcherServlet consults the HandlerMapping to call the appropriate Controller. 
2. Controller takes the request and calls the appropriate service methods,
   which will set model data based on defined business logic and returns view name to the DispatcherServlet. 
3. The DispatcherServlet will take help from ViewResolver to pickup the defined view for the request.
4. The DispatcherServlet passes the model data to the view which is finally rendered on the browser.

#### @RequestParam
for HTTP request parameters, be that in your URL (?key=value) or in a submitted form request body
#### @PathVariable
to specify variables directly in the request URI
```java
@GetMapping("/users/{userId}")
public User getUser(@PathVariable(required = false) String userId) {
    // ...
    return user; 
}
```
#### @RequestBody, @ResponseBody and @RestController
`@RequestBody` annotation maps the HttpRequest body to a transfer or domain object, enabling automaic deserialization
```java
@PostMapping("/request")
public ResponseEntity postController(@RequestBody LoginForm loginForm){
    exampleService.fakeAuthenticate(loginForm);
    return ResponseEntity.ok(HttpStatus.OK);
}

public class LoginForm{
    private String username;
    private String password;
}
```

The type we annotate with the `@ResponseBody` annotation must correspond to the JSON sent from our client-side controller

```java
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/post")
public class Example PostController {

    @Autowired
    ExampleService exampleService;

    @PostMapping("/response")
    @ResponseBody
    public ResponseTransfer postResponseController(@RequestBody LoginForm loginForm) {
        return new ResponseTransfer("Thanks For Posting!!!");
    }
}
```

#### @RestController
@RestController = @Controller + @ResponseBody
@RestController directly return Java objects, which Spring MVC will conveniently serialize to JSON/XML 
or any other format that the user requested with the help of HttpMessageConverters.


## Maven
Project Object Model(POM) Files 
    - XML file
    - information about project and configuration
Dependencies and Repositories
    - external Java libraries required for project
    - repositories are directories of packaged JAR files.
Build Life Cycles, Phases and Goals
    - build life cycle consists of a sequence of
build phases
    - each build phase consists of a sequence of goals
    - Maven command is the name of a build lifecycle, phase or goal
Build Profiles
    - set of configuration values
Build Plugins
    - used to perform specific goal
    - you can add a plugin to the POM file

## JPA
Java Persistence API(JAVA持久层应用接口),a Java specification to manage relational data. We use it to access and persist data
between Java object/class and relational database
JPA本身并不是一个框架，它本质上是一种ORM(Object Relational Mapping)规范，Hibernate是一个框架，也是JPA的一种实现。

https://mp.weixin.qq.com/mp/appmsgalbum?__biz=MzIwMjgxMTY2MQ==&action=getalbum&album_id=2452725517146685442&scene=173&subscene=&sessionid=svr_547f733fbe7&enterid=1710919555&from_msgid=2247483752&from_itemidx=1&count=3&nolastread=1#wechat_redirect

![JPA.png](imgs%2FJPA.png)
### Java 三层结构
简称为SSH，即Struts（表示层）+Spring（业务层）+Hibernate（持久层）

Struts是一个表示层框架，进行流程控制，主要作用是页面展示，发送请求，接受请求

Spring就是我们熟知的后端框架，进行业务流转

Hibernate是一个持久层框架，它只负责与关系数据库的操作

### Hibernate
我们原来使用JDBC连接来读写数据库，我们最常见的就是打开数据库连接、使用复杂的SQL语句进行读写、关闭连接，
获得的数据又需要转换或封装后往外传，这是一个非常烦琐的过程。
这时出现了Hibernate框架，它需要你创建一系列的持久化类，
每个类的属性都可以简单的看做和一张数据库表的属性一一对应。
这样我们不用在关注数据库，只需要持久化类就可以完成增删改查的功能。
使我们的软件开发真正面向对象， 而不是面向混乱的代码。

### JPA中的注释
#### @Entity
附加@Entity到类，此类告知JPA应该保留此类及其对象。
#### @Table
告诉JPA将实体（持久对象有时称为实体）持久化到表中。
参数name默认为实体名称，因此如果实体名称与映射的表名称一致时，@Table 注解常常可以省略。
#### @Id
我们使用JPA的@Id注释将id字段指定为主键。
用@GeneratedValue(strategy = GenerationType.IDENTITY)定义主键自增属性。

```java
@Entity @Table(name="entities") public class DBEntityInfo {
    @Id @GeneratedValue 
    private Long id;
    @Column(name="value") 
    private String value;
    public DBEntityInfo() {
        
    }
    
    public DBEntityInfo(Long id, String value) { 
        this.id = id;
        this.value = value;
    }
    // getters and setters 
}
```

### Sorting
1. 
```java
@Repository
public interface EntitiesRepository extends JpaRepository<DBEntityInfo, Long> { 
    List<DBEntityInfo> findByValueOrderByIdDesc(String paramValue);
}
```
2. Repository:
```java
@Repository
public interface EntitiesRepository extends JpaRepository<DBEntityInfo, Long> { 
    List<DBEntityInfo> findAll(Sort sort);
}
```
Usage:
```java
List<Employee> list = entitiesRepository.findAll(
    new Sort(Sort.Direction.DESC, "amount").and(new Sort(Sort.Direction.ASC, "value"))
);
```

### Pagination
Repository:
```java
@Repository
public interface EntitiesRepository extends JpaRepository<DBEntityInfo, Long> { 
    Page<DBEntityInfo> findAll(Pageable pageable);
}
```
Usage:
```java
Page<Employee> employeePage = employeeRepository.findAll(
    new PageRequest(0, 3, new Sort(Sort.Direction.DESC, "id"))
);
List<Employee> employeeList = employeePage.getContent();
```
