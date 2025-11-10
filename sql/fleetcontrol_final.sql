USE fleetcontrol;
CREATE TABLE anomaly_severity (
id INT AUTO_INCREMENT PRIMARY KEY,
code VARCHAR(50) UNIQUE,
label VARCHAR(100)
) ENGINE=InnoDB;
CREATE TABLE anomaly_cause (
id INT AUTO_INCREMENT PRIMARY KEY,
code VARCHAR(100) UNIQUE,
label VARCHAR(200),
description TEXT
) ENGINE=InnoDB;
CREATE TABLE anomaly (
id BIGINT AUTO_INCREMENT PRIMARY KEY,
reference VARCHAR(100) UNIQUE,
vehicle_id BIGINT NOT NULL,
title VARCHAR(255) NOT NULL,
description TEXT,
severity_id INT,
cause_id INT,
discovered_at DATETIME DEFAULT CURRENT_TIMESTAMP,
resolved_at DATETIME DEFAULT NULL,
status VARCHAR(50) DEFAULT 'OPEN',
estimated_cost DECIMAL(12,2) DEFAULT 0,
real_cost DECIMAL(12,2) DEFAULT 0,
reported_by INT NULL,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT fk_anomaly_vehicle FOREIGN KEY (vehicle_id) REFERENCES
vehicle(id) ON DELETE CASCADE,
CONSTRAINT fk_anomaly_severity FOREIGN KEY (severity_id) REFERENCES
anomaly_severity(id) ON DELETE SET NULL,
CONSTRAINT fk_anomaly_cause FOREIGN KEY (cause_id) REFERENCES
anomaly_cause(id) ON DELETE SET NULL
) ENGINE=InnoDB;
maintenance / intervention)
CREATE TABLE anomaly_link (
id BIGINT AUTO_INCREMENT PRIMARY KEY,
anomaly_id BIGINT NOT NULL,
9
object_type VARCHAR(50) NOT NULL,
etc.
object_id BIGINT NOT NULL,
notes TEXT,
CONSTRAINT fk_anlink_anomaly FOREIGN KEY (anomaly_id) REFERENCES
anomaly(id) ON DELETE CASCADE
) ENGINE=InnoDB;
CREATE TABLE anomaly_action (
id BIGINT AUTO_INCREMENT PRIMARY KEY,
anomaly_id BIGINT NOT NULL,
action_by INT NULL,
action_datetime DATETIME DEFAULT CURRENT_TIMESTAMP,
action_type VARCHAR(100), 
notes TEXT,
amount DECIMAL(12,2) DEFAULT 0,
CONSTRAINT fk_anact_anomaly FOREIGN KEY (anomaly_id) REFERENCES
anomaly(id) ON DELETE CASCADE
) ENGINE=InnoDB;
INSERT INTO anomaly_severity(code,label) VALUES ('LOW','Faible'),
('MED','Moyenne'),('HIGH','Haute');
INSERT INTO anomaly_cause(code,label) VALUES ('MECH','Défaillance
mécanique'),('ELEC','Défaut électrique'),('USAGE','Usure / usage'),
('MAINT','Entretien manqué');
COMMIT;
