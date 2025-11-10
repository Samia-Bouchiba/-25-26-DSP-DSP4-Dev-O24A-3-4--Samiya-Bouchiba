CREATE DATABASE fleetcontrol CHARACTER SET utf8mb4 COLLATE
utf8mb4_unicode_ci;
USE fleetcontrol;

CREATE TABLE site (
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(150) NOT NULL,
address VARCHAR(255),
city VARCHAR(100),
postal_code VARCHAR(20),
country VARCHAR(80) DEFAULT 'France',
phone VARCHAR(50),
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;
CREATE TABLE category (
id INT AUTO_INCREMENT PRIMARY KEY,
code VARCHAR(50) NOT NULL UNIQUE,
label VARCHAR(100) NOT NULL,
description TEXT
) ENGINE=InnoDB;
CREATE TABLE vehicle_status (
id INT AUTO_INCREMENT PRIMARY KEY,
code VARCHAR(50) NOT NULL UNIQUE,
label VARCHAR(100) NOT NULL
) ENGINE=InnoDB;
-- Entités principales
CREATE TABLE vehicle (
id BIGINT AUTO_INCREMENT PRIMARY KEY,
vin VARCHAR(50) UNIQUE,
registration_number VARCHAR(20) UNIQUE,
category_id INT NOT NULL,
site_id INT,
acquisition_date DATE,
•
3
acquisition_km INT DEFAULT 0,
current_km INT DEFAULT 0,
status_id INT NOT NULL,
purchase_price DECIMAL(12,2),
fuel_type VARCHAR(50),
colour VARCHAR(50),
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT fk_vehicle_category FOREIGN KEY (category_id) REFERENCES
category(id) ON DELETE RESTRICT,
CONSTRAINT fk_vehicle_site FOREIGN KEY (site_id) REFERENCES site(id) ON
DELETE SET NULL,
CONSTRAINT fk_vehicle_status FOREIGN KEY (status_id) REFERENCES
vehicle_status(id) ON DELETE RESTRICT
) ENGINE=InnoDB;
CREATE TABLE driver (
id INT AUTO_INCREMENT PRIMARY KEY,
firstname VARCHAR(100) NOT NULL,
lastname VARCHAR(100) NOT NULL,
badge_id VARCHAR(50),
phone VARCHAR(50),
email VARCHAR(150),
license_number VARCHAR(100),
hire_date DATE,
active BOOLEAN DEFAULT TRUE,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;
CREATE TABLE assignment (
id INT AUTO_INCREMENT PRIMARY KEY,
vehicle_id BIGINT NOT NULL,
driver_id INT NOT NULL,
start_date DATE NOT NULL,
end_date DATE DEFAULT NULL,
fixed_flag BOOLEAN DEFAULT FALSE,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT fk_assignment_vehicle FOREIGN KEY (vehicle_id) REFERENCES
vehicle(id) ON DELETE CASCADE,
CONSTRAINT fk_assignment_driver FOREIGN KEY (driver_id) REFERENCES
driver(id) ON DELETE CASCADE
) ENGINE=InnoDB;
CREATE TABLE mission_type (
id INT AUTO_INCREMENT PRIMARY KEY,
code VARCHAR(50) UNIQUE,
label VARCHAR(100)
) ENGINE=InnoDB;
CREATE TABLE trip (
id BIGINT AUTO_INCREMENT PRIMARY KEY,
vehicle_id BIGINT NOT NULL,
4
driver_id INT,
mission_type_id INT,
start_datetime DATETIME,
end_datetime DATETIME,
start_km INT,
end_km INT,
origin VARCHAR(255),
destination VARCHAR(255),
notes TEXT,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT fk_trip_vehicle FOREIGN KEY (vehicle_id) REFERENCES vehicle(id)
ON DELETE CASCADE,
CONSTRAINT fk_trip_driver FOREIGN KEY (driver_id) REFERENCES driver(id) ON
DELETE SET NULL,
CONSTRAINT fk_trip_mission_type FOREIGN KEY (mission_type_id) REFERENCES
mission_type(id) ON DELETE SET NULL
) ENGINE=InnoDB;
CREATE TABLE trip_cost (
id BIGINT AUTO_INCREMENT PRIMARY KEY,
trip_id BIGINT NOT NULL,
cost_type VARCHAR(100),
amount DECIMAL(12,2) DEFAULT 0,
currency VARCHAR(10) DEFAULT 'EUR',
description VARCHAR(255),
CONSTRAINT fk_tripcost_trip FOREIGN KEY (trip_id) REFERENCES trip(id) ON
DELETE CASCADE
) ENGINE=InnoDB;
-- Maintenance & interventions
CREATE TABLE supplier (
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(200) NOT NULL,
contact VARCHAR(150),
phone VARCHAR(50),
address VARCHAR(255),
vat_number VARCHAR(100),
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;
CREATE TABLE maintenance_type (
id INT AUTO_INCREMENT PRIMARY KEY,
code VARCHAR(50),
label VARCHAR(100)
) ENGINE=InnoDB;
CREATE TABLE maintenance (
id BIGINT AUTO_INCREMENT PRIMARY KEY,
vehicle_id BIGINT NOT NULL,
supplier_id INT,
maintenance_type_id INT,
5
scheduled_date DATE,
performed_date DATE,
odometer INT,
cost_total DECIMAL(12,2) DEFAULT 0,
notes TEXT,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT fk_maintenance_vehicle FOREIGN KEY (vehicle_id) REFERENCES
vehicle(id) ON DELETE CASCADE,
CONSTRAINT fk_maintenance_supplier FOREIGN KEY (supplier_id) REFERENCES
supplier(id) ON DELETE SET NULL,
CONSTRAINT fk_maintenance_type FOREIGN KEY (maintenance_type_id)
REFERENCES maintenance_type(id) ON DELETE SET NULL
) ENGINE=InnoDB;
CREATE TABLE technician (
id INT AUTO_INCREMENT PRIMARY KEY,
firstname VARCHAR(100),
lastname VARCHAR(100),
internal_flag BOOLEAN DEFAULT TRUE,
supplier_id INT DEFAULT NULL,
CONSTRAINT fk_technician_supplier FOREIGN KEY (supplier_id) REFERENCES
supplier(id) ON DELETE SET NULL
) ENGINE=InnoDB;
CREATE TABLE intervention (
id BIGINT AUTO_INCREMENT PRIMARY KEY,
maintenance_id BIGINT,
technician_id INT,
start_datetime DATETIME,
end_datetime DATETIME,
description TEXT,
cost DECIMAL(12,2) DEFAULT 0,
notes TEXT,
CONSTRAINT fk_intervention_maintenance FOREIGN KEY (maintenance_id)
REFERENCES maintenance(id) ON DELETE CASCADE,
CONSTRAINT fk_intervention_technician FOREIGN KEY (technician_id)
REFERENCES technician(id) ON DELETE SET NULL
) ENGINE=InnoDB;
CREATE TABLE part (
id BIGINT AUTO_INCREMENT PRIMARY KEY,
sku VARCHAR(100) UNIQUE,
name VARCHAR(200) NOT NULL,
description TEXT,
unit_price DECIMAL(12,2) DEFAULT 0,
manufacturer VARCHAR(200)
) ENGINE=InnoDB;
CREATE TABLE stock (
id BIGINT AUTO_INCREMENT PRIMARY KEY,
part_id BIGINT NOT NULL,
6
site_id INT,
quantity INT DEFAULT 0,
minimum_stock INT DEFAULT 0,
CONSTRAINT fk_stock_part FOREIGN KEY (part_id) REFERENCES part(id) ON
DELETE CASCADE,
CONSTRAINT fk_stock_site FOREIGN KEY (site_id) REFERENCES site(id) ON
DELETE SET NULL
) ENGINE=InnoDB;
CREATE TABLE maintenance_part (
id BIGINT AUTO_INCREMENT PRIMARY KEY,
maintenance_id BIGINT NOT NULL,
part_id BIGINT NOT NULL,
quantity INT DEFAULT 1,
unit_price DECIMAL(12,2) DEFAULT 0,
CONSTRAINT fk_mp_maintenance FOREIGN KEY (maintenance_id) REFERENCES
maintenance(id) ON DELETE CASCADE,
CONSTRAINT fk_mp_part FOREIGN KEY (part_id) REFERENCES part(id) ON DELETE
RESTRICT
) ENGINE=InnoDB;
CREATE TABLE intervention_part (
id BIGINT AUTO_INCREMENT PRIMARY KEY,
intervention_id BIGINT NOT NULL,
part_id BIGINT NOT NULL,
quantity INT DEFAULT 1,
unit_price DECIMAL(12,2) DEFAULT 0,
CONSTRAINT fk_ip_intervention FOREIGN KEY (intervention_id) REFERENCES
intervention(id) ON DELETE CASCADE,
CONSTRAINT fk_ip_part FOREIGN KEY (part_id) REFERENCES part(id) ON DELETE
RESTRICT
) ENGINE=InnoDB;
CREATE TABLE insurance (
id BIGINT AUTO_INCREMENT PRIMARY KEY,
vehicle_id BIGINT NOT NULL,
provider VARCHAR(200),
policy_number VARCHAR(200),
start_date DATE,
end_date DATE,
coverage_notes TEXT,
CONSTRAINT fk_insurance_vehicle FOREIGN KEY (vehicle_id) REFERENCES
vehicle(id) ON DELETE CASCADE
) ENGINE=InnoDB;
CREATE TABLE technical_check (
id BIGINT AUTO_INCREMENT PRIMARY KEY,
vehicle_id BIGINT NOT NULL,
check_date DATE,
valid_until DATE,
km INT,
7
result VARCHAR(100),
notes TEXT,
CONSTRAINT fk_check_vehicle FOREIGN KEY (vehicle_id) REFERENCES
vehicle(id) ON DELETE CASCADE
) ENGINE=InnoDB;
CREATE INDEX idx_vehicle_status ON vehicle(status_id);
CREATE INDEX idx_trip_vehicle ON trip(vehicle_id);
CREATE INDEX idx_maintenance_vehicle ON maintenance(vehicle_id);
INSERT INTO vehicle_status(code,label) VALUES ('ACTIF','Actif'),('MAINT','En
maintenance'),('REFORME','Réformé'),('VENDU','Vendu');
INSERT INTO category(code,label) VALUES ('UTIL','Utilitaire'),
('PL','Poids_lourd'),('SERV','Véhicule_de_service');
INSERT INTO mission_type(code,label) VALUES ('LIV','Livraison'),
('TRANSP','Transport'),('MAINT','Maintenance');
INSERT INTO maintenance_type(code,label) VALUES ('PNEU','Pneumatique'),
('MEC','Mécanique'),('ELEC','Électrique');
COMMIT;
