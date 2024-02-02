<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>

<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<title>EasyTree</title>
	<link rel="stylesheet" href="../css/bootstrap.min.css">
	<link rel="stylesheet" href="../css/custom.css">
</head>
<body>
<%

	if (session.getAttribute("adminID") != null) {
		session.invalidate();
	}

%>
	<nav class="navbar navbar-expand-lg navbar-light bg-light">
		<a class="navbar-brand" href="adminIndex.jsp">EasyTree</a>
		<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbar">
			<span class="navbar-toggler-icon"></span>
		</button>
		<div id="navbar" class="collapse navbar-collapse">
			<ul class="navbar-nav mr-auto">
				<li class="nav-item active">
					<a class="nav-link" href="adminIndex.jsp">관리자 로그인</a>
				</li>
			</ul>
			<form class="form-inline my-2 my-lg-0" method="get" action="https://ncbi.nlm.nih.gov/search/all/">
				<input name="term" class="form-control mr-sm-2" type="search" placeholder="내용을 입력하세요." aria-label="Search">
				<button class="btn btn-outline-success my-2 my-sm-0" type="submit">검색</button>
			</form>
		</div>
	</nav>
	<section class="container mt-3" style="max-width: 560px;">
		<form method="post" action="./adminLoginAction.jsp">
			<div class="form-group">
				<label>아이디</label>
				<input type="text" name="adminID" class="form-control">
			</div>
			<div class="form-group">
				<label>비밀번호</label>
				<input type="password" name="adminPassword" class="form-control">
			</div>
			<button type="submit" class="btn btn-primary">로그인</button>
		</form>
		
	</section>
	<footer class="bg-dark mt-4 p-5 text-center" style="color: #FFFFFF;">
		제작자 : 이종섭<p>
		제작자 이메일 : leeeejsp@gmail.com / whdtjq1gh@naver.com<br>
		제작자 블로그 : leeeejsp.tistory.com
		
	</footer>	
	<script src="../js/jquery.min.js"></script>
	<script src="../js/popper.js"></script>
	<script src="../js/bootstrap.min.js"></script>
	
</body>
</html>