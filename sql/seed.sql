-- ======================================================
-- SEED DATA FOR MountClaire Clothing Brand
-- Additional sample data for testing
-- ======================================================

USE mountclaire_db;

-- Insert more sample products
INSERT INTO products (product_name, sku, description, price, discount_percentage, category_id, brand, material, gender, sizes_available, colors_available, stock_quantity, image_url, is_featured) VALUES
                                                                                                                                                                                                       ('Printed Casual Shirt', 'MC-SH-002', 'Colorful printed casual shirt', 1999, 15, 2, 'MountClaire', 'Cotton', 'men', 'S,M,L,XL', 'Blue,Red,Green', 45, '/images/products/casual-shirt.jpg', TRUE),
                                                                                                                                                                                                       ('Denim Jacket', 'MC-JK-002', 'Classic denim jacket', 8999, 10, 4, 'MountClaire', 'Denim', 'unisex', 'S,M,L,XL', 'Blue,Black', 25, '/images/products/denim-jacket.jpg', TRUE),
                                                                                                                                                                                                       ('Sports T-Shirt', 'MC-TS-002', 'Breathable sports t-shirt', 1499, 5, 1, 'MountClaire', 'Polyester', 'men', 'S,M,L,XL,XXL', 'Black,Blue,Red', 120, '/images/products/sports-tshirt.jpg', FALSE),
                                                                                                                                                                                                       ('Maxi Dress', 'MC-DR-002', 'Elegant floor-length maxi dress', 3999, 25, 7, 'MountClaire', 'Chiffon', 'women', 'XS,S,M,L', 'Red,Blue,Green', 35, '/images/products/maxi-dress.jpg', TRUE),
                                                                                                                                                                                                       ('Cargo Pants', 'MC-TR-001', 'Utility cargo pants with multiple pockets', 2999, 0, 6, 'MountClaire', 'Cotton', 'men', 'S,M,L,XL,XXL', 'Black,Khaki,Olive', 65, '/images/products/cargo-pants.jpg', FALSE);

-- Insert more product sizes
INSERT INTO product_sizes (product_id, size, stock_quantity) VALUES
                                                                 (9, 'S', 10), (9, 'M', 15), (9, 'L', 12), (9, 'XL', 8),
                                                                 (10, 'S', 5), (10, 'M', 8), (10, 'L', 7), (10, 'XL', 5),
                                                                 (11, 'S', 25), (11, 'M', 35), (11, 'L', 30), (11, 'XL', 20), (11, 'XXL', 10);

-- Insert more customers
INSERT INTO users (username, email, password_hash, full_name, phone, address, role, is_approved, is_active) VALUES
                                                                                                                ('sarah_style', 'sarah@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMy.Mr/.c5hHcYqXZqDqZqDqZqDqZqDqZq', 'Sarah Johnson', '9845678901', 'Boudha, Kathmandu', 'customer', TRUE, TRUE),
                                                                                                                ('alex_wear', 'alex@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMy.Mr/.c5hHcYqXZqDqZqDqZqDqZqDqZq', 'Alex Thompson', '9856789012', 'Patan, Lalitpur', 'customer', TRUE, TRUE),
                                                                                                                ('emma_fashion', 'emma@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMy.Mr/.c5hHcYqXZqDqZqDqZqDqZqDqZq', 'Emma Davis', '9867890123', 'Bhaktapur', 'customer', TRUE, TRUE);

--