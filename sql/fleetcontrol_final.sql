CREATE TABLE Anomalie (
  id_anomalie INT AUTO_INCREMENT PRIMARY KEY,
  id_vehicule INT,
  description TEXT,
  cause TEXT,
  cout DECIMAL(10,2),
  date_signalement DATE,
  statut ENUM('signalée','en_cours','résolue'),
  FOREIGN KEY (id_vehicule) REFERENCES Vehicule(id_vehicule)
);
