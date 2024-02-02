<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="sequence.SequenceDAO" %>
<%@ page import="java.net.URLEncoder" %>

	<%
		String adminID = null;
		if (session.getAttribute("adminID") != null) {
			adminID = (String) session.getAttribute("adminID");
		}
		if (adminID == null) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인 후 이용가능합니다.');");
			script.println("location.href = 'admin.jsp'");
			script.println("</script>");
			return;
		}
		
		request.setCharacterEncoding("UTF-8");
		String dnaID = null;
		String treeName = null;
		String fastaCode = null;
		String fastaTitle = null;
		String dnaSequence = null;
		
		if (request.getParameter("dnaID") != null) {
			dnaID = request.getParameter("dnaID");
		}
		if (request.getParameter("treeName") != null) {
			treeName = request.getParameter("treeName");
		}
		if (request.getParameter("fastaCode") != null) {
			fastaCode = request.getParameter("fastaCode");
		}
		if (request.getParameter("fastaTitle") != null) {
			fastaTitle = request.getParameter("fastaTitle");
		}
		if (request.getParameter("dnaSequence") != null) {
			dnaSequence = request.getParameter("dnaSequence");
		}
		
		
		
		if (treeName == null || dnaSequence == null || fastaTitle == null || fastaCode == null){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('잘못된 접근 방식입니다.');");
			script.println("history.back()");
			script.println("</script>");
			return;
		}
		
		if (treeName.equals("") || dnaSequence.equals("") || fastaTitle.equals("") || fastaCode.equals("")) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('입력이 안 된 사항이 있습니다.');");
			script.println("history.back()");
			script.println("</script>");
			return;
		}
		
		SequenceDAO sequenceDAO = new SequenceDAO();
		int result = sequenceDAO.updateSequence(treeName, fastaCode, fastaTitle, dnaSequence, dnaID);
		if(result == -1){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('글수정이 실패했습니다.');");
			script.println("history.back()");
			script.println("</script>");
			return;
		} else {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('글수정이 완료되었습니다.');");
			script.println("location.href = 'adminIndex.jsp'");
			script.println("</script>");
			return;
		}	
		
		
		
	%>