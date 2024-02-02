package sequence;

public class SequenceDTO {
	
	String treeName;
	String fastaCode;
	String fastaTitle;
	int dnaID;
	String dnaSequence;
	String registerDay;
	
	public String getTreeName() {
		return treeName;
	}

	public void setTreeName(String treeName) {
		this.treeName = treeName;
	}

	public String getFastaCode() {
		return fastaCode;
	}

	public void setFastaCode(String fastaCode) {
		this.fastaCode = fastaCode;
	}

	public String getFastaTitle() {
		return fastaTitle;
	}

	public void setFastaTitle(String fastaTitle) {
		this.fastaTitle = fastaTitle;
	}

	public int getDnaID() {
		return dnaID;
	}

	public void setDnaID(int dnaID) {
		this.dnaID = dnaID;
	}

	public String getDnaSequence() {
		return dnaSequence;
	}

	public void setDnaSequence(String dnaSequence) {
		this.dnaSequence = dnaSequence;
	}

	public String getRegisterDay() {
		return registerDay;
	}

	public void setRegisterDay(String registerDay) {
		this.registerDay = registerDay;
	}

	public SequenceDTO() {
		
	}
	
	public SequenceDTO(String treeName, String fastaCode, String fastaTitle, int dnaID, String dnaSequence, String registerDay) {	
		
		this.treeName = treeName;
		this.fastaCode = fastaCode;
		this.fastaTitle = fastaTitle;
		this.dnaID = dnaID;
		this.dnaSequence = dnaSequence;
		this.registerDay = registerDay;
		
	}
	
	
}
