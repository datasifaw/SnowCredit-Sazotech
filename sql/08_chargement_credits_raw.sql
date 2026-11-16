
-- ============================================================
-- PROJET     : SnowCredit Sazotech
-- ENTREPRISE : SAZOTECH SOLUTIONS
-- PLATEFORME : Snowflake
-- FICHIER    : 08_chargement_credits_raw.sql
-- OBJECTIF   : Chargement des credits bancaires dans RAW
-- ============================================================


-- ============================================================
-- 1. CONFIGURATION DU CONTEXTE SNOWFLAKE
-- ============================================================

USE WAREHOUSE SNOWCREDIT_WH;

USE DATABASE SNOWCREDIT_DB;

USE SCHEMA RAW;


-- ============================================================
-- 2. VERIFICATION AVANT CHARGEMENT
-- ============================================================
-- La table doit normalement etre vide (0 ligne).
-- Si elle contient deja des donnees, arreter ici.

SELECT
    COUNT(*) AS NOMBRE_LIGNES_AVANT_CHARGEMENT
FROM SNOWCREDIT_DB.RAW.CREDITS_BRUTS;


-- ============================================================
-- 3. CHARGEMENT DES DONNEES
-- ============================================================
-- Source      : STG_GERMAN_CREDIT/german.data
-- Destination : RAW.CREDITS_BRUTS
-- Format      : FF_GERMAN_DATA
--
-- ON_ERROR : arreter le chargement en cas d'erreur.
-- FORCE    : ne pas recharger un fichier deja charge.
-- PURGE    : conserver le fichier dans le Stage.
-- ============================================================

COPY INTO SNOWCREDIT_DB.RAW.CREDITS_BRUTS

FROM @SNOWCREDIT_DB.RAW.STG_GERMAN_CREDIT

FILES = ('german.data')

FILE_FORMAT = (
    FORMAT_NAME = 'SNOWCREDIT_DB.RAW.FF_GERMAN_DATA'
)

ON_ERROR = ABORT_STATEMENT

FORCE = FALSE

PURGE = FALSE;


-- ============================================================
-- 4. VERIFICATION DU NOMBRE DE LIGNES
-- ============================================================

SELECT
    COUNT(*) AS NOMBRE_TOTAL_CREDITS
FROM SNOWCREDIT_DB.RAW.CREDITS_BRUTS;


-- ============================================================
-- 5. VERIFICATION DES CLASSES DE RISQUE
-- ============================================================
-- 1 = Bon risque
-- 2 = Mauvais risque
-- Ces valeurs sont celles du dataset original.

SELECT
    CLASSE_RISQUE,
    COUNT(*) AS NOMBRE_DOSSIERS
FROM SNOWCREDIT_DB.RAW.CREDITS_BRUTS
GROUP BY CLASSE_RISQUE
ORDER BY CLASSE_RISQUE;


-- ============================================================
-- FIN DU SCRIPT
-- ============================================================
