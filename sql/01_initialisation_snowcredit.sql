
-- ============================================================
-- PROJET : SnowCredit Sazotech
-- ENTREPRISE : SAZOTECH SOLUTIONS
-- PLATEFORME : Snowflake
-- FICHIER : 01_initialisation_snowcredit.sql
-- OBJECTIF : Initialisation de l'entrepot de calcul
-- ============================================================

-- 1. Creation de l'entrepot de calcul
-- La taille XSMALL suffit pour notre projet pedagogique.
-- L'entrepot sera suspendu apres 60 secondes d'inactivite.

CREATE WAREHOUSE IF NOT EXISTS SNOWCREDIT_WH
    WAREHOUSE_TYPE = STANDARD
    WAREHOUSE_SIZE = 'XSMALL'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE
    COMMENT = 'Entrepot de calcul du projet SnowCredit Sazotech';

-- 2. Verification de la creation de l'entrepot

SHOW WAREHOUSES LIKE 'SNOWCREDIT_WH';
