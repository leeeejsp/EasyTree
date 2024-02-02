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
			//"C:\\Users\\������\\eclipse-workspace\\BioDatabese\\WebContent\\muscle\\"; //������ ������ �־����
	
	public void start() {
		startTime = System.currentTimeMillis(); //�ڵ� ���� ���� �ð� �޾ƿ���
	}
	
	public long waitingTime() {
		endTime = System.currentTimeMillis(); //�ڵ� ���� �Ŀ� �ð� �޾ƿ���
		return endTime - startTime;
	}
	
	
	public int createFile() { //����ڰ� �Է��� ���� ���Ϸ� �����
		String SQL = "SELECT NOW(6)"; //microsecond���� �浹����
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
					return 1; //���� ���� ����
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
		return -1; //���� ���� ����
	}
	
	//���� ���� �޼ҵ�
	public int toChangeMod(String filename) {
		String promptCommandLine = null;
		ProcessBuilder p;
		try {
			promptCommandLine = "chmod 777 " + filename;
			p = new ProcessBuilder(new String[] {"/bin/sh", "-c", promptCommandLine});
			Process process = p.start();
			//��(hang)�� �ɷ��� ���� ����ϴ� ���� �����ϱ� ���� stream�� �ݾ��� �� waitFor�� ����.
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
	
	public int executeMuscle(String kindOfTree) { //command line �־ muscle����
		String promptCommandLine = null;
		ProcessBuilder p;
		if (kindOfTree.equals("maximumLikelihood")) {
			promptCommandLine = path + "muscle3 -in " + alignmentFileName + " -tree1 " + treeFileName + " -maxiters 1";
			try {
				p = new ProcessBuilder(new String[] {"/bin/sh", "-c", promptCommandLine});
				Process process = p.start();
				//��(hang)�� �ɷ��� ���� ����ϴ� ���� �����ϱ� ���� stream�� �ݾ��� �� waitFor�� ����.
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
				//��(hang)�� �ɷ��� ���� ����ϴ� ���� �����ϱ� ���� stream�� �ݾ��� �� waitFor�� ����.
				Process process = p.start();
				//��(hang)�� �ɷ��� ���� ����ϴ� ���� �����ϱ� ���� stream�� �ݾ��� �� waitFor�� ����.
				/*process.getErrorStream().close();
				process.getInputStream().close();
				process.getOutputStream().close();*/
				process.waitFor();
				return 1; 
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else { //UPGMA�϶�
			promptCommandLine = path + "muscle3 -maketree -in " + alignmentFileName + " -out " + treeFileName;
			try {
				p = new ProcessBuilder(new String[] {"/bin/sh", "-c", promptCommandLine});
				//��(hang)�� �ɷ��� ���� ����ϴ� ���� �����ϱ� ���� stream�� �ݾ��� �� waitFor�� ����.
				Process process = p.start();
				//��(hang)�� �ɷ��� ���� ����ϴ� ���� �����ϱ� ���� stream�� �ݾ��� �� waitFor�� ����.
				/*process.getErrorStream().close();
				process.getInputStream().close();
				process.getOutputStream().close();*/
				process.waitFor();
				return 1;
			} catch (Exception e) {
				e.printStackTrace();
			}
		}		
		return -1; //muscle ����
	}
	
	public int makeHtmlFile() {
		String promptCommandLine = path + "muscle3 -in " + alignmentFileName + " -htmlout " + htmlFileName;
		ProcessBuilder p;
		try {
			p = new ProcessBuilder(new String[] {"/bin/sh", "-c", promptCommandLine});
			Process process = p.start();
			//��(hang)�� �ɷ��� ���� ����ϴ� ���� �����ϱ� ���� stream�� �ݾ��� �� waitFor�� ����.
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

	//���� ���� Ŀ�ǵ� ������ �ȵǴ� �� ���� ���������� ����ְ� Ʈ�������� �ȸ������
	public int executeAlignment() {
		String promptCommandLine = path + "muscle5 -align " + inputFileName + " -output " + alignmentFileName;
		ProcessBuilder p;
		try {
			//p = Runtime.getRuntime().exec(new String[] {"/bin/sh", "-c", promptCommandLine});
			p = new ProcessBuilder(new String[] {"/bin/sh", "-c", promptCommandLine});
			Process process = p.start();
			//��(hang)�� �ɷ��� ���� ����ϴ� ���� �����ϱ� ���� stream�� �ݾ��� �� waitFor�� ����.
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
	
	public void deleteFiles() { //��� �۾��� ���� �� ���ϻ���
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
	
	public int getFasta(String[] tree, String dnaSequence) { //����ڰ� üũ�� ���� db���� fasta���� ��������
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
			return 1; //������ġ�� ����
		} catch (Exception e) {
			e.printStackTrace();
		} finally { 
			try { if(conn != null) conn.close(); } catch (Exception e) {e.printStackTrace(); }
			try { if(pstmt != null) pstmt.close(); } catch (Exception e) {e.printStackTrace(); }
			try { if(rs != null) rs.close(); } catch (Exception e) {e.printStackTrace(); }
		}
		return -1; //�����ͺ��̽� ����
	}
	
	//�������� �����̸��� ���� ���̴�.
	//chmod ���
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
