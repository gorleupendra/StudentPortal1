package com.example;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DbConnection {
    public static Connection getConne() {
        Connection con = null;
        try {
            // Load the PostgreSQL driver (only needs to be done once)
            Class.forName("org.postgresql.Driver");

            // --- Supabase Connection Details ---
            String host = System.getenv("SUPABASE_DB_HOST"); // Read host from environment variable
            String dbName = "postgres";                      // Supabase default database name
            String user = "postgres.rjccjgjlfzbzitxyoycr";                        // Supabase default user

            // Read password securely from environment variable
            String pass = System.getenv("SUPABASE_DB_PASSWORD");

            // --- Input Validation ---
            if (host == null || host.trim().isEmpty()) {
                System.err.println("Database connection failed: SUPABASE_DB_HOST environment variable not set or empty.");
                return null; // Exit if host is missing
            }
            if (pass == null || pass.trim().isEmpty()) {
                System.err.println("Database connection failed: SUPABASE_DB_PASSWORD environment variable not set or empty.");
                return null; // Exit if password is missing
            }

            // Construct the JDBC URL (ensure SSL mode is required for Supabase/Render)
            // Using port 5432 for Session Pooler (IPv4 compatible for Render)
            String url = "jdbc:postgresql://" + host + ":5432/" + dbName + "?sslmode=require";
            // System.out.println("Attempting to connect to: " + url + " with user: " + user); // Debugging line (optional)

            // Establish the connection
            con = DriverManager.getConnection(url, user, pass);
            // System.out.println("Database connection successful!"); // Success message (optional)

        } catch (ClassNotFoundException e) {
            System.err.println("Database connection failed: PostgreSQL Driver not found.");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("Database connection failed: SQL Exception.");
            e.printStackTrace();
        } catch (Exception e) { // Catch any other unexpected errors
            System.err.println("Database connection failed: An unexpected error occurred.");
            e.printStackTrace();
        }
        return con;
    }

}