<%--
  Created by IntelliJ IDEA.
  User: zhonglingyuxiu
  Date: 2023/12/12
  Time: 8:15 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<html>
<head>
    <title>Admin Manage</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/style.css">
    <script>
      function confirmDelete(button) {
        var adId = button.getAttribute('data-ad-id');
        var result = confirm("Do you want to delete?");
        if (result) {
          window.location.href = "/landlords/${id}/ads/" + adId + "?action=delete&mode=htmlForm";
        }
      }
    </script>
</head>
<body>
<nav>
  <div class="logo" >Dinofly</div>
  <form class="search-form" action="/search"  method="post" target="_blank">
    <input type="search" class="search-input" name="searchContent" value="San Francisco" />
    <button type="submit" class="searchButton">
      <img src="/icon/search.png" alt="Image Description">
    </button>
  </form>
  <img />

  <a class="logoutButton" href="/logout">Logout</a>

</nav>

<div class="content">
  <div class="title">
    <span class="headline">User Management</span>

  </div>
  <div class="manage-ads">
    <table>
      <thead>
      <tr>
        <th>user_id</th>
        <th>NAME</th>
        <th>PASSWORD</th>
        <th>EMAIL</th>
        <th>PHONE</th>
        <th>ROLE</th>
        <th></th>
        <th></th>


      </tr>
      </thead>
      <tbody>
      <c:forEach items="${pageItems}" var="user">
        <tr>
          <td>${user.userId}</td>
          <td>${user.name}</td>
          <td>${user.password}</td>
          <td>${user.email}</td>
          <td>${user.phone}</td>
          <form id="userRoleForm" action="/admins/${id}/changeRole?user_id=${user.userId}" method="post">
            <td>
              <label for="userRole-${user.userId}" style="display: none"></label>
              <select id="userRole-${user.userId}" name="userRole">
                <c:forEach var="role" items="${userRoles}">
                  <option value="${role}">${role}</option>
                </c:forEach>
              </select>
            </td>
            <td>
              <button class="EDButton" type="submit">Change</button>
            </td>
          </form>
          <td>
            <button class="EDButton" data-ad-id="${user.userId}" onclick="confirmDelete(this)">Delete</button>
          </td>
        </tr>
        <script>
          document.getElementById('userRole-${user.userId}').value = "${user.role}";
        </script>
      </c:forEach>

      </tbody>
    </table>
  </div>


  <div class="pagination">
    <c:forEach var="pageNumber" items="${pageNumbers}">
      <c:choose>
        <c:when test="${pageNumber == currentPage}">
          <strong class="page-number">${pageNumber}</strong>
        </c:when>
        <c:otherwise>
          <a class="page-number" href= "/admins/${id}?page=${pageNumber}" >${pageNumber}</a>
        </c:otherwise>
      </c:choose>
      &nbsp;
    </c:forEach>
  </div>

</div>
</body>

</html>
