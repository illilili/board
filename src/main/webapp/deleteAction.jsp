<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.sql.DriverManager"%>
<%
String dbDriver = "com.mysql.jdbc.Driver";
String jdbcUrl = "jdbc:mysql://192.168.50.52:3306/board";
String jdbcUsername = "NULL";
String jdbcPassword = "0000";

Connection conn = null;
PreparedStatement pstmt = null;

try {
    Class.forName(dbDriver);
    conn = DriverManager.getConnection(jdbcUrl, jdbcUsername, jdbcPassword);

    int bno = Integer.parseInt(request.getParameter("bno"));

    // 게시글 삭제 쿼리
    String deleteSql = "DELETE FROM board WHERE bno = ?";
    pstmt = conn.prepareStatement(deleteSql);
    pstmt.setInt(1, bno);
    pstmt.executeUpdate();

    response.sendRedirect("index.jsp"); // 삭제 후 index.jsp로 리다이렉트

} catch (Exception e) {
    e.printStackTrace();
} finally {
    try {
        if (pstmt != null)
            pstmt.close();
        if (conn != null)
            conn.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
}
%>
