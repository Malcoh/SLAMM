-- =============================================
-- Seed Data for Mountclaire Database
-- =============================================

USE mountclaire_db;

-- =============================================
-- Insert Admin User
-- Password: Admin@123 (will be encrypted in application)
-- =============================================
INSERT INTO users (username, email, password_hash, full_name, phone, address, city, state, postal_code, country, role, account_status, registration_date) VALUES
    ('admin_mountclaire', 'admin@mountclaire.com', 'ADMIN_PLACEHOLDER_HASH', 'Mountclaire Admin', '9800000001', 'Mountclaire Head Office, Durbar Marg', 'Kathmandu', 'Bagmati', '44600', 'Nepal', 'admin', 'active', NOW());

-- =============================================
-- Insert Regular Users
-- Password: User@123 (will be encrypted in application)
-- =============================================
INSERT INTO users (username, email, password_hash, full_name, phone, address, city, state, postal_code, country, date_of_birth, gender, role, account_status, registration_date) VALUES
                                                                                                                                                                                     ('john_doe', 'john@example.com', 'USER_PLACEHOLDER_HASH', 'John Doe', '9800000002', '123 Main Street', 'Kathmandu', 'Bagmati', '44601', 'Nepal', '1990-05-15', 'Male', 'user', 'active', NOW()),
                                                                                                                                                                                     ('jane_smith', 'jane@example.com', 'USER_PLACEHOLDER_HASH', 'Jane Smith', '9800000003', '456 Park Avenue', 'Lalitpur', 'Bagmati', '44700', 'Nepal', '1992-08-22', 'Female', 'user', 'active', NOW()),
                                                                                                                                                                                     ('bob_wilson', 'bob@example.com', 'USER_PLACEHOLDER_HASH', 'Bob Wilson', '9800000004', '789 Lake Road', 'Pokhara', 'Gandaki', '33700', 'Nepal', '1988-03-10', 'Male', 'user', 'pending', NOW()),
                                                                                                                                                                                     ('alice_brown', 'alice@example.com', 'USER_PLACEHOLDER_HASH', 'Alice Brown', '9800000005', '321 Hill Street', 'Biratnagar', 'Province 1', '56613', 'Nepal', '1995-11-30', 'Female', 'user', 'active', NOW());

-- =============================================
-- Insert Categories
-- =============================================
INSERT INTO categories (category_name, category_description, is_active) VALUES
                                                                            ('Men\'s Clothing', 'Premium clothing for men including shirts, pants, jackets and more', TRUE),
('Women\'s Clothing', 'Elegant and trendy clothing for women', TRUE),
                                                                            ('Kid\'s Clothing', 'Comfortable and stylish clothing for children', TRUE),
('Accessories', 'Complete your look with our premium accessories', TRUE),
('Footwear', 'Stylish and comfortable footwear for all occasions', TRUE),
('Sportswear', 'High-performance activewear for sports and fitness', TRUE),
('Traditional Wear', 'Celebrate culture with our traditional collection', TRUE);

-- Insert subcategories
INSERT INTO categories (category_name, category_description, parent_category_id, is_active) VALUES
('Shirts', 'Casual and formal shirts for men', 1, TRUE),
('T-Shirts', 'Comfortable everyday t-shirts', 1, TRUE),
('Jeans', 'Premium denim jeans', 1, TRUE),
('Trousers', 'Formal and casual trousers', 1, TRUE),
('Jackets', 'Stylish jackets for all seasons', 1, TRUE),
('Dresses', 'Beautiful dresses for every occasion', 2, TRUE),
('Tops & Blouses', 'Trendy tops and blouses', 2, TRUE),
('Skirts', 'Elegant skirts in various styles', 2, TRUE),
('Boys Collection', 'Clothing for boys aged 2-12 years', 3, TRUE),
('Girls Collection', 'Clothing for girls aged 2-12 years', 3, TRUE);

-- =============================================
-- Insert Products
-- =============================================

-- Men's Products
INSERT INTO products (product_code, product_name, description, category_id, price, discount_percentage, stock_quantity, sizes, colors, material, is_featured, is_new_arrival, status) VALUES
('MC-M-SH-001', 'Classic Oxford Cotton Shirt', 'Premium quality Oxford cotton shirt with button-down collar. Perfect for formal and casual occasions.', 8, 2499.00, 10.00, 50, 'S,M,L,XL,XXL', 'White,Blue,Pink', '100% Cotton', TRUE, TRUE, 'active'),
                                                                             ('MC-M-TS-002', 'Mountclaire Premium Polo T-Shirt', 'Classic fit polo t-shirt with embroidered logo. Breathable and comfortable fabric.', 9, 1899.00, 5.00, 100, 'S,M,L,XL,XXL', 'Black,Navy,Red,Grey', 'Cotton Blend', TRUE, FALSE, 'active'),
                                                                             ('MC-M-JN-003', 'Slim Fit Stretch Denim Jeans', 'Comfortable stretch denim jeans with modern slim fit design. Five-pocket styling.', 10, 3499.00, 15.00, 75, '28,30,32,34,36,38', 'Blue,Black,Grey', 'Denim with Elastane', TRUE, TRUE, 'active'),
                                                                             ('MC-M-JK-004', 'Bomber Jacket', 'Lightweight bomber jacket with ribbed cuffs and hem. Perfect for spring and autumn.', 12, 5999.00, 20.00, 30, 'S,M,L,XL', 'Black,Navy,Olive', 'Polyester', TRUE, FALSE, 'active'),
                                                                             ('MC-M-TR-005', 'Formal Trousers', 'Wrinkle-free formal trousers perfect for office wear.', 11, 2799.00, 0.00, 60, '28,30,32,34,36,38,40', 'Black,Charcoal,Navy', 'Polyester-Wool Blend', FALSE, FALSE, 'active');

-- Women's Products
INSERT INTO products (product_code, product_name, description, category_id, price, discount_percentage, stock_quantity, sizes, colors, material, is_featured, is_new_arrival, status) VALUES
                                                                                                                                                                                          ('MC-W-DR-006', 'Floral Print Maxi Dress', 'Beautiful floral print maxi dress with flowy silhouette. Perfect for summer parties.', 13, 3999.00, 25.00, 45, 'XS,S,M,L,XL', 'Blue Floral,Pink Floral,Red Floral', 'Rayon', TRUE, TRUE, 'active'),
                                                                                                                                                                                          ('MC-W-TB-007', 'Silk Blend Blouse', 'Elegant silk blend blouse with V-neck design.', 14, 2299.00, 10.00, 80, 'XS,S,M,L,XL', 'Cream,Blush,Navy,Black', 'Silk Blend', TRUE, FALSE, 'active'),
                                                                                                                                                                                          ('MC-W-SK-008', 'A-Line Denim Skirt', 'Stylish A-line denim skirt with button front closure.', 15, 1999.00, 0.00, 55, 'XS,S,M,L,XL', 'Blue,Black', 'Denim', FALSE, TRUE, 'active'),
                                                                                                                                                                                          ('MC-W-DR-009', 'Little Black Dress', 'Classic little black dress perfect for any occasion.', 13, 4499.00, 30.00, 40, 'XS,S,M,L,XL', 'Black', 'Cotton Blend', TRUE, FALSE, 'active');

-- Kids Products
INSERT INTO products (product_code, product_name, description, category_id, price, discount_percentage, stock_quantity, sizes, colors, material, is_featured, status) VALUES
                                                                                                                                                                          ('MC-K-BC-010', 'Kids Cotton T-Shirt Pack', 'Pack of 3 comfortable cotton t-shirts for kids.', 16, 1499.00, 0.00, 120, '2-3Y,4-5Y,6-7Y,8-9Y,10-11Y', 'Multicolor', '100% Cotton', TRUE, 'active'),
                                                                                                                                                                          ('MC-K-GC-011', 'Girls Party Wear Frocks', 'Beautiful frock for special occasions.', 17, 2499.00, 15.00, 60, '2-3Y,4-5Y,6-7Y,8-9Y', 'Pink,Purple,Red', 'Cotton', TRUE, 'active'),
                                                                                                                                                                          ('MC-K-BC-012', 'Kids Denim Jeans', 'Durable and comfortable denim jeans for active kids.', 16, 1799.00, 10.00, 90, '2-3Y,4-5Y,6-7Y,8-9Y,10-11Y', 'Blue,Black', 'Denim', FALSE, 'active');

-- Accessories
INSERT INTO products (product_code, product_name, description, category_id, price, discount_percentage, stock_quantity, sizes, colors, material, is_featured, status) VALUES
                                                                                                                                                                          ('MC-A-WT-013', 'Premium Leather Wallet', 'Genuine leather wallet with multiple card slots and cash compartment.', 4, 1299.00, 0.00, 150, 'One Size', 'Brown,Black', 'Genuine Leather', TRUE, 'active'),
                                                                                                                                                                          ('MC-A-WT-014', 'Analog Wrist Watch', 'Elegant analog watch with stainless steel strap.', 4, 4999.00, 20.00, 50, 'One Size', 'Silver,Gold,Black', 'Stainless Steel', TRUE, 'active'),
                                                                                                                                                                          ('MC-A-BG-015', 'Canvas Tote Bag', 'Eco-friendly canvas tote bag perfect for shopping and daily use.', 4, 999.00, 0.00, 200, 'One Size', 'Natural,Black,Navy', 'Canvas', FALSE, 'active'),
                                                                                                                                                                          ('MC-A-SC-016', 'Silk Scarf', 'Luxurious silk scarf with artistic print.', 4, 1599.00, 10.00, 100, 'One Size', 'Multicolor', 'Silk', TRUE, 'active');

-- Footwear
INSERT INTO products (product_code, product_name, description, category_id, price, discount_percentage, stock_quantity, sizes, colors, material, is_featured, status) VALUES
                                                                                                                                                                          ('MC-F-SN-017', 'Classic White Sneakers', 'Comfortable white sneakers suitable for daily wear.', 5, 3999.00, 15.00, 80, '6,7,8,9,10,11', 'White', 'Synthetic Leather', TRUE, 'active'),
                                                                                                                                                                          ('MC-F-LF-018', 'Leather Formal Shoes', 'Premium leather formal shoes for professional look.', 5, 5999.00, 10.00, 60, '6,7,8,9,10,11,12', 'Black,Brown', 'Genuine Leather', TRUE, 'active'),
                                                                                                                                                                          ('MC-F-SD-019', 'Summer Sandals', 'Comfortable sandals for summer days.', 5, 1499.00, 0.00, 120, '5,6,7,8,9,10', 'Brown,Black,Tan', 'Synthetic', FALSE, 'active');

-- Sportswear
INSERT INTO products (product_code, product_name, description, category_id, price, discount_percentage, stock_quantity, sizes, colors, material, is_featured, status) VALUES
                                                                                                                                                                          ('MC-S-DS-020', 'Dry-Fit Sports T-Shirt', 'Moisture-wicking fabric keeps you dry during workouts.', 6, 1299.00, 5.00, 150, 'S,M,L,XL,XXL', 'Black,Blue,Red,Grey', 'Polyester', TRUE, 'active'),
                                                                                                                                                                          ('MC-S-SP-021', 'Running Shorts', 'Lightweight running shorts with built-in liner.', 6, 1599.00, 10.00, 100, 'S,M,L,XL', 'Black,Navy,Red', 'Polyester', FALSE, 'active');

-- Traditional Wear
INSERT INTO products (product_code, product_name, description, category_id, price, discount_percentage, stock_quantity, sizes, colors, material, is_featured, is_new_arrival, status) VALUES
    ('MC-T-MD-022', 'Men\'s Daura Suruwal', 'Traditional Nepali Daura Suruwal set with topi.', 7, 7999.00, 15.00, 30, 'S,M,L,XL,XXL', 'White,Off-White', 'Cotton', TRUE, TRUE, 'active'),
('MC-T-KT-023', 'Women\'s Kurta Set', 'Elegant kurta set with dupatta.', 7, 4999.00, 20.00, 40, 'XS,S,M,L,XL', 'Red,Maroon,Green,Blue', 'Cotton-Silk', TRUE, TRUE, 'active');

-- =============================================
-- Insert Product Images
-- =============================================
INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
                                                                                  (1, '/images/products/shirt-1.jpg', TRUE, 1),
                                                                                  (1, '/images/products/shirt-2.jpg', FALSE, 2),
                                                                                  (2, '/images/products/polo-1.jpg', TRUE, 1),
                                                                                  (3, '/images/products/jeans-1.jpg', TRUE, 1),
                                                                                  (4, '/images/products/jacket-1.jpg', TRUE, 1),
                                                                                  (6, '/images/products/dress-1.jpg', TRUE, 1),
                                                                                  (7, '/images/products/blouse-1.jpg', TRUE, 1),
                                                                                  (13, '/images/products/wallet-1.jpg', TRUE, 1),
                                                                                  (14, '/images/products/watch-1.jpg', TRUE, 1),
                                                                                  (17, '/images/products/sneakers-1.jpg', TRUE, 1);

-- =============================================
-- Insert Sample Orders
-- =============================================
INSERT INTO orders (order_number, user_id, total_amount, discount_amount, shipping_charge, tax_amount, grand_total, payment_method, payment_status, order_status, shipping_address, shipping_city, shipping_state, shipping_postal_code) VALUES
                                                                                                                                                                                                                                             ('MC-ORD-20240001', 2, 4398.00, 250.00, 80.00, 350.00, 4578.00, 'cod', 'completed', 'delivered', '123 Main Street, Kathmandu', 'Kathmandu', 'Bagmati', '44601'),
                                                                                                                                                                                                                                             ('MC-ORD-20240002', 3, 3999.00, 1000.00, 0.00, 300.00, 3299.00, 'esewa', 'completed', 'shipped', '456 Park Avenue, Lalitpur', 'Lalitpur', 'Bagmati', '44700'),
                                                                                                                                                                                                                                             ('MC-ORD-20240003', 5, 5999.00, 1200.00, 80.00, 480.00, 5359.00, 'khalti', 'completed', 'delivered', '321 Hill Street, Biratnagar', 'Biratnagar', 'Province 1', '56613');

-- =============================================
-- Insert Order Items
-- =============================================
INSERT INTO order_items (order_id, product_id, quantity, price_at_time, discount_at_time, size, color) VALUES
                                                                                                           (1, 2, 2, 1899.00, 95.00, 'L', 'Black'),
                                                                                                           (1, 5, 1, 2799.00, 0.00, '32', 'Black'),
                                                                                                           (2, 6, 1, 3999.00, 1000.00, 'M', 'Blue Floral'),
                                                                                                           (3, 4, 1, 5999.00, 1200.00, 'L', 'Black');

-- =============================================
-- Insert Reviews
-- =============================================
INSERT INTO reviews (user_id, product_id, order_id, rating, title, comment, is_approved) VALUES
                                                                                             (2, 2, 1, 5, 'Excellent quality!', 'The polo t-shirt is very comfortable and the fabric quality is premium. Highly recommended!', TRUE),
                                                                                             (2, 5, 1, 4, 'Good formal trousers', 'Fits well and looks professional. Slightly expensive but worth it.', TRUE),
                                                                                             (3, 6, 2, 5, 'Beautiful dress', 'The floral print is gorgeous and the fit is perfect. Love it!', TRUE),
                                                                                             (5, 4, 3, 4, 'Nice jacket', 'Good quality jacket, keeps me warm. Size runs slightly small.', TRUE);

-- =============================================
-- Insert Wishlist Items
-- =============================================
INSERT INTO wishlist (user_id, product_id) VALUES
                                               (2, 3),
                                               (2, 6),
                                               (3, 4),
                                               (3, 13),
                                               (5, 14),
                                               (5, 17);

-- =============================================
-- Insert Cart Items
-- =============================================
INSERT INTO cart (user_id, product_id, quantity, size, color) VALUES
                                                                  (2, 13, 1, 'One Size', 'Brown'),
                                                                  (3, 7, 2, 'M', 'Black'),
                                                                  (5, 20, 1, 'L', 'Blue');

-- =============================================
-- Insert Contact Messages
-- =============================================
INSERT INTO contact_messages (user_id, name, email, subject, message, status) VALUES
    (2, 'John Doe', 'john@example.com', 'Order Delivery Delay', 'My order MC-ORD-20240001 is showing delivered but I haven\'t received it.', 'read'),
(NULL, 'Test User', 'test@email.com', 'Product Inquiry', 'Do you have size XXL in the bomber jacket?', 'unread');

-- =============================================
-- Insert Activity Logs
-- =============================================
INSERT INTO activity_logs (user_id, action, description, ip_address) VALUES
(1, 'LOGIN', 'Admin logged in successfully', '192.168.1.1'),
(2, 'REGISTER', 'New user registration', '192.168.1.2'),
(2, 'PLACE_ORDER', 'Order MC-ORD-20240001 placed', '192.168.1.2'),
(3, 'LOGIN', 'User logged in', '192.168.1.3'),
(1, 'UPDATE_PRODUCT', 'Updated product MC-M-SH-001 price', '192.168.1.1');

-- =============================================
-- Verify Data Insertion
-- =============================================
SELECT 'Database seeded successfully!' AS Status;
SELECT COUNT(*) AS Total_Users FROM users;
SELECT COUNT(*) AS Total_Products FROM products;
SELECT COUNT(*) AS Total_Categories FROM categories;
SELECT COUNT(*) AS Total_Orders FROM orders;