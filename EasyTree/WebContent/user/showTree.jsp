<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="sequence.SequenceDAO" %>
<%@ page import="sequence.SequenceDTO" %>
<%@ page import="muscle.MuscleFiles" %>
<!DOCTYPE html>
<html>
<%
	request.setCharacterEncoding("UTF-8");

	String treeFileName = null;
	String newickContent = null;
	String downloadNewick = null;
	String kindOfTree = null;
	String htmlFileName = null;
	String htmlContent = null;
	String result = null;
	long waitTime = 0L;

	if (session.getAttribute("treeFileName") != null){
		treeFileName = (String) session.getAttribute("treeFileName");
	}
	if (session.getAttribute("htmlFileName") != null){
		htmlFileName = (String) session.getAttribute("htmlFileName");
	}
	if (session.getAttribute("kindOfTree") != null){
		kindOfTree = (String) session.getAttribute("kindOfTree");
	}
	if (session.getAttribute("waitTime") != null){
		waitTime = (long) session.getAttribute("waitTime");
	}
	
	MuscleFiles muscleFiles = new MuscleFiles();
	htmlContent = muscleFiles.readHtmlFile(htmlFileName);
	newickContent = muscleFiles.readTreeFile(treeFileName);
	muscleFiles.deleteFiles();
	//뉴윅형식은 트리 밑에 따로 보여준다.
	
	if(newickContent != null){
		result = "'" + newickContent.replaceAll("<br>","") + ";'";
		downloadNewick = "'" + newickContent.replaceAll("<br>","") + "'";
	}
	
	session.invalidate();
	
	if (treeFileName == null || kindOfTree == null || htmlFileName == null) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('메인 화면에서 다시 트리보기를 해주세요.');");
		script.println("location.href='../index.jsp';");
		script.println("</script>");
		script.close();
		return;
	}
%>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<title>EasyTree</title>
	<link rel="stylesheet" href="../css/bootstrap.min.css">
	<link rel="stylesheet" href="../css/custom.css">
	<script type="text/javascript" src="../js/raphael-min.js" ></script> 
	<script type="text/javascript" src="../js/jsphylosvg-min.js@1.29"></script> 
	<script type="text/javascript">
	window.onload = function(){
			var dataObject = { newick: <%= result%> };
			phylocanvas = new Smits.PhyloCanvas(
				dataObject,
				'svgCanvas',
				500,
				500
			);
	};
	</script>
</head>
<body>
	<nav class="navbar navbar-expand-lg navbar-light bg-light">
		<a class="navbar-brand" href="../index.jsp">EasyTree</a>
		<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbar">
			<span class="navbar-toggler-icon"></span>
		</button>
		<div id="navbar" class="collapse navbar-collapse">
			<ul class="navbar-nav mr-auto">
				<li class="nav-item active">
					<a class="nav-link" href="../index.jsp">메인</a>
				</li>
				<li class="nav-item active">
					<a class="nav-link">사용자 페이지</a>
				</li>
			</ul>
			<form class="form-inline my-2 my-lg-0" method="get" action="https://ncbi.nlm.nih.gov/search/all/">
				<input name="term" class="form-control mr-sm-2" type="search" placeholder="내용을 입력하세요." aria-label="Search">
				<button class="btn btn-outline-success my-2 my-sm-0" type="submit">검색</button>
			</form>
		</div>
	</nav>
	<section class="container">
		<form method="get" action="../index.jsp" class="form-inline mt-3 mb-3">
			<input style="width:60%;" type="text" name="search" class="form-control mx-1 mt-2" placeholder="내용을 입력하세요." >
			<button type="submit" class="btn btn-primary mx-1 mt-2">검색</button>
			<a class="btn btn-primary mx-1 mt-2" data-toggle="modal" href="#alignmentModal">정렬결과</a>
		</form>
	<div class="container">
		<div class="row">
				<table class="table table" style="text-align: center; border: 1px solid #dddddd;">
					<thead>
						<tr>
							<th colspan="3" style="background-color: #eeeeee; text-align: center;">Phylogenetic Tree&nbsp;<small>&lt;<%= kindOfTree %>&gt;</small></th>		
						</tr>
					</thead>
					<tbody>
						<tr>
							<td id="svgCanvas" colspan="3" style="height: 200px; text-align: center;">
							</td>
						</tr>
						<tr>
							<td colspan="3" style="background-color: #eeeeee; text-align: center;"><strong>Newick format</strong></td>
						</tr>
						<tr>
							<td colspan="3" style="height: 100px; text-align: left;">
								<%= newickContent %>
							</td>
						</tr>
						<tr>
							<td colspan="3" style="height: 100px; text-align: left;">
								실행시간 : <%= waitTime %>ms
							</td>
						</tr>
					</tbody>		
				</table>
				<a href="../index.jsp" class="btn btn-primary">메인</a>
				<a href="" id="downloadLink" download="newickFormatFile.txt" class="btn btn-primary mx-2">Newick format 다운로드</a>
		</div>
	</div>
	</section>
	<div class="modal fade" id="alignmentModal" tabindex="-1" role="dialog" aria-labelledby="modal" aria-hidden="true">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="modal">정렬결과</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<%= htmlContent %>
				</div>
			</div>
		</div>
	</div>
	<footer class="bg-dark mt-4 p-5 text-center" style="color: #FFFFFF;">
		제작자 : 이종섭<p>
		제작자 이메일 : leeeejsp@gmail.com / whdtjq1gh@naver.com<br>
		제작자 블로그 : leeeejsp.tistory.com
	</footer>
	<script type="text/javascript">
		var newickFileContent = <%= downloadNewick%>;
		var urlEncodedData = 'data:application/text;charset=utf-8,' + encodeURIComponent(newickFileContent);
		document.getElementById("downloadLink").setAttribute('href',urlEncodedData);	
	</script>
	<script src="../js/jquery.min.js"></script>
	<script src="../js/popper.js"></script>
	<script src="../js/bootstrap.min.js"></script>
	<!-- muscle program 
@article{edgar2021muscle,title={MUSCLE v5 enables improved estimates of phylogenetic tree confidence by ensemble bootstrapping},author={Edgar, Robert C},journal={bioRxiv},year={2021},publisher={Cold Spring Harbor Laboratory}}
https://drive5.com/muscle5/manual/topics.html-->


<!--jsphylosvg-min.js@1.29
	raphael-min.js 
https://github.com/guyleonard/jsPhyloSVG
Smits SA, Ouverney CC, 2010. jsPhyloSVG: A Javascript Library for Visualizing Interactive and Vector-Based Phylogenetic Trees on the Web. PLoS ONE 5(8): e12267. doi:10.1371/journal.pone.0012267
-->
	
</body>
</html>