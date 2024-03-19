<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %><%--
  Created by IntelliJ IDEA.
  User: zhonglingyuxiu
  Date: 2023/12/2
  Time: 8:55 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Create House Resources</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/style.css">

</head>
<body>
<%
    // 获取当前时间
    Date currentDate = new Date();
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
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

    <a class="logoutButton" href="/logout">Logout</a>

</nav>
<div class="content">
    <div class="title">
        <span class="headline">Ad Create</span>
    </div>
    <form id="create" class="create" action="${pageContext.request.contextPath}/create-house-resource" method="post" enctype="multipart/form-data">

        <label class="create-label" for="title">Title:</label>
        <input type="text" id="title" name="title" required>

        <label class="create-label" for="address">Address:</label>
        <input type="text" id="address" name="address" required>

        <label class="create-label" for="descrip">Description:</label>
        <textarea id="descrip" name="descrip" rows="4" cols="50"></textarea>

        <label class="create-label" for="avail">Availability:</label>
        <input type="date" id="avail" name="avail" required>

        <label class="create-label" for="pay">Pay:</label>
        <input type="number" id="pay" name="pay" required>

        <input class="create-upload" type="file" id="image" name="image" accept="image/*" >

        <input type="hidden" name="created" value="<%= createdTime %>">


        <button type="submit" class="create-button" onclick="submitFormAndNotifyParent(e)">Create</button>

    </form>


</div>

</body>
<script>
    function submitFormAndNotifyParent(e) {
        e.preventDefault();

        var form = document.getElementById('create');

        // 提交表单
        form.submit();

        console.log("created");

        // 在表单提交成功后，向父窗口发送消息
        window.opener.postMessage('operationCompleted', window.location.origin);

        window.close();
    }
</script>

</html>
