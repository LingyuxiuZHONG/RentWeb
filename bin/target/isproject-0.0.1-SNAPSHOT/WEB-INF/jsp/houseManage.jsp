<%--
  Created by IntelliJ IDEA.
  User: zhonglingyuxiu
  Date: 2023/12/1
  Time: 4:33 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>--%>

<html>
<head>
    <title>House Management</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/style.css">
</head>
<body>
<nav>
  <div class="logo" >Dinofly</div>
  <form class="search-form" action="browse/search"  method="post">
    <input type="search" class="search-input" placeholder="HangZhou">
    <button type="submit">Search</button>
  </form>
</nav>
<div class="content">
  <div class="title">
    <p class="headline">House Management</p>
    <% String id = request.getParameter("id"); %>
    <a class="create" href="<%= "/landlord/createHouseResource?id=" + id %>">Create a new House Resource</a>
  </div>
  <table>
    <thead>
    <tr>
      <th>ad_id</th>
      <th>PHOTO</th>
      <th>TITLE</th>
      <th>CREATED</th>
      <th>MODIFIED</th>
      <th></th>
      <th></th>

    </tr>
    </thead>
    <tbody>

      <c:forEach items="${pageItems}" var="house">
        <tr>
          <td>${house.ad_id}</td>
          <td>
            <img src="${house.image}">
          </td>
          <td>${house.title}</td>
          <td>${house.created}</td>
          <td>${house.modified}</td>
          <td>
            <button>Edit</button>
          </td>
          <td>
            <button>Delete</button>
          </td>
        </tr>
      </c:forEach>

    </tbody>
  </table>
</div>


</body>
</html>
