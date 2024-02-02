package admin;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import util.DatabaseUtil;

public class AdminDAO {

	public int login(String adminID, String adminPassword) {
		String SQL = "SELECT adminPassword FROM ADMIN WHERE adminID = ?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, adminID);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				if (rs.getString(1).equals(adminPassword)) {
					return 1; //로그인 성공
				}else {
					return 0; //비밀번호 일치하지 않음
				}
			}else {
				return -1; //아이디가 없음
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {if (conn != null) conn.close(); } catch (Exception e){e.printStackTrace();}
			try {if (pstmt != null) pstmt.close(); } catch (Exception e){e.printStackTrace();}
			try {if (rs != null) rs.close(); } catch (Exception e){e.printStackTrace();}
		}
		
		return -2; //데이터베이스 오류
	}	
	
	public int passwordCheck(String adminPassword) {
		String SQL = "SELECT adminPassword FROM ADMIN WHERE adminPassword = ?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, adminPassword);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return 1; //비밀번호가 일치함
			} else {
				return -1; //비밀번호가 일치하지 않음
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {if (conn != null) conn.close(); } catch (Exception e){e.printStackTrace();}
			try {if (pstmt != null) pstmt.close(); } catch (Exception e){e.printStackTrace();}
			try {if (rs != null) rs.close(); } catch (Exception e){e.printStackTrace();}
		}
		
		return -2; //데이터베이스 오류
	}
	
	
	public int updatePassword (String adminPassword, String newAdminPassword, String newAdminPasswordConfirm) {
		String SQL = "UPDATE ADMIN SET adminPassword = ? WHERE adminPassword = ?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			if (newAdminPassword.equals(newAdminPasswordConfirm)) {
				conn = DatabaseUtil.getConnection();
				pstmt = conn.prepareStatement(SQL);
				pstmt.setString(1, newAdminPassword);
				pstmt.setString(2, adminPassword);
				return pstmt.executeUpdate();
			} else {
				return -1; //새 비밀번호가 일치하지 않음
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {if(conn != null) conn.close(); } catch (Exception e) {e.printStackTrace();}
			try {if(pstmt != null) pstmt.close(); } catch (Exception e) {e.printStackTrace();}
			try {if(rs != null) rs.close(); } catch (Exception e) {e.printStackTrace();}		
			}
			return -2; //데이터 베이스 오류
		}
	
}
