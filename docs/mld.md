```markdown
#  MLD - FleetControl

```sql
CATEGORIE(id_categorie PK, nom_categorie)
SITE(id_site PK, nom_site, adresse)

VEHICULE(
id_vehicule PK,
immatriculation UNIQUE,
id_categorie FK,
id_site FK,
date_achat DATE,
kilometrage INT,
statut ENUM('actif','maintenance','réformé','vendu')
)

CONDUCTEUR(id_conducteur PK, nom, prenom, permis, telephone)
MISSION(id_mission PK, description, cout DECIMAL(10,2))
TRAJET(
id_trajet PK,
date_depart, date_arrivee,
id_conducteur FK,
id_vehicule FK,
id_mission FK
)

TECHNICIEN(id_technicien PK, nom, prenom, interne BOOL)
FOURNISSEUR(id_fournisseur PK, nom, contact)
PIECE(id_piece PK, nom_piece, prix_unitaire DECIMAL(10,2), id_fournisseur FK)
INTERVENTION(
id_intervention PK,
id_vehicule FK,
id_technicien FK,
date_intervention DATE,
cout_total DECIMAL(10,2),
description TEXT
)
PIECE_UTILISEE(id_intervention FK, id_piece FK, quantite INT, PRIMARY KEY(id_intervention, id_piece))

ASSURANCE(id_assurance PK, id_vehicule FK, compagnie, date_debut, date_fin, montant)
CONTROLE_TECHNIQUE(id_controle PK, id_vehicule FK, date_controle, resultat)
CONTRAT(id_contrat PK, id_vehicule FK, type_contrat, date_debut, date_fin)

