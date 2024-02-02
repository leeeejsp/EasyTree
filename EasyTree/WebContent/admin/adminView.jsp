<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="sequence.SequenceDAO" %>
<%@ page import="sequence.SequenceDTO" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.util.ArrayList" %>
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
	
	String adminID = null;
	if (session.getAttribute("adminID") != null){
		adminID = (String) session.getAttribute("adminID");
	}
	
	if (adminID == null) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인 후 이용가능합니다.');");
		script.println("location.href='admin.jsp';");
		script.println("</script>");
		script.close();
		return;
	}
	request.setCharacterEncoding("UTF-8");
	String dnaID = null;
	
	if (request.getParameter("dnaID") != null) {
		dnaID = request.getParameter("dnaID");
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
					<a class="nav-link" href="adminIndex.jsp">관리자 페이지</a>
				</li>
				<li class="nav-item dropdown">
					<a class="nav-link dropdown-toggle" id="dropdown" data-toggle="dropdown">
						계정관리
					</a>
					<div class="dropdown-menu" aria-labelledby="dropdown">
						<a class="dropdown-item" href="../index.jsp">사용자 페이지</a>
						<a class="dropdown-item" href="passwordUpdate.jsp">비밀번호 수정</a>
						<a class="dropdown-item" href="adminLogoutAction.jsp">로그아웃</a>
					</div>
				</li>
			</ul>
			<form class="form-inline my-2 my-lg-0" method="get" action="https://ncbi.nlm.nih.gov/search/all/">
				<input name="term" class="form-control mr-sm-2" type="search" placeholder="내용을 입력하세요." aria-label="Search">
				<button class="btn btn-outline-success my-2 my-sm-0" type="submit">검색</button>
			</form>
		</div>
	</nav>
	<section class="container">
		<form method="get" action="adminIndex.jsp" class="form-inline mt-3 mb-3">
			<input type="text" name="search" class="form-control mx-1 mt-2" placeholder="내용을 입력하세요." >
			<button type="submit" class="btn btn-primary mx-1 mt-2">검색</button>
		</form>
<%
	SequenceDAO sequenceDAO = new SequenceDAO();
	ArrayList<SequenceDTO> viewList = sequenceDAO.view(dnaID);
	SequenceDTO view = viewList.get(0);
%>
		
		<div class="card bg-light mt-3">
			<div class="card-header bg-light">
				<div class="row">
					<div class="col-7 text-left"><i><%= view.getTreeName() %></i>&nbsp;</div>
					<div class="col-5 text-right">
						<small><%= view.getRegisterDay() %></small>
					</div>
				</div>
			</div>
			<div class="card-body">
				<p class="card-text">
					<pre><%= view.getDnaSequence() %></pre>
				</p>
				<div class="row">
					<div class="col-3 text-left">
						<a onclick="return confirm('수정하시겠습니까?')" href="update.jsp?dnaID=<%= view.getDnaID() %>">수정</a>
						<a onclick="return confirm('삭제하시겠습니까?')" href="deleteAction.jsp?dnaID=<%= view.getDnaID() %>">삭제</a>
					</div>
				</div>
			</div> 
		</div>		
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