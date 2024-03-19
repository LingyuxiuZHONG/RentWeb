<%--
  Created by IntelliJ IDEA.
  User: zhonglingyuxiu
  Date: 2023/12/12
  Time: 2:59 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>
<head>
    <title>${house.title}</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/style.css">

</head>
<body>
<%
    // 获取当前时间
    Date currentDate = new Date();
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    String createdTime = dateFormat.format(currentDate);
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

    <c:choose>
        <c:when test="${not empty user}">
            <a class="logoutButton" href="/logout">Logout</a>
        </c:when>
        <c:otherwise>
            <a class="logoutButton" href="/login">Sign in or Sign up</a>
        </c:otherwise>
    </c:choose>


</nav>

<%@ page import="java.util.Base64" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<div class="detail-content">
    <img class="detail-img" src="data:image/png;base64,${Base64.getEncoder().encodeToString(house.image)}" alt="Image" >
    <div class="detail-descrip">
        <span class="detail-title">${house.title}</span>
        <span class="detail-pay">$${house.pay}</span>
        <br>
        <span class="detail-address">${house.address}</span>
        <p class="detail-attri-name">Description</p>
        <p class="detail-description">${house.descrip}</p>
        <p class="detail-attri-name">Availability</p>
        <span>Will be available till</span>
        <span style="color:#d75583;font-weight: bold">${house.availability}</span>
    </div>
    <div class="detail-comments">
        <div class="comments-title">
            <p>COMMENTS</p>
        </div>
        <button class="commentButton" onclick="openWindow()">Create a comment</button>
        <div class="overlay" id="commentOverlay">
            <div class="window" id="commentWindow">
                <button class="comment-closeButton"onclick="closeWindow()">X</button>
                <p>Create a comment</p>
                <form action="/create-comment?ad_id=${house.ad_id}" method="post">
                    <label for="comment"></label>
                    <textarea id="comment" name="comment" rows="10" cols="50"></textarea>
                    <input type="hidden" name="created" value="<%= createdTime %>">
                    <button class="comment-createButton" type="submit">Create</button>
                </form>
            </div>
            <div class="window" id="loginWindow">
                <button class="comment-closeButton" onclick="closeWindow()">X</button>
                <p>Please first login</p>
                <form action="/login?redirect=adDetail&&ad_id=${house.ad_id}" method="post">
                    <label for="detail-email">E-mail</label>
                    <input type="text" name="log_email" id="detail-email" required>
                    <label for="detail-password">Password</label>
                    <input type="password" name="log_password" id="detail-password" required>
                    <button class="comment-createButton" type="submit">Login</button>
                </form>
            </div>
        </div>
        <c:forEach items="${pageItems}" var="comment">
            <div class="detail-comment">
                <div class="comment-user">
                    <p>${comment.user.name}</p>
                    <span>${comment.created}</span>
                </div>
                <div class="comment-describe">
                    <p>${comment.content}</p>
                </div>
            </div>
        </c:forEach>




    </div>


</div>

</body>
<script>

    function openWindow() {
        <c:choose>
        <c:when test="${not empty user}">
        document.getElementById('commentOverlay').style.display = 'flex';
        document.getElementById('loginWindow').style.display = 'none';
        </c:when>
        <c:otherwise>
        document.getElementById('commentOverlay').style.display = 'flex';
        document.getElementById('commentWindow').style.display = 'none';
        </c:otherwise>
        </c:choose>
    }

    function closeWindow() {
        document.getElementById('commentOverlay').style.display = 'none';
    }

    window.onclick = function (event) {
        var commentOverlay = document.getElementById('commentOverlay');
        if (event.target == commentOverlay) {
            modalOverlay.style.display = 'none';
        }
    }


</script>
</html>
