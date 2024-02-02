<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="sequence.SequenceDAO" %>
<%@ page import="java.io.PrintWriter" %>
<%
String adminID = null;
if(session.getAttribute("adminID") != null){
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

if(request.getParameter("dnaID") != null) {
	dnaID = request.getParameter("dnaID");
}

SequenceDAO sequenceDAO = new SequenceDAO();
	int result = sequenceDAO.delete(dnaID);
	if (result == -1) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('이미 삭제되었습니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
		
	} else {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('등록 유전자가 삭제되었습니다.');");
		script.println("location.href='adminIndex.jsp';");
		script.println("</script>");
		script.close();
		return;
	}


%>