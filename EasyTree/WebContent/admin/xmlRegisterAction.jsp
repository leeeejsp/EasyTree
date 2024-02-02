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
	
	String xmlContent = null;
	
	if(request.getParameter("xmlContent") != null) {
		xmlContent = request.getParameter("xmlContent");		
	}
	
	if(xmlContent == null) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('잘못된 접근 방식입니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
	
	if(xmlContent.equals("")) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('입력이 안 된 사항이 있습니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
	
	//여기에 대량 등록 로직 구현
	SequenceDAO sequenceDAO = new SequenceDAO();
	String[] kindOfProtein = sequenceDAO.XMLsplit(xmlContent);
	if (kindOfProtein != null){
		for(int i=0; i<kindOfProtein.length; i++){
			String protein = kindOfProtein[i];
			if (protein.contains("</TSeqSet>")){
				break;
			}
			String treeName = protein.split("</TSeq_orgname>")[0].split("<TSeq_orgname>")[1];
			if (treeName.equals("unidentified plant")){
				continue;
			}
			String fastaCode = protein.split("</TSeq_accver>")[0].split("<TSeq_accver>")[1];
			String fastaTitle = protein.split("</TSeq_defline>")[0].split("<TSeq_defline>")[1].replaceAll("\\(","\\[").replaceAll("\\)","\\]").replaceAll(",","_").replaceAll(";","").replaceAll("'","");
			String sequence = protein.split("</TSeq_sequence>")[0].split("<TSeq_sequence>")[1].replaceAll("\r\n", "");
			String newSequence = sequenceDAO.splitSequence(sequence);
			String dnaSequence = ">" + fastaCode + " " + fastaTitle + "<br>" + newSequence + "<br>";
			int dnaID = sequenceDAO.setDnaID();
			String date = sequenceDAO.getDate();
			SequenceDTO sequenceDTO = new SequenceDTO(treeName, fastaCode, fastaTitle, dnaID , dnaSequence, date);
			int result = sequenceDAO.register (sequenceDTO);
			/* 주석처리를 해줌으로 인해 이미 db에 있는 내용이면 건너뛰게 된다.
			if (result == -1) {
				//DB에 이미 있는 내용이면 데이터베이스 오류가 발생
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('데이터 베이스 오류가 발생했습니다.');");
				script.println("history.back();");
				script.println("</script>");
				script.close();
				return;
				
			}
			*/
		}
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('등록이 완료되었습니다.');");
		script.println("location.href='adminIndex.jsp';");
		script.println("</script>");
		script.close();
		return;
	}
	
%>