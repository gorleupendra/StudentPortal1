package com.example;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import java.sql.Connection;
import java.sql.SQLException;

public class DbConnection {
    private static HikariDataSource dataSource;

    static {
        try {
            HikariConfig config = new HikariConfig();
            
            // 1. Get credentials from your environment
            String host = System.getenv("RENDER_DB_HOST");
            String pass = System.getenv("RENDER_DB_PASSWORD");
            String dbName = "neondb";
            String user = "neondb_owner";

            // 2. Configure the Pool
            config.setJdbcUrl("jdbc:postgresql://" + host + ":5432/" + dbName + "?sslmode=require");
            config.setUsername(user);
            config.setPassword(pass);
            config.setDriverClassName("org.postgresql.Driver");

            // 3. Pool Settings (Optimization)
            config.setIdleTimeout(30000);      // If a connection is idle for 1 minute, close it.
            config.setMinimumIdle(0);          // Allow the pool to go down to ZERO connections.
            config.setMaximumPoolSize(5);      // Don't open too many doors at once.
            config.setMaxLifetime(1800000);    // 30 minutes
            config.setConnectionTimeout(30000);// Wait 30s (Neon takes a moment to "Wake up")
            
            dataSource = new HikariDataSource(config);
            System.out.println("[DB-POOL] Connection Pool initialized successfully.");

        } catch (Exception e) {
            System.err.println("[DB-POOL] Critical Error: Could not initialize HikariCP!");
            e.printStackTrace();
        }
    }

    /**
     * Borrows a connection from the pool.
     */
    public static Connection getConne() throws SQLException {
        if (dataSource == null) {
            throw new SQLException("DataSource is null. Pool failed to initialize.");
        }
        return dataSource.getConnection();
    }

    private DbConnection() {} // Prevent instantiation
}