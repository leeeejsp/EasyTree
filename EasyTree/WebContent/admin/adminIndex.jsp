<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="sequence.SequenceDAO" %>
<%@ page import="sequence.SequenceDTO" %>
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
	String search = "";
	int pageNumber = 0;
	
	if (request.getParameter("search") != null) {
		search = request.getParameter("search");
	}
	if (request.getParameter("pageNumber") != null) {
		pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
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
			<input type="text" name="search" class="form-control mx-1 mt-2" placeholder="내용을 입력하세요." 
			<%if (search != "") { %> 
				value="<%= search %>"
				<% } %>>
			<button type="submit" class="btn btn-primary mx-1 mt-2">검색</button>
			<a class="btn btn-primary mx-1 mt-2" data-toggle="modal" href="#registerModal">등록하기</a>
			<a class="btn btn-primary mx-1 mt-2" data-toggle="modal" href="#bigRegisterModal">대량 등록</a>
<%
	SequenceDAO count = new SequenceDAO();
	int resultCount = count.resultCount(search);
%>
			<h5 class="mx-1 mt-3">총 <%= resultCount %>개 결과</h5>
		</form>
<%
	SequenceDAO sequenceDAO = new SequenceDAO();
	ArrayList<SequenceDTO> searchList = sequenceDAO.registerList(search, pageNumber);
	if (searchList != null) {
		for (int i=0; i<searchList.size(); i++){
			if (i==21) break;
			SequenceDTO searchTrees = searchList.get(i);
			
%>	
		<div class="card bg-light mt-3">
			<div class="card-header bg-light">
				<div class="row">
					<div class="col-12 text-left">
						<i><%= searchTrees.getTreeName()%></i>
						&nbsp;<small><a href="https://www.ncbi.nlm.nih.gov/protein/<%= searchTrees.getFastaCode() %>"><%= searchTrees.getFastaCode() %></a></small>
					</div>
				</div>
			</div>
			<div class="card-body">
				<p class="card-text">
					<a href="adminView.jsp?dnaID=<%= searchTrees.getDnaID()%>"><%=searchTrees.getFastaTitle()%></a>
				</p>
			</div> 
		</div>
<%
		}
	}
%>		
	</section>
	
	<ul class="pagination justify-content-center mt-3">
	
<%
	SequenceDAO pagelist = new SequenceDAO();
	int totalPage = pagelist.totalPage(search); //전체 페이지 수가 나옴
	int result = pagelist.groupNumber(pageNumber, totalPage);
	
	if (pageNumber == 0) {
%>	
			<li class="page-item disabled">
				<a class="page-link disabled">처음</a>
			</li>
<%
	} else {
%>			
			<li class="page-item">
				<a class="page-link" href="adminIndex.jsp?search=<%= URLEncoder.encode(search, "UTF-8")%>&
				pageNumber=0">처음</a>
			</li>
<%
	}
	// <<버튼
	if ( result == 1 ) {
%>		
			  
			<li class="page-item disabled">
				<a class="page-link disabled">&lt;&lt;</a>
			</li>
<%
	} else {
%>
			<li class="page-item">
				<a class="page-link" href="adminIndex.jsp?search=<%= URLEncoder.encode(search, "UTF-8")%>&
				pageNumber=<%= result - 11 %>">&lt;&lt;</a>
			</li>
<%
	}
	//이전버튼
	if (pageNumber == 0) {
%>			
			
			<li class="page-item disabled">
				<a class="page-link disabled">이전</a>
			</li>
<%
	} else {
%>
			<li class="page-item">
				<a class="page-link" href="adminIndex.jsp?search=<%= URLEncoder.encode(search, "UTF-8")%>&
				pageNumber=<%= pageNumber - 1 %>">이전</a>
			</li>
<% 
	} 
%>
				&nbsp;&nbsp;&nbsp;
<%
	//숫자페이지 버튼
	if (totalPage != 0) {	
		if (result != 0) {
			//totalPage함수와 groupNumber함수에서 오류가 안났을 경우
		for (int i=result; i < result+10; i++) {
			//1~10페이지까지 보여줄 것임 (10페이지 단위) i값은 그룹넘버의 시작
			if (i > totalPage) break;
			if (pageNumber == i - 1) {
%>				
				<li class="page-item active">
					<a class="page-link" href="adminIndex.jsp?search=<%= URLEncoder.encode(search, "UTF-8")%>&
				pageNumber=<%= i-1 %>"><%= i %></a>
				</li>
<%
			} else {
%>
				<li class="page-item">
					<a class="page-link" href="adminIndex.jsp?search=<%= URLEncoder.encode(search, "UTF-8")%>&
				pageNumber=<%= i-1 %>"><%= i %></a>
				</li>
<%				
			}
		}
	}
}
%>			
				&nbsp;&nbsp;&nbsp;
<%
	if (searchList.size() < 21) {
		//다음 버튼
%>			
			 
			<li class="page-item disabled">
				<a class="page-link disabled">다음</a>
			</li>
<%
	} else {
%>
			<li class="page-item">
				<a class="page-link" href="adminIndex.jsp?search=<%= URLEncoder.encode(search, "UTF-8")%>&
				pageNumber=<%= pageNumber + 1 %>">다음</a>
			</li>
<% 
	} 

	if ( result+10 > totalPage ) {
		// >>버튼
%>
			
			<li class="page-item disabled">
				<a class="page-link disabled">&gt;&gt;</a>
			</li>
		
<%
	} else {
%>
			<li class="page-item">
				<a class="page-link" href="adminIndex.jsp?search=<%= URLEncoder.encode(search, "UTF-8")%>&
				pageNumber=<%= result + 9 %>">&gt;&gt;</a>
			</li>
<%
	}
	if ((pageNumber == totalPage-1) || totalPage == 0){
%>
			<li class="page-item disabled">
				<a class="page-link disabled">마지막</a>
			</li>
<%
	} else {
%>
			<li class="page-item">
				<a class="page-link" href="adminIndex.jsp?search=<%= URLEncoder.encode(search, "UTF-8")%>&
				pageNumber=<%= totalPage-1%>">마지막</a>
			</li>
<%
	}
%>

	</ul>
	<div class="modal fade" id="registerModal" tabindex="-1" role="dialog" aria-labelledby="modal" aria-hidden="true">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="modal">유전자 등록</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<form action="registerAction.jsp" method="post">
						<div class="form-row">
							<div class="form-group col-sm-12">
								<label>학명</label>
								<input type="text" name="treeName" class="form-control">
							</div>
							<div class="form-group col-sm-12">
								<label>FASTA 코드</label>
								<input type="text" name="fastaCode" class="form-control">
							</div>
							<div class="form-group col-sm-12">
								<label>FASTA 제목</label>
								<input type="text" name="fastaTitle" class="form-control">
							</div>
						</div>
						<div class="form-group">
							<label>FASTA 포맷</label>
							<textarea name="dnaSequence" class="form-control" style="height: 180px;"></textarea>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
							<button type="submit" class="btn btn-primary">등록하기</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
	<div class="modal fade" id="bigRegisterModal" tabindex="-1" role="dialog" aria-labelledby="modal" aria-hidden="true">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="modal">대량 유전자 등록</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<form action="xmlRegisterAction.jsp" method="post">
						<div class="form-group">
							<label>XML형식을 넣으세요.</label>
							<textarea name="xmlContent" class="form-control" style="height: 300px;"></textarea>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
							<button type="submit" class="btn btn-primary">등록하기</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
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