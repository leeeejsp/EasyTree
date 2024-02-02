package muscle;

import java.io.File;
import java.io.FileReader;
import java.util.Scanner;

public class MuscleFiles {

	private String treeFileName;
	private String htmlFileName;
	private String treeFileContent;
	private String htmlFileContent;
	
	//�����ִ� ��� �޼ҵ���� showTree.jsp���� ����
	public String readTreeFile (String treeFileName) {
		this.treeFileName = treeFileName;
		try {
			File file = new File(treeFileName);
			FileReader fr = new FileReader(file); 
			Scanner scan = new Scanner(fr);
			String newickContent = "";
			while(scan.hasNextLine()) {
				newickContent += scan.nextLine() + "<br>";
			}
			scan.close();
			//����ǥ�� replaceAll�� showTree.jsp���� �� ��
			treeFileContent = newickContent;
			return treeFileContent;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public String readHtmlFile (String htmlFileName) {
		this.htmlFileName = htmlFileName;
		try {
			File file = new File(htmlFileName);
			FileReader fr = new FileReader(file); 
			Scanner scan = new Scanner(fr);
			String Content = "";
			while(scan.hasNextLine()) {
				Content += scan.nextLine() + "<br>";
			}
			scan.close();
			htmlFileContent = Content;
			return htmlFileContent;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public void deleteFiles() {
		try {
			File ftr = new File(treeFileName);
			if(ftr.exists()) {
				ftr.delete();
			}
			File fhl = new File(htmlFileName);
			if(fhl.exists()) {
				fhl.delete();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
}
