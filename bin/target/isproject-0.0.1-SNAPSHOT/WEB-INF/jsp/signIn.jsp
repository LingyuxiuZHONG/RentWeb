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
</head>
<body>
  <p>Login to your Account</p>
  <p>Search one comfortable home for yourself</p>
  <p>Search one great tenant for your house</p>
  <form class="user">
    <label for="email">Email:</label>
    <input type="text" id="email">

    <label for="password">Password:</label>
    <input type="password" id="password">

    <label>
      <input type="checkbox" name="rememberMe">Remember Me
    </label>
    <a href="#">Forgot Password?</a>
    <button class="login">Login</button>
  </form>
</body>
</html>
