<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="admin.AdminDAO" %>
<%@ page import="java.io.PrintWriter" %>
<%
request.setCharacterEncoding("UTF-8");

String adminPassword = null;
String newAdminPassword = null;
String newAdminPasswordConfirm = null;

if(request.getParameter("adminPassword") != null) {
	adminPassword = request.getParameter("adminPassword");
}
if(request.getParameter("newAdminPassword") != null) {
	newAdminPassword = request.getParameter("newAdminPassword");
}
if(request.getParameter("newAdminPasswordConfirm") != null) {
	newAdminPasswordConfirm = request.getParameter("newAdminPasswordConfirm");
}

if(newAdminPassword == null || adminPassword == null || newAdminPasswordConfirm == null ||
newAdminPassword.equals("") || adminPassword.equals("") || newAdminPasswordConfirm.equals("")) {
	PrintWriter script = response.getWriter();
	script.println("<script>");
	script.println("alert('입력이 안 된 사항이 있습니다.');");
	script.println("history.back();");
	script.println("</script>");
	script.close();
	return;
}
AdminDAO adminDAO = new AdminDAO();
int check = adminDAO.passwordCheck(adminPassword);
if (check == 1) { //비밀번호가 일치할 때
	int result = adminDAO.updatePassword(adminPassword, newAdminPassword, newAdminPasswordConfirm);
	if (result == -1){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('새 비밀번호가 일치하지 않습니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	} else if (result == -2) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('데이터베이스 오류입니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	} else {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('수정이 완료되었습니다.');");
		script.println("location.href='admin.jsp'");
		script.println("</script>");
		script.close();
		return;
	}
	
} else if (check == -1){
	PrintWriter script = response.getWriter();
	script.println("<script>");
	script.println("alert('비밀번호가 일치하지 않습니다.');");
	script.println("history.back();");
	script.println("</script>");
	script.close();
	return;
} else {
	PrintWriter script = response.getWriter();
	script.println("<script>");
	script.println("alert('데이터베이스 오류입니다.');");
	script.println("history.back();");
	script.println("</script>");
	script.close();
	return;
}

%>