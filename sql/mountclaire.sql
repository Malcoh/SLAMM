-- =============================================
-- Database: mountclaire_db
-- Description: E-commerce database for Mountclaire Clothing Brand
-- Author: Group Project CS5054NP
-- =============================================

-- Create and use database
CREATE DATABASE IF NOT EXISTS mountclaire_db;
USE mountclaire_db;

-- =============================================
-- Table: users
-- Description: Stores all user information (admin and customers)
-- =============================================
CREATE TABLE IF NOT EXISTS users (
                                     user_id INT PRIMARY KEY AUTO_INCREMENT,
                                     username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL, -- Store encrypted password
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) UNIQUE NOT NULL,
    address TEXT,
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code VARCHAR(20),
    country VARCHAR(50) DEFAULT 'Nepal',
    date_of_birth DATE,
    gender ENUM('Male', 'Female', 'Other', 'Prefer not to say'),
    role ENUM('admin', 'user') DEFAULT 'user',
    account_status ENUM('pending', 'active', 'suspended', 'deleted') DEFAULT 'pending',
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL,
    profile_image VARCHAR(255),
    INDEX idx_email (email),
    INDEX idx_username (username),
    INDEX idx_phone (phone),
    INDEX idx_role_status (role, account_status)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- Table: categories
-- Description: Product categories (Men, Women, Kids, Accessories, etc.)
-- =============================================
CREATE TABLE IF NOT EXISTS categories (
                                          category_id INT PRIMARY KEY AUTO_INCREMENT,
                                          category_name VARCHAR(50) UNIQUE NOT NULL,
    category_description TEXT,
    category_image VARCHAR(255),
    parent_category_id INT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (parent_category_id) REFERENCES categories(category_id) ON DELETE SET NULL,
    INDEX idx_category_name (category_name),
    INDEX idx_active (is_active)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- Table: products
-- Description: Stores all product information
-- =============================================
CREATE TABLE IF NOT EXISTS products (
                                        product_id INT PRIMARY KEY AUTO_INCREMENT,
                                        product_code VARCHAR(50) UNIQUE NOT NULL,
    product_name VARCHAR(200) NOT NULL,
    description TEXT,
    category_id INT NOT NULL,
    brand VARCHAR(50) DEFAULT 'Mountclaire',
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
    discount_percentage DECIMAL(5, 2) DEFAULT 0.00 CHECK (discount_percentage >= 0 AND discount_percentage <= 100),
    final_price DECIMAL(10, 2) GENERATED ALWAYS AS (price - (price * discount_percentage / 100)) STORED,
    stock_quantity INT DEFAULT 0 CHECK (stock_quantity >= 0),
    low_stock_threshold INT DEFAULT 10,
    sizes VARCHAR(100), -- Comma separated: S,M,L,XL,XXL
    colors VARCHAR(200), -- Comma separated colors
    material VARCHAR(100),
    care_instructions TEXT,
    main_image VARCHAR(255),
    is_featured BOOLEAN DEFAULT FALSE,
    is_new_arrival BOOLEAN DEFAULT FALSE,
    is_on_sale BOOLEAN DEFAULT FALSE,
    status ENUM('active', 'inactive', 'discontinued') DEFAULT 'active',
    average_rating DECIMAL(3, 2) DEFAULT 0.00,
    total_reviews INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE RESTRICT,
    INDEX idx_product_code (product_code),
    INDEX idx_category (category_id),
    INDEX idx_price (price),
    INDEX idx_featured (is_featured),
    INDEX idx_status (status),
    INDEX idx_new_arrival (is_new_arrival),
    FULLTEXT INDEX ft_product_search (product_name, description)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- Table: product_images
-- Description: Multiple images for each product
-- =============================================
CREATE TABLE IF NOT EXISTS product_images (
                                              image_id INT PRIMARY KEY AUTO_INCREMENT,
                                              product_id INT NOT NULL,
                                              image_url VARCHAR(255) NOT NULL,
    is_primary BOOLEAN DEFAULT FALSE,
    display_order INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    INDEX idx_product (product_id),
    INDEX idx_primary (is_primary)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- Table: wishlist
-- Description: User wishlist items
-- =============================================
CREATE TABLE IF NOT EXISTS wishlist (
                                        wishlist_id INT PRIMARY KEY AUTO_INCREMENT,
                                        user_id INT NOT NULL,
                                        product_id INT NOT NULL,
                                        added_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                        FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    UNIQUE KEY unique_wishlist (user_id, product_id),
    INDEX idx_user (user_id)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- Table: cart
-- Description: Shopping cart for users
-- =============================================
CREATE TABLE IF NOT EXISTS cart (
                                    cart_id INT PRIMARY KEY AUTO_INCREMENT,
                                    user_id INT NOT NULL,
                                    product_id INT NOT NULL,
                                    quantity INT NOT NULL DEFAULT 1 CHECK (quantity > 0),
    size VARCHAR(10),
    color VARCHAR(30),
    added_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    UNIQUE KEY unique_cart_item (user_id, product_id, size, color),
    INDEX idx_user (user_id)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- Table: orders
-- Description: Main orders table
-- =============================================
CREATE TABLE IF NOT EXISTS orders (
                                      order_id INT PRIMARY KEY AUTO_INCREMENT,
                                      order_number VARCHAR(50) UNIQUE NOT NULL,
    user_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2) NOT NULL CHECK (total_amount >= 0),
    discount_amount DECIMAL(10, 2) DEFAULT 0.00,
    shipping_charge DECIMAL(10, 2) DEFAULT 0.00,
    tax_amount DECIMAL(10, 2) DEFAULT 0.00,
    grand_total DECIMAL(10, 2) NOT NULL,
    payment_method ENUM('cod', 'esewa', 'khalti', 'card') NOT NULL,
    payment_status ENUM('pending', 'completed', 'failed', 'refunded') DEFAULT 'pending',
    order_status ENUM('pending', 'confirmed', 'processing', 'shipped', 'delivered', 'cancelled', 'returned') DEFAULT 'pending',
    shipping_address TEXT NOT NULL,
    shipping_city VARCHAR(50),
    shipping_state VARCHAR(50),
    shipping_postal_code VARCHAR(20),
    shipping_country VARCHAR(50),
    tracking_number VARCHAR(100),
    notes TEXT,
    cancelled_at TIMESTAMP NULL,
    delivered_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE RESTRICT,
    INDEX idx_user (user_id),
    INDEX idx_order_number (order_number),
    INDEX idx_status (order_status),
    INDEX idx_date (order_date),
    INDEX idx_payment (payment_status)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- Table: order_items
-- Description: Individual items in each order
-- =============================================
CREATE TABLE IF NOT EXISTS order_items (
                                           order_item_id INT PRIMARY KEY AUTO_INCREMENT,
                                           order_id INT NOT NULL,
                                           product_id INT NOT NULL,
                                           quantity INT NOT NULL CHECK (quantity > 0),
    price_at_time DECIMAL(10, 2) NOT NULL,
    discount_at_time DECIMAL(10, 2) DEFAULT 0.00,
    size VARCHAR(10),
    color VARCHAR(30),
    subtotal DECIMAL(10, 2) GENERATED ALWAYS AS (quantity * price_at_time - discount_at_time) STORED,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE RESTRICT,
    INDEX idx_order (order_id),
    INDEX idx_product (product_id)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- Table: reviews
-- Description: Product reviews by users
-- =============================================
CREATE TABLE IF NOT EXISTS reviews (
                                       review_id INT PRIMARY KEY AUTO_INCREMENT,
                                       user_id INT NOT NULL,
                                       product_id INT NOT NULL,
                                       order_id INT NOT NULL,
                                       rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    title VARCHAR(200),
    comment TEXT,
    is_approved BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    UNIQUE KEY unique_review (user_id, product_id, order_id),
    INDEX idx_product (product_id),
    INDEX idx_rating (rating),
    INDEX idx_approved (is_approved)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- Table: user_sessions
-- Description: Track user login sessions
-- =============================================
CREATE TABLE IF NOT EXISTS user_sessions (
                                             session_id VARCHAR(255) PRIMARY KEY,
    user_id INT NOT NULL,
    ip_address VARCHAR(45),
    user_agent TEXT,
    login_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_activity TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user (user_id),
    INDEX idx_active (is_active)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- Table: password_resets
-- Description: Manage password reset requests
-- =============================================
CREATE TABLE IF NOT EXISTS password_resets (
                                               reset_id INT PRIMARY KEY AUTO_INCREMENT,
                                               user_id INT NOT NULL,
                                               reset_token VARCHAR(255) UNIQUE NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    is_used BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_token (reset_token),
    INDEX idx_expires (expires_at)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- Table: contact_messages
-- Description: Store contact form submissions
-- =============================================
CREATE TABLE IF NOT EXISTS contact_messages (
                                                message_id INT PRIMARY KEY AUTO_INCREMENT,
                                                user_id INT NULL, -- NULL for non-registered users
                                                name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    subject VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    status ENUM('unread', 'read', 'replied') DEFAULT 'unread',
    admin_reply TEXT,
    replied_by INT NULL,
    replied_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_status (status),
    INDEX idx_email (email)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- Table: activity_logs
-- Description: Track user activities for audit
-- =============================================
CREATE TABLE IF NOT EXISTS activity_logs (
                                             log_id INT PRIMARY KEY AUTO_INCREMENT,
                                             user_id INT NULL,
                                             action VARCHAR(100) NOT NULL,
    description TEXT,
    ip_address VARCHAR(45),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_user (user_id),
    INDEX idx_action (action),
    INDEX idx_date (created_at)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- Triggers for automatic calculations
-- =============================================

-- Update product average rating when new review is added/updated
DELIMITER //
CREATE TRIGGER update_product_rating
    AFTER INSERT ON reviews
    FOR EACH ROW
BEGIN
    UPDATE products p
    SET
        p.average_rating = (
            SELECT AVG(rating)
            FROM reviews
            WHERE product_id = NEW.product_id AND is_approved = TRUE
        ),
        p.total_reviews = (
            SELECT COUNT(*)
            FROM reviews
            WHERE product_id = NEW.product_id AND is_approved = TRUE
        )
    WHERE p.product_id = NEW.product_id;
END//
DELIMITER ;

-- Update product stock after order placement
DELIMITER //
CREATE TRIGGER update_stock_after_order
    AFTER INSERT ON order_items
    FOR EACH ROW
BEGIN
    UPDATE products
    SET stock_quantity = stock_quantity - NEW.quantity
    WHERE product_id = NEW.product_id;
END//
DELIMITER ;