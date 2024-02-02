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
	<link rel="stylesheet" href="./css/bootstrap.min.css">
	<link rel="stylesheet" href="./css/custom.css">
	<script src="./js/checkBox.js"></script>
</head>
<body>
<%
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
		<a class="navbar-brand" href="index.jsp">EasyTree</a>
		<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbar">
			<span class="navbar-toggler-icon"></span>
		</button>
		<div id="navbar" class="collapse navbar-collapse">
			<ul class="navbar-nav mr-auto">
				<li class="nav-item active">
					<a class="nav-link" href="index.jsp">메인</a>
				</li>
				<li class="nav-item active">
					<a class="nav-link">사용자 페이지</a>
				</li>
				<li class="nav-item active">
					<a class="nav-link" href="https://leeeejsp.tistory.com/71">사용법</a>
				</li>
			</ul>
			<form class="form-inline my-2 my-lg-0" method="get" action="https://ncbi.nlm.nih.gov/search/all/">
				<input name="term" class="form-control mr-sm-2" type="search" placeholder="내용을 입력하세요." aria-label="Search">
				<button class="btn btn-outline-success my-2 my-sm-0" type="submit">검색</button>
			</form>
		</div>
	</nav>
	<section class="container">
		<form method="get" action="./index.jsp" class="form-inline mt-3 mb-3">
			<input style="width:60%;" type="text" name="search" class="form-control mx-1 mt-2" placeholder="내용을 입력하세요." 
			<%if (search != "") { %> 
				value="<%= search %>"
				<% } %>>
			<button type="submit" class="btn btn-primary mx-1 mt-2">검색</button>
			<a class="btn btn-primary mx-1 mt-2" data-toggle="modal" href="#treeModal">트리보기</a>
		
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
						<div class="form-check">
							<input class="form-check-input" type="checkbox" name="tree" value="<%=searchTrees.getFastaCode() + "  " + searchTrees.getFastaTitle()%>" id="<%=searchTrees.getFastaCode() + "  " + searchTrees.getFastaTitle()%>" onclick="inputCheckboxValue()"> 
							<label class="form-check-label" for="flexCheckDefault"><i><%=searchTrees.getTreeName()%></i></label>
							&nbsp;<small><a href="https://www.ncbi.nlm.nih.gov/protein/<%= searchTrees.getFastaCode() %>"><%= searchTrees.getFastaCode() %></a></small>
						</div>
					</div>
				</div>
			</div>
			<div class="card-body">
				<p class="card-text">
					<a href="./user/userView.jsp?dnaID=<%= searchTrees.getDnaID()%>"><%=searchTrees.getFastaTitle()%></a>
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
				<a class="page-link" href="index.jsp?search=<%= URLEncoder.encode(search, "UTF-8")%>&
				pageNumber=0">처음</a>
			</li>
<% 
			} 
		
	if ( result == 1 ) {
%>		
			  
			<li class="page-item disabled">
				<a class="page-link disabled">&lt;&lt;</a>
			</li>
<%
	} else {
%>
			<li class="page-item">
				<a class="page-link" href="index.jsp?search=<%= URLEncoder.encode(search, "UTF-8")%>&
				pageNumber=<%= result - 11 %>">&lt;&lt;</a>
			</li>
<%
	}
	if (pageNumber == 0) {
%>			
			
			<li class="page-item disabled">
				<a class="page-link disabled">이전</a>
			</li>
<%
	} else {
%>
			<li class="page-item">
				<a class="page-link" href="index.jsp?search=<%= URLEncoder.encode(search, "UTF-8")%>&
				pageNumber=<%= pageNumber - 1 %>">이전</a>
			</li>
<% 
	} 
%>
				&nbsp;&nbsp;&nbsp;
<%
	
	if (totalPage != 0) {	
		if (result != 0) {
		for (int i=result; i < result+10; i++) {
			if (i > totalPage) break;
			if (pageNumber == i - 1) {
%>				
				<li class="page-item active">
					<a class="page-link" href="index.jsp?search=<%= URLEncoder.encode(search, "UTF-8")%>&
				pageNumber=<%= i-1 %>"><%= i %></a>
				</li>
<%
			} else {
%>
				<li class="page-item">
					<a class="page-link" href="index.jsp?search=<%= URLEncoder.encode(search, "UTF-8")%>&
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
%>			
			 
			<li class="page-item disabled">
				<a class="page-link disabled">다음</a>
			</li>
<%
	} else {
%>
			<li class="page-item">
				<a class="page-link" href="index.jsp?search=<%= URLEncoder.encode(search, "UTF-8")%>&
				pageNumber=<%= pageNumber + 1 %>">다음</a>
			</li>
<% 
	} 

	if ( result+10 > totalPage ) {
%>
			
			<li class="page-item disabled">
				<a class="page-link disabled">&gt;&gt;</a>
			</li>
		
<%
	} else {
%>
			<li class="page-item">
				<a class="page-link" href="index.jsp?search=<%= URLEncoder.encode(search, "UTF-8")%>&
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
				<a class="page-link" href="index.jsp?search=<%= URLEncoder.encode(search, "UTF-8")%>&
				pageNumber=<%= totalPage-1%>">마지막</a>
			</li>
<%
	}
%>
	</ul>
	
	<div class="modal fade" id="treeModal" tabindex="-1" role="dialog" aria-labelledby="modal" aria-hidden="true">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="modal">트리보기</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<form action="./muscle/calculateDNA.jsp" method="post">
						<div class="form-group">
							<label>체크리스트</label>&emsp;
							<strong><label id="count"></label></strong>
							<div class="overflow-auto" id="result" style=" width:100%; height:200px; padding:10px; border: 1px solid #dddddd;"></div>
							<input type="hidden" id="hidden" name="trees" value="">
						</div> 
						<div class="form-group">
							<label>트리 체크</label>
							<table class="table table-borderless" style="text-align: center; border: 1px solid #dddddd;">
								<thead>
									<tr>
										<th colspan="3" style="background-color: #eeeeee; text-align: center;">트리 방식을 선택하세요</th>		
									</tr>
								</thead>
								<tbody>
									<tr>
										<td colspan="1">
											<div class="form-check">
	  											<input class="form-check-input" type="radio" name="kindOfTree" value="maximumLikelihood" id="flexRadioDefault1" checked="checked">
	  											<label class="form-check-label" for="flexRadioDefault1">
	   												Maximum Likelihood
	  											</label>
											</div>
										</td>
										<td colspan="1">
											<div class="form-check">
	  											<input class="form-check-input" type="radio" name="kindOfTree" value="neighborJoining" id="flexRadioDefault1">
	  											<label class="form-check-label" for="flexRadioDefault1">
	   												Neighbor-Joining
	  											</label>
											</div>
										</td>
										<td colspan="1">
											<div class="form-check">
	  											<input class="form-check-input" type="radio" name="kindOfTree" value="upgma" id="flexRadioDefault1">
	  											<label class="form-check-label" for="flexRadioDefault1">
	   												UPGMA&emsp;&emsp;&emsp;&emsp;
	  											</label>
											</div>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
						<div class="form-group">
							<label>FASTA 포맷</label>
							<textarea name="dnaSequence" class="form-control" style="height: 180px;"></textarea>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
							<button type="button" class="btn btn-primary" onclick="initCheckbox()">전체해제</button>
							<button type="submit" class="btn btn-primary">결과보기</button>
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
	<script src="./js/getStorage.js"></script>
	<script src="./js/jquery.min.js"></script>
	<script src="./js/popper.js"></script>
	<script src="./js/bootstrap.min.js"></script>
	
</body>
</html>