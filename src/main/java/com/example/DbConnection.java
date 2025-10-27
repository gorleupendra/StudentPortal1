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
            String host = "db.rjccjgjlfzbzitxyoycr.supabase.co"; // Replace if your Session Pooler host is different
            String dbName = "postgres";      // Supabase default database name
            String user = "postgres";        // Supabase default user
            String pass = "Gupendra@2002"; // *** REPLACE THIS WITH YOUR ACTUAL SUPABASE DB PASSWORD ***
            // The JDBC URL format requires SSL for Render
            String url = "jdbc:postgresql://" + host + "/" + dbName + "?sslmode=require";
            
            con = DriverManager.getConnection(url, user, pass);
            
        } catch (ClassNotFoundException | SQLException e) {
        	System.out.println("Database connection is Failed");
            e.printStackTrace();
        }
        return con;
    }
}