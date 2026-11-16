
-- ============================================================
-- PROJET     : SnowCredit Sazotech
-- ENTREPRISE : SAZOTECH SOLUTIONS
-- PLATEFORME : Snowflake
-- FICHIER    : 04_creation_table_raw_snowcredit.sql
-- OBJECTIF   : Creation de la table des credits bruts
-- ============================================================

-- ============================================================
-- 1. SELECTION DU CONTEXTE
-- ============================================================

USE DATABASE SNOWCREDIT_DB;

USE SCHEMA RAW;

-- ============================================================
-- 2. CREATION DE LA TABLE RAW
-- ============================================================
-- Les 21 colonnes correspondent au fichier german.data.
-- Toutes les valeurs sont conservees comme texte.
-- Les conversions seront realisees dans la couche CLEAN.
-- ============================================================

CREATE TABLE IF NOT EXISTS SNOWCREDIT_DB.RAW.CREDITS_BRUTS (

    STATUT_COMPTE              VARCHAR(50),
    DUREE_MOIS                 VARCHAR(50),
    HISTORIQUE_CREDIT          VARCHAR(50),
    OBJET_CREDIT               VARCHAR(50),
    MONTANT_CREDIT             VARCHAR(50),
    EPARGNE                    VARCHAR(50),
    ANCIENNETE_EMPLOI          VARCHAR(50),
    PART_MENSUALITE_REVENU     VARCHAR(50),
    STATUT_PERSONNEL           VARCHAR(50),
    AUTRES_DEBITEURS           VARCHAR(50),
    ANCIENNETE_RESIDENCE       VARCHAR(50),
    PATRIMOINE                 VARCHAR(50),
    AGE                        VARCHAR(50),
    AUTRES_PLANS_CREDIT        VARCHAR(50),
    LOGEMENT                   VARCHAR(50),
    NOMBRE_CREDITS_EXISTANTS   VARCHAR(50),
    EMPLOI                     VARCHAR(50),
    PERSONNES_A_CHARGE         VARCHAR(50),
    TELEPHONE                  VARCHAR(50),
    TRAVAILLEUR_ETRANGER       VARCHAR(50),
    CLASSE_RISQUE              VARCHAR(50)

)
COMMENT = 'Donnees brutes du portefeuille de credits German Credit';

-- ============================================================
-- 3. VERIFICATION DE LA CREATION
-- ============================================================

SHOW TABLES LIKE 'CREDITS_BRUTS'
IN SCHEMA SNOWCREDIT_DB.RAW;

-- ============================================================
-- 4. VERIFICATION DES 21 COLONNES
-- ============================================================

DESCRIBE TABLE SNOWCREDIT_DB.RAW.CREDITS_BRUTS;

-- ============================================================
-- FIN DU SCRIPT
-- ============================================================
