-- AutoCare Pro - MySQL 8 schema (mirrors the JPA entities)
-- Optional: the backend creates these tables itself (ddl-auto=update). Run this only for manual setup.
CREATE DATABASE IF NOT EXISTS autocare_pro CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE autocare_pro;

CREATE TABLE roles (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE users (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  full_name VARCHAR(100) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  phone VARCHAR(20),
  address VARCHAR(255),
  role_id BIGINT NOT NULL,
  active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at DATETIME(6),
  CONSTRAINT fk_users_role FOREIGN KEY (role_id) REFERENCES roles(id)
);

CREATE TABLE mechanics (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT NOT NULL UNIQUE,
  specialization VARCHAR(100),
  available BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT fk_mech_user FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE vehicles (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  owner_id BIGINT NOT NULL,
  registration_number VARCHAR(20) NOT NULL UNIQUE,
  manufacturer VARCHAR(60) NOT NULL,
  model VARCHAR(60) NOT NULL,
  manufacturing_year INT NOT NULL,
  fuel_type VARCHAR(20) NOT NULL,
  odometer_reading INT NOT NULL,
  category VARCHAR(20) NOT NULL,
  last_service_date DATE,
  INDEX idx_vehicle_owner (owner_id),
  CONSTRAINT fk_vehicle_owner FOREIGN KEY (owner_id) REFERENCES users(id)
);

CREATE TABLE service_requests (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  booking_code VARCHAR(30) NOT NULL UNIQUE,
  customer_id BIGINT NOT NULL,
  vehicle_id BIGINT NOT NULL,
  category VARCHAR(30) NOT NULL,
  problem_description VARCHAR(1000),
  preferred_date DATE NOT NULL,
  odometer_reading INT NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'BOOKED',
  admin_remarks VARCHAR(500),
  created_at DATETIME(6),
  updated_at DATETIME(6),
  INDEX idx_sr_customer (customer_id),
  INDEX idx_sr_status (status),
  CONSTRAINT fk_sr_customer FOREIGN KEY (customer_id) REFERENCES users(id),
  CONSTRAINT fk_sr_vehicle FOREIGN KEY (vehicle_id) REFERENCES vehicles(id)
);

CREATE TABLE mechanic_assignments (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  service_request_id BIGINT NOT NULL,
  mechanic_id BIGINT NOT NULL,
  assigned_by BIGINT NOT NULL,
  active BOOLEAN NOT NULL DEFAULT TRUE,
  assigned_at DATETIME(6),
  INDEX idx_ma_mechanic (mechanic_id),
  INDEX idx_ma_request (service_request_id),
  CONSTRAINT fk_ma_request FOREIGN KEY (service_request_id) REFERENCES service_requests(id),
  CONSTRAINT fk_ma_mechanic FOREIGN KEY (mechanic_id) REFERENCES mechanics(id),
  CONSTRAINT fk_ma_by FOREIGN KEY (assigned_by) REFERENCES users(id)
);

CREATE TABLE service_updates (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  service_request_id BIGINT NOT NULL,
  updated_by BIGINT NOT NULL,
  status VARCHAR(20) NOT NULL,
  notes VARCHAR(1000),
  created_at DATETIME(6),
  INDEX idx_su_request (service_request_id),
  CONSTRAINT fk_su_request FOREIGN KEY (service_request_id) REFERENCES service_requests(id),
  CONSTRAINT fk_su_user FOREIGN KEY (updated_by) REFERENCES users(id)
);

CREATE TABLE spare_parts (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  part_code VARCHAR(30) NOT NULL UNIQUE,
  name VARCHAR(120) NOT NULL,
  unit_price DECIMAL(12,2) NOT NULL,
  stock_quantity INT NOT NULL,
  reorder_level INT NOT NULL DEFAULT 5
);

CREATE TABLE inventory_transactions (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  spare_part_id BIGINT NOT NULL,
  service_request_id BIGINT,
  type VARCHAR(20) NOT NULL,
  quantity_change INT NOT NULL,
  created_at DATETIME(6),
  INDEX idx_it_part (spare_part_id),
  CONSTRAINT fk_it_part FOREIGN KEY (spare_part_id) REFERENCES spare_parts(id),
  CONSTRAINT fk_it_request FOREIGN KEY (service_request_id) REFERENCES service_requests(id)
);

CREATE TABLE invoices (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  invoice_number VARCHAR(30) NOT NULL UNIQUE,
  service_request_id BIGINT NOT NULL UNIQUE,
  labour_charge DECIMAL(12,2) NOT NULL,
  parts_charge DECIMAL(12,2) NOT NULL,
  tax_rate DECIMAL(5,2) NOT NULL,
  tax_amount DECIMAL(12,2) NOT NULL,
  total_amount DECIMAL(12,2) NOT NULL,
  payment_status VARCHAR(10) NOT NULL DEFAULT 'UNPAID',
  invoice_date DATETIME(6),
  CONSTRAINT fk_inv_request FOREIGN KEY (service_request_id) REFERENCES service_requests(id)
);

CREATE TABLE invoice_items (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  invoice_id BIGINT NOT NULL,
  spare_part_id BIGINT,
  description VARCHAR(200) NOT NULL,
  quantity INT NOT NULL,
  unit_price DECIMAL(12,2) NOT NULL,
  line_total DECIMAL(12,2) NOT NULL,
  INDEX idx_ii_invoice (invoice_id),
  CONSTRAINT fk_ii_invoice FOREIGN KEY (invoice_id) REFERENCES invoices(id),
  CONSTRAINT fk_ii_part FOREIGN KEY (spare_part_id) REFERENCES spare_parts(id)
);

CREATE TABLE maintenance_records (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  vehicle_id BIGINT NOT NULL,
  service_request_id BIGINT,
  category VARCHAR(30) NOT NULL,
  odometer_reading INT NOT NULL,
  service_date DATE NOT NULL,
  notes VARCHAR(1000),
  INDEX idx_mr_vehicle (vehicle_id),
  CONSTRAINT fk_mr_vehicle FOREIGN KEY (vehicle_id) REFERENCES vehicles(id),
  CONSTRAINT fk_mr_request FOREIGN KEY (service_request_id) REFERENCES service_requests(id)
);

CREATE TABLE payments (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  invoice_id BIGINT NOT NULL,
  amount DECIMAL(12,2) NOT NULL,
  method VARCHAR(10) NOT NULL,
  reference VARCHAR(60),
  paid_at DATETIME(6),
  INDEX idx_pay_invoice (invoice_id),
  CONSTRAINT fk_pay_invoice FOREIGN KEY (invoice_id) REFERENCES invoices(id)
);

INSERT IGNORE INTO roles (name) VALUES ('ROLE_CUSTOMER'), ('ROLE_ADMIN'), ('ROLE_MECHANIC');
