-- ======================================================
-- DATABASE: mountclaire_db
-- Project: MountClaire Clothing Brand Management System
-- Version: Simple (Users & Products only)
-- ======================================================

-- Create and use database
DROP DATABASE IF EXISTS mountclaire_db;
CREATE DATABASE mountclaire_db;
USE mountclaire_db;

-- ======================================================
-- 1. USERS TABLE (Authentication & Authorization)
-- ======================================================
CREATE TABLE users (
                       user_id INT PRIMARY KEY AUTO_INCREMENT,
                       username VARCHAR(50) UNIQUE NOT NULL,
                       email VARCHAR(100) UNIQUE NOT NULL,
                       password_hash VARCHAR(255) NOT NULL,
                       full_name VARCHAR(100) NOT NULL,
                       phone VARCHAR(15) UNIQUE NOT NULL,
                       address TEXT,
                       role ENUM('admin', 'customer') DEFAULT 'customer',
                       is_active BOOLEAN DEFAULT TRUE,
                       is_approved BOOLEAN DEFAULT FALSE,
                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                       updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                       last_login TIMESTAMP NULL,
                       INDEX idx_email (email),
                       INDEX idx_role (role),
                       INDEX idx_is_approved (is_approved)
);

-- ======================================================
-- 2. CATEGORIES TABLE
-- ======================================================
CREATE TABLE categories (
                            category_id INT PRIMARY KEY AUTO_INCREMENT,
                            category_name VARCHAR(50) UNIQUE NOT NULL,
                            description TEXT,
                            is_active BOOLEAN DEFAULT TRUE,
                            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ======================================================
-- 3. PRODUCTS TABLE (Clothing Items)
-- ======================================================
CREATE TABLE products (
                          product_id INT PRIMARY KEY AUTO_INCREMENT,
                          product_name VARCHAR(200) NOT NULL,
                          sku VARCHAR(50) UNIQUE NOT NULL,
                          description TEXT,
                          price DECIMAL(10,2) NOT NULL,
                          discount_percentage DECIMAL(5,2) DEFAULT 0.00,
                          final_price DECIMAL(10,2) GENERATED ALWAYS AS (price - (price * discount_percentage / 100)) STORED,
                          category_id INT,
                          brand VARCHAR(100),
                          material VARCHAR(100),
                          gender ENUM('men', 'women', 'unisex', 'kids'),
                          sizes_available VARCHAR(100),
                          colors_available VARCHAR(200),
                          stock_quantity INT DEFAULT 0,
                          image_url VARCHAR(255),
                          is_featured BOOLEAN DEFAULT FALSE,
                          is_active BOOLEAN DEFAULT TRUE,
                          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                          FOREIGN KEY (category_id) REFERENCES categories(category_id),
                          INDEX idx_sku (sku),
                          INDEX idx_category (category_id),
                          INDEX idx_gender (gender),
                          INDEX idx_is_active (is_active)
);

-- ======================================================
-- 4. PRODUCT_SIZES TABLE (Stock management by size)
-- ======================================================
CREATE TABLE product_sizes (
                               product_size_id INT PRIMARY KEY AUTO_INCREMENT,
                               product_id INT NOT NULL,
                               size VARCHAR(10) NOT NULL,
                               stock_quantity INT DEFAULT 0,
                               FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
                               UNIQUE KEY unique_product_size (product_id, size),
                               INDEX idx_product_id (product_id)
);

-- ======================================================
-- 5. USER_SESSIONS TABLE (For session management)
-- ======================================================
CREATE TABLE user_sessions (
                               session_id VARCHAR(128) PRIMARY KEY,
                               user_id INT NOT NULL,
                               session_data TEXT,
                               ip_address VARCHAR(45),
                               user_agent TEXT,
                               last_activity TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                               FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
                               INDEX idx_user_id (user_id),
                               INDEX idx_last_activity (last_activity)
);

-- ======================================================
-- 6. ACTIVITY_LOGS TABLE (Audit Trail)
-- ======================================================
CREATE TABLE activity_logs (
                               log_id INT PRIMARY KEY AUTO_INCREMENT,
                               user_id INT,
                               action VARCHAR(100),
                               description TEXT,
                               ip_address VARCHAR(45),
                               created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                               FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL,
                               INDEX idx_user_id (user_id),
                               INDEX idx_created_at (created_at)
);