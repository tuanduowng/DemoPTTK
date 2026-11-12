package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public abstract class DAO implements AutoCloseable {

    protected Connection conn;

    private static final String URL
            = "jdbc:mysql://127.0.0.1:3306/cinema_management"
            + "?useSSL=false"
            + "&serverTimezone=Asia/Ho_Chi_Minh"
            + "&allowPublicKeyRetrieval=true";

    private static final String USER = "root";
    private static final String PASSWORD = "123456";

    protected DAO() throws SQLException {

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException(
                    "Khong tim thay MySQL JDBC Driver!", e
            );
        }

        conn = DriverManager.getConnection(URL, USER, PASSWORD);
    }

    @Override
    public void close() throws SQLException {
        if (conn != null && !conn.isClosed()) {
            conn.close();
        }
    }
}
