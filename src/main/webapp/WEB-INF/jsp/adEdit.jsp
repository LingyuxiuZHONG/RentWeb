<%--
  Created by IntelliJ IDEA.
  User: zhonglingyuxiu
  Date: 2023/12/5
  Time: 3:19 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>Ad Edit</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/style.css">
</head>
<body>
<%
    // 获取当前时间
    Date currentDate = new Date();
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    String modified = dateFormat.format(currentDate);
%>
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
<div>
    <div class="edit-title">
        <span class="headline">Ad Edit</span>
    </div>
    <%@ page import="java.util.Base64" %>
    <%@ page import="java.util.Date" %>
    <%@ page import="java.text.SimpleDateFormat" %>
    <div  class="edit-content">
        <div class="edit-left">
            <form class="edit-form" action="${pageContext.request.contextPath}/ads/${ad_id}?action=update" method="post" enctype="multipart/form-data">

                <label for="title">Title</label>
                <input type="text" id="title" name="title" value="<c:out value='${ad.title}'/>">
                <label for="address">Address</label>
                <input type="text" id="address" name="address" value="<c:out value='${ad.address}'/>">
                <label for="descrip">Description</label>
                <textarea type="text" id="descrip" name="descrip" rows="5" cols="40">${ad.descrip}</textarea>
                <label for="pay">Pay</label>
                <input type="number" id="pay" name="pay"  value="<c:out value='${ad.pay}'/>">
                <label for="avail">Availability</label>
                <fmt:formatDate value="${ad.availability}" pattern="yyyy-MM-dd" var="formattedDate" />
                <input type="date" id="avail" name="avail" value="${formattedDate}" />
                <input type="hidden" name="modified" value="<%= modified %>">

                <input type="file" id="image" name="image" accept="image/*" >

                <button class="edit-button" type="submit">Update</button>

            </form>
        </div>

        <div id="edit-right">
            <img id="edit-img" src="data:image/png;base64,${Base64.getEncoder().encodeToString(ad.image)}" alt="Image" >
        </div>
    </div>




</div>
</body>
</html>
