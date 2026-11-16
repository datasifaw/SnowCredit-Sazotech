
-- ============================================================
-- PROJET     : SnowCredit Sazotech
-- ENTREPRISE : SAZOTECH SOLUTIONS
-- PLATEFORME : Snowflake
-- FICHIER    : 07_verification_stage_snowcredit.sql
-- OBJECTIF   : Verification du fichier dans le Stage
-- ============================================================

-- ============================================================
-- 1. SELECTION DU CONTEXTE
-- ============================================================

USE DATABASE SNOWCREDIT_DB;

USE SCHEMA RAW;

-- ============================================================
-- 2. VERIFICATION DES FICHIERS DANS LE STAGE
-- ============================================================
-- La commande LIST permet d'afficher :
-- - Le nom du fichier
-- - Sa taille en octets
-- - Sa date de derniere modification
-- - Ses metadonnees
-- ============================================================

LIST @SNOWCREDIT_DB.RAW.STG_GERMAN_CREDIT;

-- ============================================================
-- FIN DU SCRIPT
-- ============================================================
