package com.example;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DbConnection {
    public static Connection getConne() {
        Connection con = null;
        try {
            Class.forName("org.postgresql.Driver"); 
            
            // --- YOUR CORRECT RENDER DETAILS ---
            Class.forName("org.postgresql.Driver");

            String host = "dpg-d3mb0l0gjchc73d0fmbg-a.oregon-postgres.render.com";
            String dbName = "student_portal_db_4mg7";
            String user = "upendra_gorle";
            String pass = "q0uqYFBI13nMoKKTMTW1xIVciq4KHKe4"; 
            // The JDBC URL format requires SSL for Render
            String url = "jdbc:postgresql://" + host + "/" + dbName + "?sslmode=require";
            
            con = DriverManager.getConnection(url, user, pass);
            
        } catch (ClassNotFoundException | SQLException e) {
        	System.out.println("con is not connecteed");
            e.printStackTrace();
        }
        return con;
    }
}