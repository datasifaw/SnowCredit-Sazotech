
-- ============================================================
-- PROJET     : SnowCredit Sazotech
-- ENTREPRISE : SAZOTECH SOLUTIONS
-- PLATEFORME : Snowflake
-- FICHIER    : 05_creation_format_snowcredit.sql
-- OBJECTIF   : Configurer le format des donnees bancaires
-- ============================================================

-- ============================================================
-- 1. SELECTION DU CONTEXTE
-- ============================================================

USE DATABASE SNOWCREDIT_DB;

USE SCHEMA RAW;

-- ============================================================
-- 2. CREATION DU FORMAT DE FICHIER
-- ============================================================
-- Le fichier german.data contient :
-- - 1000 lignes
-- - 21 colonnes
-- - Des valeurs separees par des espaces
-- - Aucun en-tete
--
-- CSV designe ici un format de texte delimite.
-- Le separateur utilise est un espace.
-- ============================================================

CREATE FILE FORMAT IF NOT EXISTS
    SNOWCREDIT_DB.RAW.FF_GERMAN_DATA

    TYPE = CSV

    COMPRESSION = NONE

    FIELD_DELIMITER = ' '

    RECORD_DELIMITER = '\n'

    SKIP_HEADER = 0

    MULTI_LINE = FALSE

    FIELD_OPTIONALLY_ENCLOSED_BY = NONE

    TRIM_SPACE = FALSE

    ESCAPE_UNENCLOSED_FIELD = NONE

    ERROR_ON_COLUMN_COUNT_MISMATCH = TRUE

    COMMENT = 'Format du dataset German Credit pour SnowCredit Sazotech';

-- ============================================================
-- 3. VERIFIER LA CREATION
-- ============================================================

SHOW FILE FORMATS LIKE 'FF_GERMAN_DATA'
IN SCHEMA SNOWCREDIT_DB.RAW;

-- ============================================================
-- 4. VERIFIER LES PARAMETRES
-- ============================================================

DESCRIBE FILE FORMAT SNOWCREDIT_DB.RAW.FF_GERMAN_DATA;

-- ============================================================
-- FIN DU SCRIPT
-- ============================================================
