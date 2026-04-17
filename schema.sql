-- MySQL schema for Organic Seed Marketplace
CREATE DATABASE IF NOT EXISTS organic_seed_marketplace;
USE organic_seed_marketplace;

CREATE TABLE IF NOT EXISTS users (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  full_name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  phone VARCHAR(50),
  address TEXT,
  role ENUM('customer','farmer') NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS farmers (
  farmer_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  farm_name VARCHAR(255),
  farm_location VARCHAR(255),
  experience_years INT DEFAULT 0,
  certification VARCHAR(255),
  profile_verified BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS seeds (
  seed_id INT AUTO_INCREMENT PRIMARY KEY,
  farmer_id INT NOT NULL,
  seed_name VARCHAR(255) NOT NULL,
  seed_type VARCHAR(100),
  category ENUM('organic','natural') DEFAULT 'organic',
  description TEXT,
  price_per_unit DECIMAL(10,2),
  unit VARCHAR(50),
  stock_quantity INT DEFAULT 0,
  image_path VARCHAR(500),
  is_available BOOLEAN DEFAULT TRUE,
  added_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (farmer_id) REFERENCES farmers(farmer_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS orders (
  order_id INT AUTO_INCREMENT PRIMARY KEY,
  customer_id INT NOT NULL,
  seed_id INT NOT NULL,
  farmer_id INT NOT NULL,
  quantity INT NOT NULL,
  total_price DECIMAL(12,2) NOT NULL,
  order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  status ENUM('pending','confirmed','delivered') DEFAULT 'pending',
  FOREIGN KEY (customer_id) REFERENCES users(user_id),
  FOREIGN KEY (seed_id) REFERENCES seeds(seed_id),
  FOREIGN KEY (farmer_id) REFERENCES farmers(farmer_id)
);
