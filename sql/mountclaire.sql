-- ======================================================
-- DATABASE: mountclaire_db
-- Project: MountClaire Clothing Brand Management System
-- Description: Complete database for clothing brand e-commerce platform
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
-- 2. USER_PROFILES TABLE (Additional customer info)
-- ======================================================
CREATE TABLE user_profiles (
                               profile_id INT PRIMARY KEY AUTO_INCREMENT,
                               user_id INT NOT NULL,
                               date_of_birth DATE,
                               gender ENUM('male', 'female', 'other', 'prefer_not_to_say'),
                               newsletter_subscribed BOOLEAN DEFAULT FALSE,
                               preferred_size ENUM('XS', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL'),
                               preferred_category VARCHAR(50),
                               total_spent DECIMAL(10,2) DEFAULT 0.00,
                               loyalty_points INT DEFAULT 0,
                               FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
                               INDEX idx_user_id (user_id)
);

-- ======================================================
-- 3. CATEGORIES TABLE
-- ======================================================
CREATE TABLE categories (
                            category_id INT PRIMARY KEY AUTO_INCREMENT,
                            category_name VARCHAR(50) UNIQUE NOT NULL,
                            description TEXT,
                            image_url VARCHAR(255),
                            is_active BOOLEAN DEFAULT TRUE,
                            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                            INDEX idx_category_name (category_name)
);

-- ======================================================
-- 4. PRODUCTS TABLE (Clothing Items)
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
                          sizes_available VARCHAR(100), -- Comma separated: S,M,L,XL
                          colors_available VARCHAR(200), -- JSON or comma separated
                          stock_quantity INT DEFAULT 0,
                          min_stock_threshold INT DEFAULT 10,
                          image_url VARCHAR(255),
                          image_urls TEXT, -- JSON array of multiple images
                          is_featured BOOLEAN DEFAULT FALSE,
                          is_active BOOLEAN DEFAULT TRUE,
                          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                          FOREIGN KEY (category_id) REFERENCES categories(category_id),
                          INDEX idx_sku (sku),
                          INDEX idx_category (category_id),
                          INDEX idx_gender (gender),
                          INDEX idx_price (price),
                          INDEX idx_is_active (is_active),
                          INDEX idx_is_featured (is_featured),
                          FULLTEXT INDEX idx_product_search (product_name, description, brand)
);

-- ======================================================
-- 5. PRODUCT_SIZES TABLE (Detailed size management)
-- ======================================================
CREATE TABLE product_sizes (
                               product_size_id INT PRIMARY KEY AUTO_INCREMENT,
                               product_id INT NOT NULL,
                               size ENUM('XS', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL') NOT NULL,
                               stock_quantity INT DEFAULT 0,
                               FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
                               UNIQUE KEY unique_product_size (product_id, size),
                               INDEX idx_product_id (product_id)
);

-- ======================================================
-- 6. SHOPPING_CART TABLE
-- ======================================================
CREATE TABLE shopping_cart (
                               cart_id INT PRIMARY KEY AUTO_INCREMENT,
                               user_id INT NOT NULL,
                               session_id VARCHAR(128),
                               created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                               updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                               FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
                               INDEX idx_user_id (user_id),
                               INDEX idx_session_id (session_id)
);

-- ======================================================
-- 7. CART_ITEMS TABLE
-- ======================================================
CREATE TABLE cart_items (
                            cart_item_id INT PRIMARY KEY AUTO_INCREMENT,
                            cart_id INT NOT NULL,
                            product_id INT NOT NULL,
                            size ENUM('XS', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL') NOT NULL,
                            quantity INT NOT NULL CHECK (quantity > 0),
                            price_at_add DECIMAL(10,2) NOT NULL,
                            added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                            FOREIGN KEY (cart_id) REFERENCES shopping_cart(cart_id) ON DELETE CASCADE,
                            FOREIGN KEY (product_id) REFERENCES products(product_id),
                            INDEX idx_cart_id (cart_id),
                            INDEX idx_product_id (product_id)
);

-- ======================================================
-- 8. ORDERS TABLE
-- ======================================================
CREATE TABLE orders (
                        order_id INT PRIMARY KEY AUTO_INCREMENT,
                        order_number VARCHAR(20) UNIQUE NOT NULL,
                        user_id INT NOT NULL,
                        order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                        total_amount DECIMAL(10,2) NOT NULL,
                        discount_amount DECIMAL(10,2) DEFAULT 0.00,
                        shipping_charge DECIMAL(10,2) DEFAULT 0.00,
                        tax_amount DECIMAL(10,2) DEFAULT 0.00,
                        grand_total DECIMAL(10,2) NOT NULL,
                        payment_method ENUM('cod', 'card', 'esewa', 'khalti') NOT NULL,
                        payment_status ENUM('pending', 'paid', 'failed', 'refunded') DEFAULT 'pending',
                        order_status ENUM('pending', 'confirmed', 'processing', 'shipped', 'delivered', 'cancelled', 'returned') DEFAULT 'pending',
                        shipping_address TEXT NOT NULL,
                        shipping_phone VARCHAR(15),
                        tracking_number VARCHAR(100),
                        notes TEXT,
                        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                        FOREIGN KEY (user_id) REFERENCES users(user_id),
                        INDEX idx_user_id (user_id),
                        INDEX idx_order_number (order_number),
                        INDEX idx_order_status (order_status),
                        INDEX idx_order_date (order_date),
                        INDEX idx_payment_status (payment_status)
);

-- ======================================================
-- 9. ORDER_ITEMS TABLE
-- ======================================================
CREATE TABLE order_items (
                             order_item_id INT PRIMARY KEY AUTO_INCREMENT,
                             order_id INT NOT NULL,
                             product_id INT NOT NULL,
                             product_name VARCHAR(200) NOT NULL,
                             size ENUM('XS', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL') NOT NULL,
                             quantity INT NOT NULL,
                             unit_price DECIMAL(10,2) NOT NULL,
                             discount_applied DECIMAL(10,2) DEFAULT 0.00,
                             subtotal DECIMAL(10,2) NOT NULL,
                             FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
                             FOREIGN KEY (product_id) REFERENCES products(product_id),
                             INDEX idx_order_id (order_id),
                             INDEX idx_product_id (product_id)
);

-- ======================================================
-- 10. WISHLIST TABLE
-- ======================================================
CREATE TABLE wishlist (
                          wishlist_id INT PRIMARY KEY AUTO_INCREMENT,
                          user_id INT NOT NULL,
                          product_id INT NOT NULL,
                          added_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                          FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
                          FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
                          UNIQUE KEY unique_user_product (user_id, product_id),
                          INDEX idx_user_id (user_id)
);

-- ======================================================
-- 11. REVIEWS_RATINGS TABLE
-- ======================================================
CREATE TABLE reviews (
                         review_id INT PRIMARY KEY AUTO_INCREMENT,
                         user_id INT NOT NULL,
                         product_id INT NOT NULL,
                         rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
                         title VARCHAR(200),
                         comment TEXT,
                         images TEXT, -- JSON array of images
                         is_verified_purchase BOOLEAN DEFAULT FALSE,
                         is_approved BOOLEAN DEFAULT FALSE,
                         created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                         updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                         FOREIGN KEY (user_id) REFERENCES users(user_id),
                         FOREIGN KEY (product_id) REFERENCES products(product_id),
                         INDEX idx_product_id (product_id),
                         INDEX idx_user_id (user_id),
                         INDEX idx_rating (rating),
                         INDEX idx_is_approved (is_approved)
);

-- ======================================================
-- 12. COUPONS TABLE
-- ======================================================
CREATE TABLE coupons (
                         coupon_id INT PRIMARY KEY AUTO_INCREMENT,
                         coupon_code VARCHAR(50) UNIQUE NOT NULL,
                         description TEXT,
                         discount_type ENUM('percentage', 'fixed') DEFAULT 'percentage',
                         discount_value DECIMAL(10,2) NOT NULL,
                         min_order_amount DECIMAL(10,2) DEFAULT 0.00,
                         max_discount_amount DECIMAL(10,2),
                         valid_from DATE NOT NULL,
                         valid_until DATE NOT NULL,
                         usage_limit INT DEFAULT 1,
                         used_count INT DEFAULT 0,
                         is_active BOOLEAN DEFAULT TRUE,
                         created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                         INDEX idx_coupon_code (coupon_code),
                         INDEX idx_valid_dates (valid_from, valid_until)
);

-- ======================================================
-- 13. USER_COUPONS TABLE (Track coupon usage per user)
-- ======================================================
CREATE TABLE user_coupons (
                              user_coupon_id INT PRIMARY KEY AUTO_INCREMENT,
                              user_id INT NOT NULL,
                              coupon_id INT NOT NULL,
                              used_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                              order_id INT,
                              FOREIGN KEY (user_id) REFERENCES users(user_id),
                              FOREIGN KEY (coupon_id) REFERENCES coupons(coupon_id),
                              FOREIGN KEY (order_id) REFERENCES orders(order_id),
                              UNIQUE KEY unique_user_coupon (user_id, coupon_id),
                              INDEX idx_user_id (user_id)
);

-- ======================================================
-- 14. CONTACT_MESSAGES TABLE
-- ======================================================
CREATE TABLE contact_messages (
                                  message_id INT PRIMARY KEY AUTO_INCREMENT,
                                  user_id INT,
                                  name VARCHAR(100) NOT NULL,
                                  email VARCHAR(100) NOT NULL,
                                  phone VARCHAR(15),
                                  subject VARCHAR(200) NOT NULL,
                                  message TEXT NOT NULL,
                                  status ENUM('unread', 'read', 'replied', 'resolved') DEFAULT 'unread',
                                  reply TEXT,
                                  replied_by INT,
                                  replied_at TIMESTAMP NULL,
                                  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL,
                                  FOREIGN KEY (replied_by) REFERENCES users(user_id),
                                  INDEX idx_status (status),
                                  INDEX idx_email (email)
);

-- ======================================================
-- 15. ACTIVITY_LOGS TABLE (Audit Trail)
-- ======================================================
CREATE TABLE activity_logs (
                               log_id INT PRIMARY KEY AUTO_INCREMENT,
                               user_id INT,
                               action VARCHAR(100),
                               entity_type VARCHAR(50),
                               entity_id INT,
                               description TEXT,
                               ip_address VARCHAR(45),
                               user_agent TEXT,
                               created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                               FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL,
                               INDEX idx_user_id (user_id),
                               INDEX idx_action (action),
                               INDEX idx_created_at (created_at)
);

-- ======================================================
-- 16. USER_SESSIONS TABLE
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
-- 17. NEWSLETTER_SUBSCRIBERS TABLE
-- ======================================================
CREATE TABLE newsletter_subscribers (
                                        subscriber_id INT PRIMARY KEY AUTO_INCREMENT,
                                        email VARCHAR(100) UNIQUE NOT NULL,
                                        name VARCHAR(100),
                                        is_active BOOLEAN DEFAULT TRUE,
                                        subscribed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                        unsubscribed_at TIMESTAMP NULL,
                                        INDEX idx_email (email)
);

-- ======================================================
-- 18. BANNER_SLIDES TABLE (For homepage carousel)
-- ======================================================
CREATE TABLE banner_slides (
                               slide_id INT PRIMARY KEY AUTO_INCREMENT,
                               title VARCHAR(100),
                               subtitle VARCHAR(200),
                               image_url VARCHAR(255) NOT NULL,
                               button_text VARCHAR(50),
                               button_link VARCHAR(255),
                               display_order INT DEFAULT 0,
                               is_active BOOLEAN DEFAULT TRUE,
                               created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                               INDEX idx_display_order (display_order)
);

-- ======================================================
-- INSERT SAMPLE DATA
-- ======================================================

-- Insert Admin User (password: admin123 - use BCrypt in actual implementation)
INSERT INTO users (username, email, password_hash, full_name, phone, address, role, is_approved) VALUES
    ('admin_mountclaire', 'admin@mountclaire.com', '$2a$10$N9qo8uLOickgx2ZMRZoMy.Mr/.c5hHcYqXZqDqZqDqZqDqZqDqZq', 'MountClaire Admin', '9800000001', 'Kathmandu, Nepal', 'admin', TRUE);

-- Insert Sample Customers
INSERT INTO users (username, email, password_hash, full_name, phone, address, role, is_approved, is_active) VALUES
                                                                                                                ('john_style', 'john@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMy.Mr/.c5hHcYqXZqDqZqDqZqDqZqDqZq', 'John Doe', '9812345678', 'Lazimpat, Kathmandu', 'customer', TRUE, TRUE),
                                                                                                                ('jane_fashion', 'jane@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMy.Mr/.c5hHcYqXZqDqZqDqZqDqZqDqZq', 'Jane Smith', '9823456789', 'Jhamsikhel, Lalitpur', 'customer', TRUE, TRUE),
                                                                                                                ('mike_wear', 'mike@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMy.Mr/.c5hHcYqXZqDqZqDqZqDqZqDqZq', 'Mike Wilson', '9834567890', 'Thamel, Kathmandu', 'customer', FALSE, TRUE);

-- Insert User Profiles
INSERT INTO user_profiles (user_id, date_of_birth, gender, newsletter_subscribed, preferred_size) VALUES
                                                                                                      (2, '1995-05-15', 'male', TRUE, 'L'),
                                                                                                      (3, '1998-08-22', 'female', TRUE, 'M'),
                                                                                                      (4, '1996-03-10', 'male', FALSE, 'XL');

-- Insert Categories
INSERT INTO categories (category_name, description, is_active) VALUES
                                                                   ('T-Shirts', 'Premium quality cotton t-shirts for everyday wear', TRUE),
                                                                   ('Shirts', 'Formal and casual shirts for men and women', TRUE),
                                                                   ('Jeans', 'Comfortable and stylish denim jeans', TRUE),
                                                                   ('Jackets', 'Winter and summer jackets collection', TRUE),
                                                                   ('Hoodies', 'Comfortable hoodies for all seasons', TRUE),
                                                                   ('Trousers', 'Formal and casual trousers', TRUE),
                                                                   ('Dresses', 'Elegant dresses for women', TRUE),
                                                                   ('Accessories', 'Belts, caps, bags and more', TRUE);

-- Insert Products
INSERT INTO products (product_name, sku, description, price, discount_percentage, category_id, brand, material, gender, sizes_available, colors_available, stock_quantity, image_url, is_featured) VALUES
                                                                                                                                                                                                       ('Classic Cotton T-Shirt', 'MC-TS-001', '100% premium cotton t-shirt with comfortable fit', 1299, 10, 1, 'MountClaire', 'Cotton', 'men', 'S,M,L,XL,XXL', 'Black,White,Navy,Red', 100, '/images/products/tshirt-black.jpg', TRUE),
                                                                                                                                                                                                       ('Slim Fit Denim Jeans', 'MC-JN-001', 'Stretchable slim fit denim jeans', 3499, 15, 3, 'MountClaire', 'Denim', 'men', '28,30,32,34,36', 'Blue,Black,Grey', 75, '/images/products/jeans-blue.jpg', TRUE),
                                                                                                                                                                                                       ('Women Summer Dress', 'MC-DR-001', 'Floral print summer dress', 2499, 20, 7, 'MountClaire', 'Polyester', 'women', 'XS,S,M,L,XL', 'Pink,Blue,White', 50, '/images/products/dress-pink.jpg', TRUE),
                                                                                                                                                                                                       ('Hooded Sweatshirt', 'MC-HD-001', 'Warm and comfortable hoodie with front pocket', 3999, 5, 5, 'MountClaire', 'Cotton Blend', 'unisex', 'S,M,L,XL,XXL', 'Black,Grey,Navy,Red', 60, '/images/products/hoodie-black.jpg', TRUE),
                                                                                                                                                                                                       ('Formal Shirt', 'MC-SH-001', 'Premium formal shirt for office wear', 2599, 0, 2, 'MountClaire', 'Cotton', 'men', 'S,M,L,XL,XXL', 'White,Blue,Black', 80, '/images/products/shirt-white.jpg', FALSE),
                                                                                                                                                                                                       ('Leather Jacket', 'MC-JK-001', 'Genuine leather jacket', 12999, 25, 4, 'MountClaire', 'Leather', 'men', 'S,M,L,XL', 'Black,Brown', 30, '/images/products/jacket-black.jpg', TRUE),
                                                                                                                                                                                                       ('Yoga Leggings', 'MC-LG-001', 'High waist stretchable leggings', 1899, 10, 6, 'MountClaire', 'Nylon', 'women', 'XS,S,M,L,XL', 'Black,Grey,Navy', 90, '/images/products/leggings-black.jpg', FALSE),
                                                                                                                                                                                                       ('Woolen Beanie Cap', 'MC-AC-001', 'Warm woolen beanie for winter', 599, 0, 8, 'MountClaire', 'Wool', 'unisex', 'One Size', 'Black,Grey,Red,Blue', 200, '/images/products/beanie-black.jpg', FALSE);

-- Insert Product Sizes with stock
INSERT INTO product_sizes (product_id, size, stock_quantity) VALUES
                                                                 (1, 'S', 20), (1, 'M', 30), (1, 'L', 25), (1, 'XL', 15), (1, 'XXL', 10),
                                                                 (2, '28', 15), (2, '30', 20), (2, '32', 20), (2, '34', 15), (2, '36', 5),
                                                                 (3, 'XS', 10), (3, 'S', 15), (3, 'M', 15), (3, 'L', 8), (3, 'XL', 2),
                                                                 (4, 'S', 10), (4, 'M', 20), (4, 'L', 15), (4, 'XL', 10), (4, 'XXL', 5);

-- Insert Orders
INSERT INTO orders (order_number, user_id, total_amount, discount_amount, shipping_charge, tax_amount, grand_total, payment_method, payment_status, order_status, shipping_address, shipping_phone) VALUES
                                                                                                                                                                                                        ('ORD-20260001', 2, 1299, 129.90, 100, 200, 1469.10, 'cod', 'paid', 'delivered', 'Lazimpat, Kathmandu', '9812345678'),
                                                                                                                                                                                                        ('ORD-20260002', 2, 3499, 524.85, 0, 250, 3224.15, 'esewa', 'paid', 'shipped', 'Lazimpat, Kathmandu', '9812345678'),
                                                                                                                                                                                                        ('ORD-20260003', 3, 3999, 199.95, 100, 300, 4199.05, 'khalti', 'paid', 'processing', 'Jhamsikhel, Lalitpur', '9823456789');

-- Insert Order Items
INSERT INTO order_items (order_id, product_id, product_name, size, quantity, unit_price, discount_applied, subtotal) VALUES
                                                                                                                         (1, 1, 'Classic Cotton T-Shirt', 'L', 1, 1299, 129.90, 1169.10),
                                                                                                                         (2, 2, 'Slim Fit Denim Jeans', '32', 1, 3499, 524.85, 2974.15),
                                                                                                                         (3, 4, 'Hooded Sweatshirt', 'M', 1, 3999, 199.95, 3799.05);

-- Insert Wishlist Items
INSERT INTO wishlist (user_id, product_id) VALUES
                                               (2, 3), (2, 5), (3, 1), (3, 6);

-- Insert Reviews
INSERT INTO reviews (user_id, product_id, rating, title, comment, is_verified_purchase, is_approved) VALUES
                                                                                                         (2, 1, 5, 'Great quality!', 'The t-shirt is very comfortable and fits perfectly. Highly recommended!', TRUE, TRUE),
                                                                                                         (2, 2, 4, 'Good jeans', 'Nice fit but slightly tight at waist. Overall good quality.', TRUE, TRUE),
                                                                                                         (3, 4, 5, 'Love this hoodie', 'Very warm and comfortable. Will buy again.', TRUE, TRUE);

-- Insert Coupons
INSERT INTO coupons (coupon_code, description, discount_type, discount_value, min_order_amount, valid_from, valid_until, usage_limit) VALUES
                                                                                                                                          ('WELCOME10', '10% off on first purchase', 'percentage', 10, 1000, '2026-01-01', '2026-12-31', 1),
                                                                                                                                          ('SAVE20', '20% off on orders above 5000', 'percentage', 20, 5000, '2026-01-01', '2026-12-31', 100),
                                                                                                                                          ('FLAT500', 'Flat Rs.500 off', 'fixed', 500, 3000, '2026-01-01', '2026-12-31', 50);

-- Insert Contact Messages
INSERT INTO contact_messages (user_id, name, email, subject, message, status) VALUES
                                                                                  (2, 'John Doe', 'john@example.com', 'Product Inquiry', 'When will the new collection arrive?', 'read'),
                                                                                  (NULL, 'Guest User', 'guest@example.com', 'Size Exchange', 'I want to exchange my t-shirt size', 'unread');

-- Insert Banner Slides
INSERT INTO banner_slides (title, subtitle, image_url, button_text, button_link, display_order) VALUES
                                                                                                    ('Summer Collection 2026', 'Up to 50% off on selected items', '/images/banner/summer-sale.jpg', 'Shop Now', '/products', 1),
                                                                                                    ('New Arrivals', 'Check out our latest collection', '/images/banner/new-arrivals.jpg', 'Explore', '/products?new=true', 2),
                                                                                                    ('Free Shipping', 'On orders above Rs.5000', '/images/banner/free-shipping.jpg', 'Shop Now', '/products', 3);

-- Insert Newsletter Subscribers
INSERT INTO newsletter_subscribers (email, name) VALUES
                                                     ('john@example.com', 'John Doe'),
                                                     ('jane@example.com', 'Jane Smith');

-- Insert Activity Logs
INSERT INTO activity_logs (user_id, action, entity_type, entity_id, description, ip_address) VALUES
                                                                                                 (1, 'LOGIN', 'USER', 1, 'Admin logged in', '192.168.1.1'),
                                                                                                 (1, 'PRODUCT_ADD', 'PRODUCT', 1, 'Added new product: Classic Cotton T-Shirt', '192.168.1.1'),
                                                                                                 (2, 'LOGIN', 'USER', 2, 'Customer John logged in', '192.168.1.2'),
                                                                                                 (2, 'ORDER_PLACED', 'ORDER', 1, 'Placed order ORD-20260001', '192.168.1.2');

-- ======================================================
-- STORED PROCEDURES
-- ======================================================

-- Procedure: Update product stock after order
DELIMITER //
CREATE PROCEDURE UpdateProductStock(IN p_product_id INT, IN p_size VARCHAR(10), IN p_quantity INT)
BEGIN
UPDATE product_sizes
SET stock_quantity = stock_quantity - p_quantity
WHERE product_id = p_product_id AND size = p_size;

UPDATE products
SET stock_quantity = stock_quantity - p_quantity
WHERE product_id = p_product_id;
END//
DELIMITER ;

-- Procedure: Calculate user loyalty points
DELIMITER //
CREATE PROCEDURE CalculateLoyaltyPoints(IN p_user_id INT)
BEGIN
    DECLARE total_points INT;

SELECT FLOOR(SUM(grand_total) / 100) INTO total_points
FROM orders
WHERE user_id = p_user_id AND order_status = 'delivered';

UPDATE user_profiles
SET loyalty_points = total_points
WHERE user_id = p_user_id;
END//
DELIMITER ;

-- ======================================================
-- VIEWS FOR DASHBOARD REPORTS
-- ======================================================

-- View: Product Sales Summary
CREATE VIEW vw_product_sales AS
SELECT
    p.product_id,
    p.product_name,
    p.sku,
    c.category_name,
    COUNT(oi.order_item_id) AS total_units_sold,
    SUM(oi.subtotal) AS total_revenue,
    AVG(r.rating) AS avg_rating
FROM products p
         LEFT JOIN categories c ON p.category_id = c.category_id
         LEFT JOIN order_items oi ON p.product_id = oi.product_id
         LEFT JOIN reviews r ON p.product_id = r.product_id AND r.is_approved = TRUE
GROUP BY p.product_id
ORDER BY total_revenue DESC;

-- View: Top Selling Products
CREATE VIEW vw_top_products AS
SELECT
    p.product_id,
    p.product_name,
    c.category_name,
    SUM(oi.quantity) AS total_sold,
    SUM(oi.subtotal) AS revenue,
    p.stock_quantity AS current_stock
FROM products p
         INNER JOIN categories c ON p.category_id = c.category_id
         INNER JOIN order_items oi ON p.product_id = oi.product_id
         INNER JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status IN ('delivered', 'shipped', 'processing')
GROUP BY p.product_id
ORDER BY total_sold DESC
    LIMIT 10;

-- View: Customer Order Summary
CREATE VIEW vw_customer_orders AS
SELECT
    u.user_id,
    u.full_name,
    u.email,
    COUNT(o.order_id) AS total_orders,
    SUM(o.grand_total) AS total_spent,
    AVG(o.grand_total) AS avg_order_value,
    MAX(o.order_date) AS last_order_date
FROM users u
         LEFT JOIN orders o ON u.user_id = o.user_id
WHERE u.role = 'customer'
GROUP BY u.user_id;

-- View: Low Stock Alert
CREATE VIEW vw_low_stock AS
SELECT
    p.product_id,
    p.product_name,
    p.sku,
    p.stock_quantity,
    p.min_stock_threshold,
    ps.size,
    ps.stock_quantity AS size_stock
FROM products p
         INNER JOIN product_sizes ps ON p.product_id = ps.product_id
WHERE p.stock_quantity <= p.min_stock_threshold
ORDER BY p.stock_quantity ASC;

-- View: Monthly Sales Report
CREATE VIEW vw_monthly_sales AS
SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    COUNT(o.order_id) AS total_orders,
    SUM(o.grand_total) AS total_revenue,
    AVG(o.grand_total) AS avg_order_value,
    COUNT(DISTINCT o.user_id) AS unique_customers
FROM orders o
WHERE o.order_status IN ('delivered', 'shipped')
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY month DESC;

-- ======================================================
-- INDEXES FOR PERFORMANCE
-- ======================================================

CREATE INDEX idx_products_search ON products(product_name, brand, description);
CREATE INDEX idx_orders_user_date ON orders(user_id, order_date);
CREATE INDEX idx_order_items_order ON order_items(order_id, product_id);
CREATE INDEX idx_reviews_product_rating ON reviews(product_id, rating);

-- ======================================================
-- TRIGGERS
-- ======================================================

-- Trigger: Update total spent and loyalty points after order completion
DELIMITER //
CREATE TRIGGER trg_after_order_delivered
    AFTER UPDATE ON orders
    FOR EACH ROW
BEGIN
    IF NEW.order_status = 'delivered' AND OLD.order_status != 'delivered' THEN
    UPDATE user_profiles up
    SET total_spent = total_spent + NEW.grand_total,
        loyalty_points = FLOOR((total_spent + NEW.grand_total) / 100)
    WHERE user_id = NEW.user_id;
END IF;
END//
DELIMITER ;

-- Trigger: Log product stock changes
DELIMITER //
CREATE TRIGGER trg_product_stock_log
    AFTER UPDATE ON products
    FOR EACH ROW
BEGIN
    IF OLD.stock_quantity != NEW.stock_quantity THEN
        INSERT INTO activity_logs (user_id, action, entity_type, entity_id, description)
        VALUES (NULL, 'STOCK_UPDATE', 'PRODUCT', NEW.product_id,
                CONCAT('Stock changed from ', OLD.stock_quantity, ' to ', NEW.stock_quantity));
END IF;
END//
DELIMITER ;

-- ======================================================
-- DASHBOARD QUERIES
-- ======================================================

-- Dashboard Statistics
SELECT
    (SELECT COUNT(*) FROM users WHERE role = 'customer') AS total_customers,
    (SELECT COUNT(*) FROM products WHERE is_active = TRUE) AS active_products,
    (SELECT COUNT(*) FROM orders WHERE order_status = 'pending') AS pending_orders,
    (SELECT COUNT(*) FROM contact_messages WHERE status = 'unread') AS unread_messages,
    (SELECT COUNT(*) FROM product_sizes WHERE stock_quantity < 5) AS low_stock_items,
    (SELECT SUM(grand_total) FROM orders WHERE DATE(order_date) = CURDATE()) AS today_sales,
    (SELECT SUM(grand_total) FROM orders WHERE MONTH(order_date) = MONTH(CURDATE())) AS monthly_sales;

-- ======================================================
-- END OF SCHEMA
-- ======================================================