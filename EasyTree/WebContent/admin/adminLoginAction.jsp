<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="admin.AdminDAO" %>
<%@ page import="java.io.PrintWriter" %>
<%
request.setCharacterEncoding("UTF-8");
String adminID = null;
String adminPassword = null;

if(request.getParameter("adminID") != null) {
	adminID = request.getParameter("adminID");
}
if(request.getParameter("adminPassword") != null) {
	adminPassword = request.getParameter("adminPassword");
}

if(adminID == null || adminPassword == null ||
adminID.equals("") || adminPassword.equals("")) {
	PrintWriter script = response.getWriter();
	script.println("<script>");
	script.println("alert('입력이 안 된 사항이 있습니다.');");
	script.println("history.back();");
	script.println("</script>");
	script.close();
	return;
}
AdminDAO adminDAO = new AdminDAO();
int result = adminDAO.login(adminID, adminPassword);
if (result == -2) {
	PrintWriter script = response.getWriter();
	script.println("<script>");
	script.println("alert('데이터베이스 오류가 발생했습니다.');");
	script.println("history.back();");
	script.println("</script>");
	script.close();
	return;
	
} else if (result == 1){
	session.setAttribute("adminID", adminID);
	PrintWriter script = response.getWriter();
	script.println("<script>");
	script.println("alert('로그인이 성공하였습니다.');");
	script.println("location.href='adminIndex.jsp';");
	script.println("</script>");
	script.close();
	return;
} else if (result == 0){
	PrintWriter script = response.getWriter();
	script.println("<script>");
	script.println("alert('비밀번호가 일치하지 않습니다.');");
	script.println("history.back();");
	script.println("</script>");
	script.close();
	return;
} else if (result == -1){
	PrintWriter script = response.getWriter();
	script.println("<script>");
	script.println("alert('아이디가 존재하지 않습니다.');");
	script.println("history.back();");
	script.println("</script>");
	script.close();
	return;
}

%>