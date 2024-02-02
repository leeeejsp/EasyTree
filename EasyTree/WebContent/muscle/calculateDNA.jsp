<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="muscle.Muscle" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.io.PrintWriter" %>
<%
	request.setCharacterEncoding("UTF-8");
	String[] tree = null;
	String dnaSequence = null;
	String kindOfTree = null;
	
	if(request.getParameter("trees") != null) {
		String trees = request.getParameter("trees");
		tree = trees.split(",");
	}
	
	if(request.getParameter("dnaSequence") != null) {
		dnaSequence = request.getParameter("dnaSequence");
		dnaSequence.replaceAll("\\(","\\[").replaceAll("\\)","\\]").replaceAll(",","_").replaceAll(";","").replaceAll("'","").replaceAll("<br>","\r\n");
	}
	if(request.getParameter("kindOfTree") != null) {
		kindOfTree = request.getParameter("kindOfTree");
	}
	
	//dnaSequence는 널값이어도 상관없이 결과를 보여줄 수 있도록 하자
	if(tree == null) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('2개 이상 체크해주세요.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
	
	if(kindOfTree == null) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('트리방식을 체크해주세요.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
	
	Muscle muscle = new Muscle();
	muscle.start();
	int fastaResult = muscle.getFasta(tree, dnaSequence);
	if (fastaResult == -1) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('데이터베이스 오류가 발생했습니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	} 
	int fileResult = muscle.createFile();
	if (fileResult == -1){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('파일 생성이 실패했습니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
		
	//input파일 권한 변경 777
	String inputfile = muscle.getInputFileName();
	int inputChmod = muscle.toChangeMod(inputfile);
	if (inputChmod == -1){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('input파일 권한 변경을 실패했습니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
	
	//정렬실행
	int alignResult = muscle.executeAlignment();
	if (alignResult == -1){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('정렬을 실패했습니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	} 
	
	//align파일 권한 변경 777
	String alignfile = muscle.getAlignmentFileName();
	int alignChmod = muscle.toChangeMod(alignfile);
	if (alignChmod == -1){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('align파일 권한 변경을 실패했습니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
	
	//html 파일 만들기
	int htmlResult = muscle.makeHtmlFile();
	if (htmlResult == -1){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('html생성을 실패했습니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
	
	//html파일 권한변경 777
	String htmlfile = muscle.getHtmlFileName();
	int htmlChmod = muscle.toChangeMod(htmlfile);
	if (htmlChmod == -1){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('html파일 권한 변경을 실패했습니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
	
	//tree파일 만들기
	int treeResult = muscle.executeMuscle(kindOfTree);
	if (treeResult == -1){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('트리파일생성을 실패했습니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
	
	//tree파일 권한변경 777
	String treefile = muscle.getTreeFileName();
	int treeChmod = muscle.toChangeMod(treefile);
	if (treeChmod == -1){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('트리파일 권한 변경을 실패했습니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
	
	//트리파일까지 생성완료
	long waitTime = muscle.waitingTime();
	session.setAttribute("waitTime",waitTime);
	session.setAttribute("treeFileName", treefile);
	session.setAttribute("htmlFileName", htmlfile);
	session.setAttribute("kindOfTree", kindOfTree);
	muscle.deleteFiles();
	PrintWriter script = response.getWriter();
	script.println("<script>");
	script.println("location.href='../user/showTree.jsp';");
	script.println("</script>");
	script.close();
	return;

%>