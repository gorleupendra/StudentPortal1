package com.example;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DbConnection {
    public static Connection getConne() {
        Connection con = null;
        try {
            // Load the PostgreSQL driver
            Class.forName("org.postgresql.Driver");

            // --- Hardcoded Render Connection Details (FOR TESTING ONLY) ---
            String host =System.getenv("RENDER-DB-HOST"); // Render Internal Hostname
            String dbName = "student_portal_db_4mg7";     // Render DB Name
            String user = "upendra_gorle";             // Render DB User
            String pass =System.getenv("RENDER_DB_PASSWORD"); // Render DB Password (REMOVE BEFORE COMMIT/DEPLOY)

            // --- Input Validation (Less critical with hardcoded values, but good practice) ---
            // (Removed checks for null/empty as they are hardcoded now)

            // --- Construct the JDBC URL ---
            // NOTE: Render internal connections might NOT require SSL.
            // If you get SSL errors, try removing "?sslmode=require" when running ON Render.
            // External connections (like from your local machine) DO require SSL.
            String url = "jdbc:postgresql://" + host + ":5432/" + dbName + "?sslmode=require";
            // Establish the connection
            con = DriverManager.getConnection(url, user, pass);

        } catch (ClassNotFoundException e) {
            System.err.println("Database connection failed: PostgreSQL Driver not found.");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("Database connection failed: SQL Exception.");
            e.printStackTrace(); // This will show details like "Connection refused", "Authentication failed", "SSL required" etc.
        } catch (Exception e) { // Catch any other unexpected errors
            System.err.println("Database connection failed: An unexpected error occurred.");
            e.printStackTrace();
        }
        if(con==null) {System.err.println("Connection object is null after attempting connection.");} // Changed to System.err
        return con;
    }
}