<%--
  Created by IntelliJ IDEA.
  User: zhonglingyuxiu
  Date: 2023/12/4
  Time: 5:00 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/style.css">
</head>
<body style="display: flex;flex-direction: row">
    <div class="left-reg">
        <img class="left-img" src="/icon/register.png">
    </div>
    <div class="right-reg">
        <a class="login-reg-button" href="/register">Register</a>
        <div class="login-reg-title">
            <p class="big-title">Login to your Account</p>
            <span class="welcome">Search one comfortable home for yourself</span>
            <br>
            <span class="welcome">Search one great tenant for your house</span>
        </div>

      <form class="login-reg" action="/login" method="post" enctype="multipart/form-data">
        <label for="log_email">Email:</label>
        <input type="text" id="log_email" name="log_email">

        <label for="log_password">Password:</label>
        <input type="password" id="log_password" name="log_password">



        <input type="submit" value="Login">
      </form>
    </div>
</body>
</html>
