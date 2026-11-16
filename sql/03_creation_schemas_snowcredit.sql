
-- ============================================================
-- PROJET     : SnowCredit Sazotech
-- ENTREPRISE : SAZOTECH SOLUTIONS
-- PLATEFORME : Snowflake
-- FICHIER    : 03_creation_schemas_snowcredit.sql
-- OBJECTIF   : Creation des schemas RAW, CLEAN et MART
-- ============================================================

-- 1. Selection de la base de donnees

USE DATABASE SNOWCREDIT_DB;

-- ============================================================
-- 2. SCHEMA RAW : DONNEES BRUTES
-- ============================================================

CREATE SCHEMA IF NOT EXISTS SNOWCREDIT_DB.RAW
    COMMENT = 'Stockage des donnees bancaires brutes';

-- ============================================================
-- 3. SCHEMA CLEAN : DONNEES NETTOYEES
-- ============================================================

CREATE SCHEMA IF NOT EXISTS SNOWCREDIT_DB.CLEAN
    COMMENT = 'Donnees nettoyees et controlees';

-- ============================================================
-- 4. SCHEMA MART : DONNEES ANALYTIQUES
-- ============================================================

CREATE SCHEMA IF NOT EXISTS SNOWCREDIT_DB.MART
    COMMENT = 'Indicateurs metier et analyses du risque de credit';

-- ============================================================
-- 5. VERIFICATION DES SCHEMAS
-- ============================================================

SHOW SCHEMAS IN DATABASE SNOWCREDIT_DB;
