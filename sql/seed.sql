-- ======================================================
-- SEED DATA FOR MountClaire Clothing Brand
-- Simple data for users and products
-- ======================================================

USE mountclaire_db;

-- ======================================================
-- INSERT ADMIN USER
-- Note: Use BCrypt hashed password in actual implementation
-- For testing, password is 'admin123' (you'll need to hash it properly)
-- ======================================================
INSERT INTO users (username, email, password_hash, full_name, phone, address, role, is_approved, is_active) VALUES
    ('admin', 'admin@mountclaire.com', 'admin123', 'System Administrator', '9800000000', 'Kathmandu, Nepal', 'admin', TRUE, TRUE);

-- ======================================================
-- INSERT CUSTOMERS
-- Passwords: 'password123' (use hashed values in production)
-- ======================================================
INSERT INTO users (username, email, password_hash, full_name, phone, address, role, is_approved, is_active) VALUES
                                                                                                                ('john_doe', 'john@example.com', 'password123', 'John Doe', '9812345678', 'Lazimpat, Kathmandu', 'customer', TRUE, TRUE),
                                                                                                                ('jane_smith', 'jane@example.com', 'password123', 'Jane Smith', '9823456789', 'Jhamsikhel, Lalitpur', 'customer', TRUE, TRUE),
                                                                                                                ('mike_wilson', 'mike@example.com', 'password123', 'Mike Wilson', '9834567890', 'Thamel, Kathmandu', 'customer', TRUE, TRUE),
                                                                                                                ('sarah_johnson', 'sarah@example.com', 'password123', 'Sarah Johnson', '9845678901', 'Boudha, Kathmandu', 'customer', FALSE, TRUE),
                                                                                                                ('alex_thompson', 'alex@example.com', 'password123', 'Alex Thompson', '9856789012', 'Patan, Lalitpur', 'customer', FALSE, TRUE);

-- ======================================================
-- INSERT CATEGORIES
-- ======================================================
INSERT INTO categories (category_name, description, is_active) VALUES
                                                                   ('T-Shirts', 'Premium quality cotton t-shirts for everyday wear', TRUE),
                                                                   ('Shirts', 'Formal and casual shirts for men and women', TRUE),
                                                                   ('Jeans', 'Comfortable and stylish denim jeans', TRUE),
                                                                   ('Jackets', 'Winter and summer jackets collection', TRUE),
                                                                   ('Hoodies', 'Comfortable hoodies for all seasons', TRUE),
                                                                   ('Trousers', 'Formal and casual trousers', TRUE),
                                                                   ('Dresses', 'Elegant dresses for women', TRUE),
                                                                   ('Accessories', 'Belts, caps, bags and more', TRUE);

-- ======================================================
-- INSERT PRODUCTS
-- ======================================================
INSERT INTO products (product_name, sku, description, price, discount_percentage, category_id, brand, material, gender, sizes_available, colors_available, stock_quantity, image_url, is_featured, is_active) VALUES
                                                                                                                                                                                                                  ('Classic Cotton T-Shirt', 'MC-TS-001', '100% premium cotton t-shirt with comfortable fit. Perfect for daily wear.', 1299, 10, 1, 'MountClaire', 'Cotton', 'men', 'S,M,L,XL,XXL', 'Black,White,Navy,Red', 100, '/images/products/tshirt-black.jpg', TRUE, TRUE),

                                                                                                                                                                                                                  ('Slim Fit Denim Jeans', 'MC-JN-001', 'Stretchable slim fit denim jeans with modern style. Available in multiple sizes.', 3499, 15, 3, 'MountClaire', 'Denim', 'men', '28,30,32,34,36', 'Blue,Black,Grey', 75, '/images/products/jeans-blue.jpg', TRUE, TRUE),

                                                                                                                                                                                                                  ('Women Summer Dress', 'MC-DR-001', 'Beautiful floral print summer dress. Lightweight and comfortable.', 2499, 20, 7, 'MountClaire', 'Polyester', 'women', 'XS,S,M,L,XL', 'Pink,Blue,White', 50, '/images/products/dress-pink.jpg', TRUE, TRUE),

                                                                                                                                                                                                                  ('Hooded Sweatshirt', 'MC-HD-001', 'Warm and comfortable hoodie with front pocket. Perfect for cold weather.', 3999, 5, 5, 'MountClaire', 'Cotton Blend', 'unisex', 'S,M,L,XL,XXL', 'Black,Grey,Navy,Red', 60, '/images/products/hoodie-black.jpg', TRUE, TRUE),

                                                                                                                                                                                                                  ('Formal Shirt', 'MC-SH-001', 'Premium formal shirt for office wear. Wrinkle-free and comfortable.', 2599, 0, 2, 'MountClaire', 'Cotton', 'men', 'S,M,L,XL,XXL', 'White,Blue,Black', 80, '/images/products/shirt-white.jpg', FALSE, TRUE),

                                                                                                                                                                                                                  ('Leather Jacket', 'MC-JK-001', 'Genuine leather jacket. Stylish and durable.', 12999, 25, 4, 'MountClaire', 'Leather', 'men', 'S,M,L,XL', 'Black,Brown', 30, '/images/products/jacket-black.jpg', TRUE, TRUE),

                                                                                                                                                                                                                  ('Yoga Leggings', 'MC-LG-001', 'High waist stretchable leggings. Perfect for yoga and gym.', 1899, 10, 6, 'MountClaire', 'Nylon', 'women', 'XS,S,M,L,XL', 'Black,Grey,Navy', 90, '/images/products/leggings-black.jpg', FALSE, TRUE),

                                                                                                                                                                                                                  ('Woolen Beanie Cap', 'MC-AC-001', 'Warm woolen beanie for winter. One size fits all.', 599, 0, 8, 'MountClaire', 'Wool', 'unisex', 'One Size', 'Black,Grey,Red,Blue', 200, '/images/products/beanie-black.jpg', FALSE, TRUE),

                                                                                                                                                                                                                  ('Printed Casual Shirt', 'MC-SH-002', 'Colorful printed casual shirt for parties and outings.', 1999, 15, 2, 'MountClaire', 'Cotton', 'men', 'S,M,L,XL', 'Blue,Red,Green', 45, '/images/products/casual-shirt.jpg', TRUE, TRUE),

                                                                                                                                                                                                                  ('Denim Jacket', 'MC-JK-002', 'Classic denim jacket. Timeless style.', 8999, 10, 4, 'MountClaire', 'Denim', 'unisex', 'S,M,L,XL', 'Blue,Black', 25, '/images/products/denim-jacket.jpg', TRUE, TRUE),

                                                                                                                                                                                                                  ('Sports T-Shirt', 'MC-TS-002', 'Breathable sports t-shirt for running and workouts.', 1499, 5, 1, 'MountClaire', 'Polyester', 'men', 'S,M,L,XL,XXL', 'Black,Blue,Red', 120, '/images/products/sports-tshirt.jpg', FALSE, TRUE),

                                                                                                                                                                                                                  ('Maxi Dress', 'MC-DR-002', 'Elegant floor-length maxi dress for special occasions.', 3999, 25, 7, 'MountClaire', 'Chiffon', 'women', 'XS,S,M,L', 'Red,Blue,Green', 35, '/images/products/maxi-dress.jpg', TRUE, TRUE),

                                                                                                                                                                                                                  ('Cargo Pants', 'MC-TR-001', 'Utility cargo pants with multiple pockets. Great for outdoor activities.', 2999, 0, 6, 'MountClaire', 'Cotton', 'men', 'S,M,L,XL,XXL', 'Black,Khaki,Olive', 65, '/images/products/cargo-pants.jpg', FALSE, TRUE);

-- ======================================================
-- INSERT PRODUCT SIZES WITH STOCK
-- ======================================================
INSERT INTO product_sizes (product_id, size, stock_quantity) VALUES
-- Product 1: Classic Cotton T-Shirt
(1, 'S', 20), (1, 'M', 30), (1, 'L', 25), (1, 'XL', 15), (1, 'XXL', 10),

-- Product 2: Slim Fit Denim Jeans
(2, '28', 15), (2, '30', 20), (2, '32', 20), (2, '34', 15), (2, '36', 5),

-- Product 3: Women Summer Dress
(3, 'XS', 10), (3, 'S', 15), (3, 'M', 15), (3, 'L', 8), (3, 'XL', 2),

-- Product 4: Hooded Sweatshirt
(4, 'S', 10), (4, 'M', 20), (4, 'L', 15), (4, 'XL', 10), (4, 'XXL', 5),

-- Product 5: Formal Shirt
(5, 'S', 15), (5, 'M', 25), (5, 'L', 20), (5, 'XL', 15), (5, 'XXL', 5),

-- Product 6: Leather Jacket
(6, 'S', 5), (6, 'M', 10), (6, 'L', 8), (6, 'XL', 7),

-- Product 7: Yoga Leggings
(7, 'XS', 20), (7, 'S', 25), (7, 'M', 25), (7, 'L', 15), (7, 'XL', 5),

-- Product 8: Woolen Beanie Cap
(8, 'One Size', 200),

-- Product 9: Printed Casual Shirt
(9, 'S', 10), (9, 'M', 15), (9, 'L', 12), (9, 'XL', 8),

-- Product 10: Denim Jacket
(10, 'S', 5), (10, 'M', 8), (10, 'L', 7), (10, 'XL', 5),

-- Product 11: Sports T-Shirt
(11, 'S', 25), (11, 'M', 35), (11, 'L', 30), (11, 'XL', 20), (11, 'XXL', 10),

-- Product 12: Maxi Dress
(12, 'XS', 10), (12, 'S', 10), (12, 'M', 8), (12, 'L', 5),

-- Product 13: Cargo Pants
(13, 'S', 15), (13, 'M', 20), (13, 'L', 15), (13, 'XL', 10), (13, 'XXL', 5);

-- ======================================================
-- INSERT SAMPLE SESSION DATA
-- ======================================================
INSERT INTO user_sessions (session_id, user_id, session_data, ip_address, user_agent) VALUES
                                                                                          ('sess_123456', 1, '{"last_activity":"2026-04-21 10:00:00"}', '192.168.1.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'),
                                                                                          ('sess_123457', 2, '{"last_activity":"2026-04-21 09:30:00"}', '192.168.1.2', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)');

-- ======================================================
-- INSERT ACTIVITY LOGS
-- ======================================================
INSERT INTO activity_logs (user_id, action, description, ip_address) VALUES
                                                                         (1, 'LOGIN', 'Admin logged into the system', '192.168.1.1'),
                                                                         (1, 'PRODUCT_ADD', 'Added new product: Classic Cotton T-Shirt', '192.168.1.1'),
                                                                         (2, 'REGISTER', 'New user registration: John Doe', '192.168.1.2'),
                                                                         (2, 'LOGIN', 'Customer John logged in', '192.168.1.2'),
                                                                         (3, 'REGISTER', 'New user registration: Jane Smith', '192.168.1.3'),
                                                                         (1, 'PRODUCT_UPDATE', 'Updated product: Slim Fit Denim Jeans', '192.168.1.1'),
                                                                         (1, 'USER_APPROVE', 'Approved user: Sarah Johnson', '192.168.1.1');

-- ======================================================
-- HELPER QUERIES (For testing)
-- ======================================================

-- Query to get all active products with category
-- SELECT p.*, c.category_name
-- FROM products p
-- LEFT JOIN categories c ON p.category_id = c.category_id
-- WHERE p.is_active = TRUE;

-- Query to get product stock by size
-- SELECT p.product_name, ps.size, ps.stock_quantity
-- FROM products p
-- INNER JOIN product_sizes ps ON p.product_id = ps.product_id
-- WHERE p.product_id = 1;

-- Query to get all users
-- SELECT user_id, username, email, full_name, phone, role, is_approved, is_active
-- FROM users;

-- Query to get pending user approvals
-- SELECT * FROM users WHERE role = 'customer' AND is_approved = FALSE;