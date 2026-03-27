-- full_setup.sql (MySQL 8)
-- Schema + Seed

-- ===========================
-- full_setup.sql (MySQL 8)
-- Schema + Seed data for ecommerce_ai
-- ===========================

DROP DATABASE IF EXISTS ecommerce_ai;
CREATE DATABASE ecommerce_ai CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ecommerce_ai;

CREATE TABLE roles (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL UNIQUE,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE users (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  role_id BIGINT NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  full_name VARCHAR(150) NOT NULL,
  phone VARCHAR(20),
  status ENUM('active','blocked') NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_users_role FOREIGN KEY (role_id) REFERENCES roles(id)
);

CREATE TABLE categories (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  parent_id BIGINT NULL,
  name VARCHAR(120) NOT NULL,
  slug VARCHAR(140) NOT NULL UNIQUE,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_categories_parent FOREIGN KEY (parent_id) REFERENCES categories(id)
);

CREATE TABLE products (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  category_id BIGINT NOT NULL,
  sku VARCHAR(64) NOT NULL UNIQUE,
  name VARCHAR(255) NOT NULL,
  slug VARCHAR(255) NOT NULL UNIQUE,
  description TEXT,
  price DECIMAL(12,2) NOT NULL,
  stock INT NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_products_category FOREIGN KEY (category_id) REFERENCES categories(id)
);

CREATE TABLE carts (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id BIGINT NOT NULL UNIQUE,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_carts_user FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE cart_items (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  cart_id BIGINT NOT NULL,
  product_id BIGINT NOT NULL,
  quantity INT NOT NULL,
  unit_price DECIMAL(12,2) NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uk_cart_product (cart_id, product_id),
  CONSTRAINT fk_cart_items_cart FOREIGN KEY (cart_id) REFERENCES carts(id) ON DELETE CASCADE,
  CONSTRAINT fk_cart_items_product FOREIGN KEY (product_id) REFERENCES products(id)
);

CREATE TABLE coupons (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  code VARCHAR(50) NOT NULL UNIQUE,
  discount_type ENUM('percent','fixed') NOT NULL,
  discount_value DECIMAL(12,2) NOT NULL,
  min_order_value DECIMAL(12,2) NOT NULL DEFAULT 0,
  max_uses INT NULL,
  used_count INT NOT NULL DEFAULT 0,
  starts_at DATETIME NULL,
  ends_at DATETIME NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE orders (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  order_code VARCHAR(30) NOT NULL UNIQUE,
  user_id BIGINT NOT NULL,
  status ENUM('pending','paid','shipping','completed','cancelled') NOT NULL DEFAULT 'pending',
  subtotal DECIMAL(12,2) NOT NULL,
  discount_total DECIMAL(12,2) NOT NULL DEFAULT 0,
  shipping_fee DECIMAL(12,2) NOT NULL DEFAULT 0,
  grand_total DECIMAL(12,2) NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_orders_user FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE order_items (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  order_id BIGINT NOT NULL,
  product_id BIGINT NOT NULL,
  quantity INT NOT NULL,
  unit_price DECIMAL(12,2) NOT NULL,
  line_total DECIMAL(12,2) NOT NULL,
  CONSTRAINT fk_order_items_order FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
  CONSTRAINT fk_order_items_product FOREIGN KEY (product_id) REFERENCES products(id)
);

CREATE TABLE payments (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  order_id BIGINT NOT NULL UNIQUE,
  provider VARCHAR(50) NOT NULL,
  method VARCHAR(50) NOT NULL,
  transaction_ref VARCHAR(120) UNIQUE,
  amount DECIMAL(12,2) NOT NULL,
  status ENUM('pending','success','failed','refunded') NOT NULL DEFAULT 'pending',
  paid_at DATETIME NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_payments_order FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
);

CREATE TABLE chat_sessions (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id BIGINT NULL,
  started_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ended_at DATETIME NULL,
  CONSTRAINT fk_chat_sessions_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

CREATE TABLE chat_messages (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  session_id BIGINT NOT NULL,
  role ENUM('user','assistant') NOT NULL,
  content TEXT NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_chat_messages_session FOREIGN KEY (session_id) REFERENCES chat_sessions(id) ON DELETE CASCADE
);

-- Optional indexes
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_orders_user ON orders(user_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_chat_messages_session ON chat_messages(session_id);

-- =========================
-- Seed data
-- =========================

INSERT INTO roles (name) VALUES
('admin'),
('customer');

INSERT INTO users (role_id, email, password_hash, full_name, phone) VALUES
(1, 'admin@local.dev', '$2b$10$adminhashdemo', 'Admin Demo', '0900000001'),
(2, 'hung@example.com', '$2b$10$userhashdemo', 'HÃ¹ng Äá»—', '0900000002');

INSERT INTO categories (name, slug) VALUES
('Äiá»‡n thoáº¡i', 'dien-thoai'),
('Laptop', 'laptop');

INSERT INTO products (category_id, sku, name, slug, description, price, stock) VALUES
(1, 'IP15-128', 'iPhone 15 128GB', 'iphone-15-128gb', 'Äiá»‡n thoáº¡i Apple', 19990000, 30),
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
(1, 'user', 'Shop cÃ²n iPhone 15 khÃ´ng?'),
(1, 'assistant', 'Dáº¡ cÃ²n anh/chá»‹ nhÃ©, hiá»‡n cÃ²n 30 sáº£n pháº©m.');


-- Seed Data
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
(2, 'hung@example.com', '$2b$10$userhashdemo', 'HÃ¹ng Äá»—', '0900000002');

INSERT INTO categories (name, slug) VALUES
('Äiá»‡n thoáº¡i', 'dien-thoai'),
('Laptop', 'laptop');

INSERT INTO products (category_id, sku, name, slug, description, price, stock) VALUES
(1, 'IP15-128', 'iPhone 15 128GB', 'iphone-15-128gb', 'Äiá»‡n thoáº¡i Apple', 19990000, 30),
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
(1, 'user', 'Shop cÃ²n iPhone 15 khÃ´ng?'),
(1, 'assistant', 'Dáº¡ cÃ²n anh/chá»‹ nhÃ©, hiá»‡n cÃ²n 30 sáº£n pháº©m.');

