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
        String createdAt = dateFormat.format(currentDate);
    %>
    <form class="create" action="${pageContext.request.contextPath}/landlord/createHouseResource" method="post" enctype="multipart/form-data">

        <label for="title">Title:</label>
        <input type="text" id="title" name="title" required>

        <label for="address">Address:</label>
        <input type="text" id="address" name="address" required>

        <label for="descrip">Description:</label>
        <input type="text" id="descrip" name="descrip">

        <label for="avail">Availability:</label>
        <input type="date" id="avail" name="avail">

        <label for="pay">Pay:</label>
        <input type="number" id="pay" name="pay" required>

        <label for="image">Image:</label>
        <input type="file" id="image" name="image" accept="image/*">
        <input type="hidden" name="created" value="<%= createdAt %>">
        <input type="hidden" name="owner" value="${param.id}">
        <button type="submit">Create</button>

    </form>

</body>
</html>
