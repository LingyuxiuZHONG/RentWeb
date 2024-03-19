<%--
  Created by IntelliJ IDEA.
  User: zhonglingyuxiu
  Date: 2023/11/30
  Time: 6:26 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<html>
<head>
    <title>Browse</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/style.css">
  <script src="https://kit.fontawesome.com/623f97bc8c.js" crossorigin="anonymous"></script>
</head>
<body>
<nav>
  <div class="logo" >Dinofly</div>
  <form class="search-form" action="/search"  method="post">
    <c:choose>
      <c:when test="${not empty searchContent}">
        <input type="search" class="search-input" name="searchContent" value="${searchContent}" onfocus="clearSearchContent(this)"/>
      </c:when>
      <c:otherwise>
        <input type="search" class="search-input" name="searchContent" value="San Francisco" onfocus="clearSearchContent(this)"/>
      </c:otherwise>
    </c:choose>
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

<div class="filters">
  <div id="priceFilter" class="filter">
    <c:choose>
      <c:when test="${empty minPrice && empty maxPrice}">
        <button class="filterButton" onclick="togglePriceForm()">
          <span>Price</span>
          <i name="priceIcon" class="fa-solid fa-caret-down"></i>
        </button>
      </c:when>
      <c:otherwise>
        <button class="filterButton" onclick="togglePriceForm()">
          <span>$${minPrice} - $${maxPrice}</span>
          <i name="priceIcon" class="fa-solid fa-caret-down"></i>
        </button>
      </c:otherwise>
    </c:choose>

    <form id="priceForm" class="filter-form" action="/index">
      <p class="filter-title">Price Filter</p>
      <label for="minPrice">Min</label>
      <input id="minPrice" name="minPrice" value="${minPrice}">
      <label for="maxPrice">Max</label>
      <input id="maxPrice" name="maxPrice" value="${maxPrice}">
      <input type="hidden" name="availFrom" value="${availFrom}">
      <input type="hidden" name="availTo" value="${availTo}">
      <input type="hidden" name="searchContent" value="${searchContent}">
      <input type="submit" style="display: none">
    </form>

  </div>



  <div id="availFilter" class="filter">
    <c:choose>
      <c:when test="${empty availFilter}">
        <button class="filterButton" onclick="toggleAvailForm()">
          <span>Availability</span>
          <i name="availIcon" class="fa-solid fa-caret-down"></i>
        </button>
      </c:when>
      <c:otherwise>
        <button class="filterButton" onclick="toggleAvailForm()">
          <span>${availFilter}</span>
          <i name="availIcon" class="fa-solid fa-caret-down"></i>
        </button>
      </c:otherwise>
    </c:choose>

    <form id="availForm" class="filter-form" action="/index">
      <p class="filter-title">Availability Filter</p>
      <label for="availFrom">From</label>
      <input type="date" id="availFrom" name="availFrom" value="${availFrom}" onchange="submitAvailForm()">
      <label for="availTo">To</label>
      <input type="date" id="availTo" name="availTo" value="${availTo}" onchange="submitAvailForm()">
      <input type="hidden" name="minPrice" value="${minPrice}">
      <input type="hidden" name="maxPrice" value="${maxPrice}">
      <input type="hidden" name="searchContent" value="${searchContent}">
      <input id="availBtn" type="submit" style="display: none">
    </form>

  </div>


</div>

<%@ page import="java.util.Base64" %>
<%@ page import="java.text.SimpleDateFormat" %>
<div class="browse-container">
    <c:forEach items="${pageItems}" var="house">
        <div class="house">
          <img src="data:image/png;base64,${Base64.getEncoder().encodeToString(house.image)}" alt="Image" >
          <div class="house-describe">
            <p>Pay: ${house.pay}$</p>
            <p>${house.address}</p>
          </div>
          <a class="detailButton" href="/ads/${house.ad_id}?action=detail" target="_blank">Check Availability</a>
        </div>
    </c:forEach>
</div>

<div class="pagination">
  <c:forEach var="pageNumber" items="${pageNumbers}">
    <c:choose>
      <c:when test="${pageNumber == currentPage}">
        <strong class="page-number">${pageNumber}</strong>
      </c:when>
      <c:otherwise>
        <a class="page-number" href= "/users/${id}/index?page=${pageNumber}" >${pageNumber}</a>
      </c:otherwise>
    </c:choose>
    &nbsp;
  </c:forEach>
</div>

</body>
<script>
  var isPriceFormVisible = false;
  var isAvailFormVisible = false;

  function togglePriceForm() {
    var priceForm = document.getElementById('priceForm');
    var icons = document.getElementsByName('priceIcon');
    isPriceFormVisible = !isPriceFormVisible;

    if (isPriceFormVisible) {
      priceForm.style.visibility = 'visible';
      for (var i = 0; i < icons.length; i++) {
        icons[i].className = 'fa-solid fa-caret-up';
      }
      document.addEventListener("click", priceOutsideClick);
    } else {
      priceForm.style.visibility = 'hidden';
      for (var i = 0; i < icons.length; i++) {
        icons[i].className = 'fa-solid fa-caret-down';
      }
      document.removeEventListener("click", priceOutsideClick);
    }
  }
  function priceOutsideClick(event) {
    var elementToHide = document.getElementById("priceFilter");
    var targetElement = event.target;

    // Check if the clicked element is outside the elementToHide
    if (!elementToHide.contains(targetElement)) {
      // Clicked outside the element, hide it
      isPriceFormVisible = false;
      var priceForm = document.getElementById('priceForm');
      var icons = document.getElementsByName('priceIcon');
      priceForm.style.visibility = 'hidden';
      for (var i = 0; i < icons.length; i++) {
        icons[i].className = 'fa-solid fa-caret-down';
      }
      document.removeEventListener("click", priceOutsideClick);
    }
  }

  function toggleAvailForm() {
    var availForm = document.getElementById('availForm');
    var icons = document.getElementsByName('availIcon');
    isAvailFormVisible = !isAvailFormVisible;

    if (isAvailFormVisible) {
      availForm.style.visibility = 'visible';
      for (var i = 0; i < icons.length; i++) {
        icons[i].className = 'fa-solid fa-caret-up';
      }
      document.addEventListener("click", availOutsideClick);
    } else {
      availForm.style.visibility = 'hidden';
      for (var i = 0; i < icons.length; i++) {
        icons[i].className = 'fa-solid fa-caret-down';
      }
      document.removeEventListener("click", availOutsideClick);
    }
  }
  function availOutsideClick(event) {
    var elementToHide = document.getElementById("availFilter");
    var targetElement = event.target;

    // Check if the clicked element is outside the elementToHide
    if (!elementToHide.contains(targetElement)) {
      // Clicked outside the element, hide it
      isAvailFormVisible = false;
      var availForm = document.getElementById('availForm');
      var icons = document.getElementsByName('availIcon');
      availForm.style.visibility = 'hidden';
      for (var i = 0; i < icons.length; i++) {
        icons[i].className = 'fa-solid fa-caret-down';
      }
      document.removeEventListener("click", availOutsideClick);
    }
  }
  function submitAvailForm() {

    document.getElementById("availForm").submit();
  }

  function clearSearchContent(input){
    if (input.value !== '') {
      input.value = '';
    }
  }

</script>
</html>
