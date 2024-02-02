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
					return 1; //�α��� ����
				}else {
					return 0; //��й�ȣ ��ġ���� ����
				}
			}else {
				return -1; //���̵� ����
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {if (conn != null) conn.close(); } catch (Exception e){e.printStackTrace();}
			try {if (pstmt != null) pstmt.close(); } catch (Exception e){e.printStackTrace();}
			try {if (rs != null) rs.close(); } catch (Exception e){e.printStackTrace();}
		}
		
		return -2; //�����ͺ��̽� ����
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
				return 1; //��й�ȣ�� ��ġ��
			} else {
				return -1; //��й�ȣ�� ��ġ���� ����
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {if (conn != null) conn.close(); } catch (Exception e){e.printStackTrace();}
			try {if (pstmt != null) pstmt.close(); } catch (Exception e){e.printStackTrace();}
			try {if (rs != null) rs.close(); } catch (Exception e){e.printStackTrace();}
		}
		
		return -2; //�����ͺ��̽� ����
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
				return -1; //�� ��й�ȣ�� ��ġ���� ����
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {if(conn != null) conn.close(); } catch (Exception e) {e.printStackTrace();}
			try {if(pstmt != null) pstmt.close(); } catch (Exception e) {e.printStackTrace();}
			try {if(rs != null) rs.close(); } catch (Exception e) {e.printStackTrace();}		
			}
			return -2; //������ ���̽� ����
		}
	
}
