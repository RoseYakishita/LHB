-- =========================
-- seed.sql (MySQL 8)
-- Seed data for ecommerce_ai
-- =========================

USE ecommerce_ai;

INSERT INTO roles (name) VALUES
('admin'),
('customer');

INSERT INTO users (role_id, email, password_hash, full_name, phone) VALUES
(1, 'admin@local.dev', '$2b$10$adminhashdemo', 'Admin Demo', '0900000001'),
(2, 'hung@example.com', '$2b$10$userhashdemo', 'Hùng Đỗ', '0900000002');

INSERT INTO categories (name, slug) VALUES
('Điện thoại', 'dien-thoai'),
('Laptop', 'laptop');

INSERT INTO products (category_id, sku, name, slug, description, price, stock) VALUES
(1, 'IP15-128', 'iPhone 15 128GB', 'iphone-15-128gb', 'Điện thoại Apple', 19990000, 30),
(2, 'MBA-M3-13', 'MacBook Air M3 13"', 'macbook-air-m3-13', 'Laptop Apple M3', 28990000, 15);

INSERT INTO carts (user_id) VALUES
(2);

INSERT INTO cart_items (cart_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 19990000),
(1, 2, 1, 28990000);

INSERT INTO coupons (code, discount_type, discount_value, min_order_value, max_uses) VALUES
('WELCOME10', 'percent', 10, 1000000, 1000);

INSERT INTO orders (order_code, user_id, status, subtotal, discount_total, shipping_fee, grand_total) VALUES
('ORD0001', 2, 'pending', 48880000, 0, 30000, 48910000);

INSERT INTO order_items (order_id, product_id, quantity, unit_price, line_total) VALUES
(1, 1, 1, 19990000, 19990000),
(1, 2, 1, 28990000, 28990000);

INSERT INTO payments (order_id, provider, method, transaction_ref, amount, status) VALUES
(1, 'vnpay', 'ewallet', 'TXN_DEMO_0001', 48910000, 'pending');

INSERT INTO chat_sessions (user_id) VALUES
(2);

INSERT INTO chat_messages (session_id, role, content) VALUES
(1, 'user', 'Shop còn iPhone 15 không?'),
(1, 'assistant', 'Dạ còn anh/chị nhé, hiện còn 30 sản phẩm.');
