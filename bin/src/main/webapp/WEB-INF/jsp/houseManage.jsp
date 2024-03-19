<%--
  Created by IntelliJ IDEA.
  User: zhonglingyuxiu
  Date: 2023/12/1
  Time: 4:33 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<html>
<head>
    <title>House Management</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/style.css">
    <script>
        function confirmDelete(button) {
          var adId = button.getAttribute('data-ad-id');
          var result = confirm("Do you want to delete?");
          if (result) {
            window.location.href = "/ads/" + adId + "?action=delete&mode=htmlForm";
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
    <span class="headline">House Management</span>

    <a class="toCreate" href="/create-house-resource" target="_blank" onclick="openCreateAndRefresh(e)">Create a new House Resource</a>

  </div>
  <div class="manage-ads">
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
      <%@ page import="java.util.Base64" %>
      <c:forEach items="${pageItems}" var="house">
        <tr>
          <td>${house.ad_id}</td>
          <td>
            <img class="manage-img" src="data:image/png;base64,${Base64.getEncoder().encodeToString(house.image)}" alt="Image" >
          </td>
          <td>${house.title}</td>
          <td>${house.created}</td>
          <td>${house.modified}</td>
          <td>
            <a href="/ads/${house.ad_id}?action=edit&mode=htmlForm" target="_blank">
              <button class="EDButton" >Edit</button>
            </a>
          </td>
          <td>
            <button class="EDButton" data-ad-id="${house.ad_id}" onclick="confirmDelete(this)">Delete</button>
          </td>
        </tr>
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
          <a class="page-number" href= "/house-manage?page=${pageNumber}" >${pageNumber}</a>
        </c:otherwise>
      </c:choose>
      &nbsp;
    </c:forEach>
  </div>

</div>


</body>
<script>
  function openCreateAndRefresh(e) {
    // 阻止默认的<a>标签点击行为，以便后续执行自定义操作
    e.preventDefault();

    // 打开新标签页
    var newTab = window.open(e.target.href, '_blank');

    // 监听来自新标签页的消息
    window.addEventListener('message', function (messageEvent) {
      if (messageEvent.origin === e.target.origin && messageEvent.data === 'operationCompleted') {
        // 刷新旧标签页
        if (window.opener && !window.opener.closed) {
          window.opener.location.reload();
        }
      }
    });
  }

</script>
</html>
