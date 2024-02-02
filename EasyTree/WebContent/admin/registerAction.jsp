<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="sequence.SequenceDAO" %>
<%@ page import="sequence.SequenceDTO" %>
<%@ page import="java.io.PrintWriter" %>
<%
	request.setCharacterEncoding("UTF-8");
	String adminID = null;
	
	if (session.getAttribute("adminID") != null) {
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
	
	String treeName = null;
	String fastaCode = null;
	String dnaSequence = null;
	String fastaTitle = null;
	
	if(request.getParameter("treeName") != null) {
		treeName = request.getParameter("treeName");
	}
	if(request.getParameter("fastaCode") != null) {
		fastaCode = request.getParameter("fastaCode");
	}
	if(request.getParameter("fastaTitle") != null) {
		fastaTitle = request.getParameter("fastaTitle");
		fastaTitle = fastaTitle.replaceAll("\\(","\\[").replaceAll("\\)","\\]").replaceAll(",","_").replaceAll(";","").replaceAll("'","");
	}
	if(request.getParameter("dnaSequence") != null) {
		dnaSequence = request.getParameter("dnaSequence");
		dnaSequence = dnaSequence.replaceAll("\\(","\\[").replaceAll("\\)","\\]").replaceAll(",","_").replaceAll(";","").replaceAll("'","");
	}
	
	if(treeName == null || dnaSequence == null || fastaTitle == null || fastaCode == null) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('잘못된 접근 방식입니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
	
	if(treeName.equals("") || dnaSequence.equals("") || fastaTitle.equals("") || fastaCode.equals("")) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('입력이 안 된 사항이 있습니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
	
	SequenceDAO sequenceDAO = new SequenceDAO();
	SequenceDTO sequenceDTO = new SequenceDTO(treeName, fastaCode, fastaTitle, sequenceDAO.setDnaID() , dnaSequence, sequenceDAO.getDate());
	int result = sequenceDAO.register (sequenceDTO);
	if (result == -1) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('데이터 베이스 오류가 발생했습니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
		
	} else {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('등록이 완료되었습니다.');");
		script.println("location.href='adminIndex.jsp';");
		script.println("</script>");
		script.close();
		return;
	}

%>