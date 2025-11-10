#  MCD - FleetControl

```mermaid
erDiagram
    CATEGORIE ||--o{ VEHICULE : contient
    SITE ||--o{ VEHICULE : héberge
    VEHICULE ||--o{ TRAJET : effectue
    CONDUCTEUR ||--o{ TRAJET : conduit
    TRAJET ||--o{ MISSION : correspond
    VEHICULE ||--o{ INTERVENTION : subit
    TECHNICIEN ||--o{ INTERVENTION : realise
    FOURNISSEUR ||--o{ PIECE : fournit
    INTERVENTION ||--o{ PIECE_UTILISEE : utilise
    VEHICULE ||--o{ ASSURANCE : assuré_par
    VEHICULE ||--o{ CONTROLE_TECHNIQUE : controle
    VEHICULE ||--o{ CONTRAT : lie

