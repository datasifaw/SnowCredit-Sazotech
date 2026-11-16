
-- ============================================================
-- PROJET     : SnowCredit Sazotech
-- ENTREPRISE : SAZOTECH SOLUTIONS
-- PLATEFORME : Snowflake
-- FICHIER    : 06_creation_stage_snowcredit.sql
-- OBJECTIF   : Creation du stage interne pour les credits
-- ============================================================

-- ============================================================
-- 1. SELECTION DU CONTEXTE
-- ============================================================

USE DATABASE SNOWCREDIT_DB;

USE SCHEMA RAW;

-- ============================================================
-- 2. CREATION DU STAGE INTERNE
-- ============================================================
-- Ce stage permettra de stocker le fichier german.data
-- avant son chargement dans la table RAW.CREDITS_BRUTS.
--
-- Nous reutilisons le format FF_GERMAN_DATA
-- cree a l'etape precedente.
-- ============================================================

CREATE STAGE IF NOT EXISTS
    SNOWCREDIT_DB.RAW.STG_GERMAN_CREDIT

    FILE_FORMAT = (
        FORMAT_NAME = 'SNOWCREDIT_DB.RAW.FF_GERMAN_DATA'
    )

    COMMENT = 'Stage interne des donnees de credit SnowCredit Sazotech';

-- ============================================================
-- 3. VERIFICATION DE LA CREATION
-- ============================================================

SHOW STAGES LIKE 'STG_GERMAN_CREDIT'
IN SCHEMA SNOWCREDIT_DB.RAW;

-- ============================================================
-- 4. VERIFICATION DES PARAMETRES
-- ============================================================

DESCRIBE STAGE SNOWCREDIT_DB.RAW.STG_GERMAN_CREDIT;

-- ============================================================
-- FIN DU SCRIPT
-- ============================================================
