<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%--
  Created by IntelliJ IDEA.
  User: zhonglingyuxiu
  Date: 2023/11/30
  Time: 6:26 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>


<html>
<head>
    <title>Title</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/style.css">
</head>
<body>
  <nav>
    <div id="logo" >Dinofly</div>
    <form class="search-form" action="browse/search"  method="post">
      <input type="search" class="search-input" placeholder="HangZhou">
      <button type="submit">Search</button>
    </form>

    <button class="signButton" type="button">Sign up or Log in</button>
    <button type="button" class="menuButton">Menu</button>
    <div class="menu-content">
      <a href="#">1</a>
      <a href="#">1</a>
      <a href="#">1</a>
    </div>

  </nav>

  <div class="filters">
    <select>
      <option value="1">1</option>
      <option value="1">1</option>
      <option value="1">1</option>
      <option value="1">1</option>
    </select>
    <select>
      <option value="1">1</option>
      <option value="1">1</option>
      <option value="1">1</option>
      <option value="1">1</option>
    </select>
    <select>
      <option value="1">1</option>
      <option value="1">1</option>
      <option value="1">1</option>
      <option value="1">1</option>
    </select>
  </div>


  <c:if test="${not empty houses}">
    <div class="house-container">
        <c:forEach items="${houses}" var="house">
            <div class="house">
              <img src="${house.img}">
              <div class="house-describe">
                <p>${house.pay}</p>
                <p>${house.address}</p>
                <p>${house.descrip}</p>
              </div>
              <a class="detailButton" href="#">Check Availability</a>
            </div>
        </c:forEach>
    </div>
  </c:if>

  <div class="pagination">
    <a href="#" class="prev">上一页</a>
    <span class="page-number">1</span>
    <span class="page-number">2</span>
    <span class="page-number">3</span>
    <span class="page-number">4</span>
    <span class="page-number">5</span>
    <a href="#" class="next">下一页</a>
  </div>



</body>
</html>
