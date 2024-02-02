package muscle;

import java.io.File;
import java.io.FileWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import util.DatabaseUtil;

public class Muscle {

	public long startTime;
	public long endTime;
	private String inputFileName;
	private String inputFileContent;
	private String alignmentFileName;
	private String treeFileName;
	private String htmlFileName;
	private String path = "/home/ubuntu/apache-tomcat-8.5.89/webapps/ROOT/muscle/";
			//"C:\\Users\\이종섭\\eclipse-workspace\\BioDatabese\\WebContent\\muscle\\"; //서버의 절대경로 넣어야함
	
	public void start() {
		startTime = System.currentTimeMillis(); //코드 실행 전에 시간 받아오기
	}
	
	public long waitingTime() {
		endTime = System.currentTimeMillis(); //코드 실행 후에 시간 받아오기
		return endTime - startTime;
	}
	
	
	public int createFile() { //사용자가 입력한 내용 파일로 만들기
		String SQL = "SELECT NOW(6)"; //microsecond단위 충돌방지
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				inputFileName = path + rs.getString(1).replaceAll(":","_").replaceAll(" ","_") + "_input.txt";
				alignmentFileName = path + rs.getString(1).replaceAll(":","_").replaceAll(" ","_") + "_align.txt";
				treeFileName = path + rs.getString(1).replaceAll(":","_").replaceAll(" ","_") + "_tree.txt";
				htmlFileName = path + rs.getString(1).replaceAll(":","_").replaceAll(" ","_") + "_html.txt";
				FileWriter fin = null;
				try {
					fin = new FileWriter(inputFileName);
					fin.write(inputFileContent);
					return 1; //파일 생성 성공
				} catch (Exception e) {
					e.printStackTrace();
				} finally {
					fin.close();
				}
			}
		}  catch (Exception e) {
			e.printStackTrace();
		} finally { 
			try { if(conn != null) conn.close(); } catch (Exception e) {e.printStackTrace(); }
			try { if(pstmt != null) pstmt.close(); } catch (Exception e) {e.printStackTrace(); }
			try { if(rs != null) rs.close(); } catch (Exception e) {e.printStackTrace(); }
		}
		return -1; //파일 생성 실패
	}
	
	//권한 변경 메소드
	public int toChangeMod(String filename) {
		String promptCommandLine = null;
		ProcessBuilder p;
		try {
			promptCommandLine = "chmod 777 " + filename;
			p = new ProcessBuilder(new String[] {"/bin/sh", "-c", promptCommandLine});
			Process process = p.start();
			//행(hang)이 걸려서 무한 대기하는 것을 방지하기 위해 stream을 닫아준 후 waitFor을 쓴다.
			/*process.getErrorStream().close();
			process.getInputStream().close();
			process.getOutputStream().close();*/
			process.waitFor();
			return 1;
		} catch (Exception e){
			e.printStackTrace();
		}
		return -1;
	}
	
	public int executeMuscle(String kindOfTree) { //command line 넣어서 muscle실행
		String promptCommandLine = null;
		ProcessBuilder p;
		if (kindOfTree.equals("maximumLikelihood")) {
			promptCommandLine = path + "muscle3 -in " + alignmentFileName + " -tree1 " + treeFileName + " -maxiters 1";
			try {
				p = new ProcessBuilder(new String[] {"/bin/sh", "-c", promptCommandLine});
				Process process = p.start();
				//행(hang)이 걸려서 무한 대기하는 것을 방지하기 위해 stream을 닫아준 후 waitFor을 쓴다.
				/*process.getErrorStream().close();
				process.getInputStream().close();
				process.getOutputStream().close();*/
				process.waitFor();
				return 1; 
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (kindOfTree.equals("neighborJoining")) {
			promptCommandLine = path + "muscle3 -maketree -in " + alignmentFileName + " -out " + treeFileName + " -cluster neighborjoining";
			try {
				p = new ProcessBuilder(new String[] {"/bin/sh", "-c", promptCommandLine});
				//행(hang)이 걸려서 무한 대기하는 것을 방지하기 위해 stream을 닫아준 후 waitFor을 쓴다.
				Process process = p.start();
				//행(hang)이 걸려서 무한 대기하는 것을 방지하기 위해 stream을 닫아준 후 waitFor을 쓴다.
				/*process.getErrorStream().close();
				process.getInputStream().close();
				process.getOutputStream().close();*/
				process.waitFor();
				return 1; 
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else { //UPGMA일때
			promptCommandLine = path + "muscle3 -maketree -in " + alignmentFileName + " -out " + treeFileName;
			try {
				p = new ProcessBuilder(new String[] {"/bin/sh", "-c", promptCommandLine});
				//행(hang)이 걸려서 무한 대기하는 것을 방지하기 위해 stream을 닫아준 후 waitFor을 쓴다.
				Process process = p.start();
				//행(hang)이 걸려서 무한 대기하는 것을 방지하기 위해 stream을 닫아준 후 waitFor을 쓴다.
				/*process.getErrorStream().close();
				process.getInputStream().close();
				process.getOutputStream().close();*/
				process.waitFor();
				return 1;
			} catch (Exception e) {
				e.printStackTrace();
			}
		}		
		return -1; //muscle 실패
	}
	
	public int makeHtmlFile() {
		String promptCommandLine = path + "muscle3 -in " + alignmentFileName + " -htmlout " + htmlFileName;
		ProcessBuilder p;
		try {
			p = new ProcessBuilder(new String[] {"/bin/sh", "-c", promptCommandLine});
			Process process = p.start();
			//행(hang)이 걸려서 무한 대기하는 것을 방지하기 위해 stream을 닫아준 후 waitFor을 쓴다.
			/*process.getErrorStream().close();
			process.getInputStream().close();
			process.getOutputStream().close();*/
			process.waitFor();
			return 1;		
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}

	//지금 문제 커맨드 실행이 안되는 것 같음 정렬파일이 비어있고 트리파일은 안만들어짐
	public int executeAlignment() {
		String promptCommandLine = path + "muscle5 -align " + inputFileName + " -output " + alignmentFileName;
		ProcessBuilder p;
		try {
			//p = Runtime.getRuntime().exec(new String[] {"/bin/sh", "-c", promptCommandLine});
			p = new ProcessBuilder(new String[] {"/bin/sh", "-c", promptCommandLine});
			Process process = p.start();
			//행(hang)이 걸려서 무한 대기하는 것을 방지하기 위해 stream을 닫아준 후 waitFor을 쓴다.
			/*process.getErrorStream().close();
			process.getInputStream().close();
			process.getOutputStream().close();*/
			process.waitFor();
			return 1;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	public void deleteFiles() { //모든 작업이 끝난 후 파일삭제
		try {
			File fin = new File(inputFileName);
			if(fin.exists()) {
				fin.delete();
			}
			File fal = new File(alignmentFileName);
			if(fal.exists()) {
				fal.delete();
			}
		} catch (Exception e) {
			e.printStackTrace();
		} 
	}
	
	public int getFasta(String[] tree, String dnaSequence) { //사용자가 체크한 수종 db에서 fasta포맷 가져오기
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String inputContent = null;
		String selectedContent = "";
		try {
			for(int i=0; i<tree.length; i++) {
				String treeName = tree[i];
				String SQL = "SELECT dnaSequence from DNATABLE WHERE fastaCode = ?";
				conn = DatabaseUtil.getConnection();
				pstmt = conn.prepareStatement(SQL);
				pstmt.setString(1, treeName);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					selectedContent += rs.getString(1).replaceAll("<br>","\r\n");
				}
				conn.close();
				pstmt.close();
				rs.close();
			}
			if (!dnaSequence.equals(null)) {
				inputContent = dnaSequence;
			}
			inputFileContent = selectedContent + inputContent;
			return 1; //내용합치기 성공
		} catch (Exception e) {
			e.printStackTrace();
		} finally { 
			try { if(conn != null) conn.close(); } catch (Exception e) {e.printStackTrace(); }
			try { if(pstmt != null) pstmt.close(); } catch (Exception e) {e.printStackTrace(); }
			try { if(rs != null) rs.close(); } catch (Exception e) {e.printStackTrace(); }
		}
		return -1; //데이터베이스 오류
	}
	
	//세션으로 파일이름을 보낼 것이다.
	//chmod 사용
	public String getTreeFileName() {
		return treeFileName;
	}
	public String getHtmlFileName() {
		return htmlFileName;
	}
	public String getAlignmentFileName() {
		return alignmentFileName;
	}
	public String getInputFileName() {
		return inputFileName;
	}
}
