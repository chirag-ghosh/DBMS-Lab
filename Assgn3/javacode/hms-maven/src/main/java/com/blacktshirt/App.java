package com.blacktshirt;

import java.sql.*;
import java.util.Properties;

/**
 * Hello world!
 */
public final class App {
    private App() {
    }

    /**
     * Says hello to the world.
     * @param args The arguments of the program.
     */
    public static void main(String[] args) {
        Connection conn;
        String url = "jdbc:postgresql://localhost:5432/20CS10020";
        Properties props = new Properties();
        props.setProperty("user", "invisiblehat");

        try {
            conn = DriverManager.getConnection(url, props);
            System.out.println("Database connected");

            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("SELECT * FROM physician");
            while (rs.next()) {
                System.out.print("Column 2 returned ");
                System.out.println(rs.getString(2));
            }
            rs.close();
            st.close();
        } catch (SQLException e) {
            e.printStackTrace();
            return;
        }
    }
}
