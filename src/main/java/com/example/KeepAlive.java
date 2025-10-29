package com.example;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

public class KeepAlive {

    public static void main(String[] args) {
        System.out.println("Starting Supabase keep-alive check...");

        // 1. Read Environment Variables
        String host = System.getenv("SUPABASE_DB_HOST");
        String pass = System.getenv("SUPABASE_DB_PASSWORD");
        String user ="postgres.rjccjgjlfzbzitxyoycr"; // The user from your screenshot

        // 2. Validate Variables
        if (host == null || pass == null || user == null || 
            host.trim().isEmpty() || pass.trim().isEmpty() || user.trim().isEmpty()) {
            
            System.err.println("Error: Missing SUPABASE_DB_HOST, SUPABASE_DB_PASSWORD, or SUPABASE_DB_USER environment variables.");
            System.exit(1); // Exit with a failure code
        }

        // 3. Construct the JDBC URL
        String url = "jdbc:postgresql://" + host + ":5432/postgres?sslmode=require";
        
        Connection conn = null;
        Statement stmt = null;

        try {
            // 4. Load the Driver
            Class.forName("org.postgresql.Driver");

            // 5. Connect to the database
            System.out.println("Attempting connection to " + host + "...");
            conn = DriverManager.getConnection(url, user, pass);

            // 6. Execute a simple query to create "activity"
            stmt = conn.createStatement();
            stmt.execute("SELECT 1;"); // The simplest possible "activity"

            System.out.println("Database ping successful. Connection OK.");

        } catch (Exception e) {
            System.err.println("Database keep-alive check FAILED.");
            e.printStackTrace();
            System.exit(1); // Exit with a failure code
            
        } finally {
            // 7. Clean up resources
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                // Ignore cleanup errors
            }
        }

        System.out.println("Keep-alive check finished successfully.");
        System.exit(0); // Explicitly exit with a success code
    }
}