<%--
  Created by IntelliJ IDEA.
  User: zhonglingyuxiu
  Date: 2023/12/4
  Time: 5:27 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Register</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/style.css">
    <script>
      function validatePasswords() {
        var password = document.getElementById("password").value;
        var confirmPassword = document.getElementById("pwd_confirm").value;

        if (password !== confirmPassword) {
          alert("Passwords do not match");
          return false;
        }
        return true;
      }
    </script>
</head>
<body class="register" style="display: flex;flex-direction: row">
  <div class="left-reg">
    <img class="left-img" src="/icon/register.png">
  </div>
  <div class="right-reg">
    <a class="login-reg-button" href="/login">Login</a>
    <div class="login-reg-title">
      <p class="big-title">Register for your account</p>
      <span class="welcome">Search one comfortable home for yourself</span>
      <br>
      <span class="welcome">Search one great tenant for your house</span>
    </div>

    <form class="login-reg" action="/register" method="post" enctype="multipart/form-data">
      <label for="name">Name</label>
      <input type="text" name="name" id="name">

      <label for="password">Password</label>
      <input type="password" name="password" id="password">

      <label for="pwd_confirm">Password Confirm</label>
      <input type="password" name="pwd_confirm" id="pwd_confirm">

      <label for="email">Email</label>
      <input type="text" name="email" id="email">

      <label for="phone">Phone</label>
      <input type="text" name="phone" id="phone">

      <label for="role">Role</label>
      <select id="role" name="role">
        <option value="landlord">Landlord</option>
        <option value="tenant">Tenant</option>
      </select>
      <br>

      <input type="submit" value="Register">

    </form>
  </div>

</body>
</html>
