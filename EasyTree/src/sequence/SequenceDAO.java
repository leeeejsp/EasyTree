package sequence;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import util.DatabaseUtil;

public class SequenceDAO {

	//수정 완료
	public int register (SequenceDTO sequenceDTO) {
		String SQL = "INSERT INTO DNATABLE VALUES (?,?,?,?,?,?)";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, sequenceDTO.getTreeName());
			pstmt.setString(2, sequenceDTO.getFastaCode());
			pstmt.setString(3, sequenceDTO.getFastaTitle());
			pstmt.setInt(4, sequenceDTO.getDnaID());
			pstmt.setString(5, sequenceDTO.getDnaSequence().replaceAll("\r\n", "<br>") + "<br>");
			pstmt.setString(6, sequenceDTO.getRegisterDay());
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {if (conn != null) conn.close(); } catch (Exception e){e.printStackTrace();}
			try {if (pstmt != null) pstmt.close(); } catch (Exception e){e.printStackTrace();}
			try {if (rs != null) rs.close(); } catch (Exception e){e.printStackTrace();}
		}
		return -1; // 데이터베이스 오류
	}
	
	//대량 유전자 등록 메소드 구현해야함
	public String[] XMLsplit(String xmlContent) {
		String[] kindOfProtein = null;
		try {
			kindOfProtein = xmlContent.split("</TSeq>");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return kindOfProtein;
	}
	
	//대량 유전자 등록에서 시퀀스 70개마다 줄바꿈해주는 함수
	public String splitSequence(String sequence) {
		if(sequence.length() <= 70) {
			return sequence;
		}
		
		int num = 0;
		StringBuilder sb = new StringBuilder();
		char[] sequenceArray = sequence.toCharArray();
		for(int i=0; i<sequenceArray.length; i++) {
			if((num%70) == 0) {
				sb.append("<br>");
			}
			sb.append(sequenceArray[i]);
			num++;
		}
		String result = sb.toString();
		return result;
	}
	
	public String getDate() { //등록날짜 함수
		String SQL = "SELECT NOW()";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return rs.getString(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return ""; // 데이터베이스 오류
	}
	
	//수정 완료
	public int updateSequence (String treeName, String fastaCode, String fastaTitle, String dnaSequence, String dnaID) {
		String SQL = "UPDATE DNATABLE SET treeName = ?, fastaCode = ?, fastaTitle = ?, dnaSequence = ? WHERE dnaID = ?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, treeName.replaceAll("\r\n", "<br>"));
			pstmt.setString(2, fastaCode.replaceAll("\r\n", "<br>"));
			pstmt.setString(3, fastaTitle.replaceAll("\r\n", "<br>"));
			pstmt.setString(4, dnaSequence.replaceAll("\r\n", "<br>"));
			pstmt.setInt(5, Integer.parseInt(dnaID));
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {if(conn != null) conn.close(); } catch (Exception e) {e.printStackTrace();}
			try {if(pstmt != null) pstmt.close(); } catch (Exception e) {e.printStackTrace();}
			try {if(rs != null) rs.close(); } catch (Exception e) {e.printStackTrace();}		
			}
			return -1; //데이터 베이스 오류
		}
	
	public int setDnaID() {
		String SQL = "SELECT dnaID FROM DNATABLE ORDER BY dnaID DESC";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt(1)+1;
			} else {
				return 1;
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {if(conn != null) conn.close(); } catch (Exception e) {e.printStackTrace();}
			try {if(pstmt != null) pstmt.close(); } catch (Exception e) {e.printStackTrace();}
			try {if(rs != null) rs.close(); } catch (Exception e) {e.printStackTrace();}		
			}
			return -1; //데이터 베이스 오류
	}
	
	public int delete (String dnaID) {
		String SQL = "DELETE FROM DNATABLE WHERE dnaID = ?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, Integer.parseInt(dnaID));
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally { //모든 작업이 끝나면 다시 닫아주기 --> 서버에 무리 덜어줌
			try { if(conn != null) conn.close(); } catch (Exception e) {e.printStackTrace(); }
			try { if(pstmt != null) pstmt.close(); } catch (Exception e) {e.printStackTrace(); }
			try { if(rs != null) rs.close(); } catch (Exception e) {e.printStackTrace(); }
		}
		return -1; //데이터베이스 오류
	}
	
	//수정 완료
	public ArrayList<SequenceDTO> view (String dnaID) { //view페이지에서 보여주는 함수
		String SQL = "SELECT * FROM DNATABLE WHERE dnaID = ?";
		ArrayList<SequenceDTO> dnaView = null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, Integer.parseInt(dnaID));
			rs = pstmt.executeQuery();
			dnaView = new ArrayList<SequenceDTO>();
			if (rs.next()) {
				SequenceDTO viewList = new SequenceDTO(
						rs.getString(1),
						rs.getString(2),
						rs.getString(3),
						rs.getInt(4),
						rs.getString(5),
						rs.getString(6)
						);
				dnaView.add(viewList);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally { //모든 작업이 끝나면 다시 닫아주기 --> 서버에 무리 덜어줌
			try { if(conn != null) conn.close(); } catch (Exception e) {e.printStackTrace(); }
			try { if(pstmt != null) pstmt.close(); } catch (Exception e) {e.printStackTrace(); }
			try { if(rs != null) rs.close(); } catch (Exception e) {e.printStackTrace(); }
		}
		return dnaView; //아무것도 없으면 null값이 나올것임
	}
	
	
	public ArrayList<SequenceDTO> registerList () {
		String SQL = "SELECT treeName, fastaTitle,dnaID FROM DNATABLE";
		ArrayList<SequenceDTO> viewRegisterList = null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			viewRegisterList = new ArrayList<SequenceDTO>();
			while (rs.next()) {
				SequenceDTO setterList = new SequenceDTO();
				setterList.setTreeName(rs.getString(1));
				setterList.setFastaTitle(rs.getString(2));
				setterList.setDnaID(rs.getInt(3));
				viewRegisterList.add(setterList);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {if(conn != null) conn.close();} catch (Exception e) {e.printStackTrace();}
			try {if(pstmt != null) pstmt.close();} catch (Exception e) {e.printStackTrace();}
			try {if(rs != null) rs.close();} catch (Exception e) {e.printStackTrace();}
		}
		return viewRegisterList;
	}
	
	//오버로드 함수 - 검색기능 수정필요
	public ArrayList<SequenceDTO> registerList (String search, int pageNumber) {
		String SQL = "SELECT treeName, fastaCode, fastaTitle, dnaID FROM DNATABLE WHERE CONCAT(treeName, fastaCode, fastaTitle) LIKE ? ORDER BY dnaID DESC"
				+ " LIMIT " + pageNumber*20 + ", " + pageNumber*20+21;
		//한 페이지에 20개씩 보여주기
		ArrayList<SequenceDTO> viewRegisterList = null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, "%" + search + "%");
			rs = pstmt.executeQuery();
			viewRegisterList = new ArrayList<SequenceDTO>();
			while (rs.next()) {
				SequenceDTO setterList = new SequenceDTO();
				setterList.setTreeName(rs.getString(1));
				setterList.setFastaCode(rs.getString(2));
				setterList.setFastaTitle(rs.getString(3));
				setterList.setDnaID(rs.getInt(4));
				viewRegisterList.add(setterList);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {if(conn != null) conn.close();} catch (Exception e) {e.printStackTrace();}
			try {if(pstmt != null) pstmt.close();} catch (Exception e) {e.printStackTrace();}
			try {if(rs != null) rs.close();} catch (Exception e) {e.printStackTrace();}
		}
		return viewRegisterList;
	}
	
	//총 검색결과 수정완료
	public int resultCount(String search) {
		String SQL = "SELECT COUNT(*) FROM DNATABLE WHERE CONCAT(treeName, fastaCode, fastaTitle) LIKE ?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, "%" + search + "%");
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return rs.getInt(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {if(conn != null) conn.close();} catch (Exception e) {e.printStackTrace();}
			try {if(pstmt != null) pstmt.close();} catch (Exception e) {e.printStackTrace();}
			try {if(rs != null) rs.close();} catch (Exception e) {e.printStackTrace();}
		}
		return 0;
	}
	
	//총 몇 페이지까지 있는지 수정필요 한 페이지에 20개씩 보여주는 것으로 수정완료
	public int totalPage(String search) {
		String SQL = "SELECT COUNT(*) FROM DNATABLE WHERE CONCAT(treeName, fastaCode, fastaTitle) LIKE ?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, "%" + search + "%");
			rs = pstmt.executeQuery();
			if (rs.next()) {
				//여기서 5로 나누는 이유는 페이지에서 5개씩 보여주기 때문
				if (rs.getInt(1) % 20 == 0) {
					return rs.getInt(1) / 20;
				} else {
					return (rs.getInt(1) / 20) + 1;
				}
			}
			//소수형이면 올림해서 정수형으로 바꾼후 반환
			//정수형이면 바로 반환
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {if(conn != null) conn.close();} catch (Exception e) {e.printStackTrace();}
			try {if(pstmt != null) pstmt.close();} catch (Exception e) {e.printStackTrace();}
			try {if(rs != null) rs.close();} catch (Exception e) {e.printStackTrace();}
		}
		return 0;
	}
	
	//페이지에서 >>누르면 몇 페이지로 갈건지 수정필요 한 페이지에 20개씩
	public int groupNumber (int pageNumber, int totalPage) {
		try {
			//숫자페이지를 10개씩 보여줄 것임.
			for (int i=1; i <= (totalPage / 10) + 1; i++) {
				//res1과 res2는 실제 그룹넘버의 pageNumber 범위
				int res1 = (10 * i) - 10;
				int res2 = (10 * i) - 1;
				if ( res1 <= pageNumber && pageNumber <= res2) {
					return (10 * i) - 9; // 그룹넘버값
					//그룹넘버값이 1이면 pageNumber가 0 ~ 9에 속한다는 뜻
				}
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return 0;
	}
}
