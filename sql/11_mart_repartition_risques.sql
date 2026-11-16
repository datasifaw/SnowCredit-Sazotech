
-- ============================================================
-- PROJET     : SnowCredit Sazotech
-- ENTREPRISE : SAZOTECH SOLUTIONS
-- PLATEFORME : Snowflake
-- FICHIER    : 11_mart_repartition_risques.sql
-- OBJECTIF   : Analyse de la repartition des risques
-- ============================================================


-- ============================================================
-- 1. CONFIGURATION DU CONTEXTE SNOWFLAKE
-- ============================================================

USE WAREHOUSE SNOWCREDIT_WH;

USE DATABASE SNOWCREDIT_DB;

USE SCHEMA MART;


-- ============================================================
-- 2. CREATION DE LA TABLE ANALYTIQUE
-- ============================================================
-- Source : CLEAN.CREDITS_NETTOYES
-- Cible  : MART.REPARTITION_RISQUES
--
-- Cette table contient :
-- - La classe de risque
-- - Le libelle en francais
-- - Le nombre de dossiers
-- - Le pourcentage du portefeuille
--
-- Attention :
-- CREATE OR REPLACE remplace la table MART existante
-- portant ce nom, sans modifier les tables RAW et CLEAN.
-- ============================================================

CREATE OR REPLACE TABLE
    SNOWCREDIT_DB.MART.REPARTITION_RISQUES

AS

SELECT

    CLASSE_RISQUE,

    LIBELLE_RISQUE,

    COUNT(*) AS NOMBRE_DOSSIERS,

    ROUND(
        100.0 * COUNT(*)
        / NULLIF(
            (
                SELECT COUNT(*)
                FROM SNOWCREDIT_DB.CLEAN.CREDITS_NETTOYES
            ),
            0
        ),
        2
    ) AS POURCENTAGE_DOSSIERS

FROM SNOWCREDIT_DB.CLEAN.CREDITS_NETTOYES

GROUP BY
    CLASSE_RISQUE,
    LIBELLE_RISQUE;


-- ============================================================
-- 3. VERIFIER LA CREATION DE LA TABLE
-- ============================================================

SHOW TABLES LIKE 'REPARTITION_RISQUES'
IN SCHEMA SNOWCREDIT_DB.MART;


-- ============================================================
-- 4. AFFICHER LES DONNEES DU FUTUR GRAPHIQUE
-- ============================================================

SELECT

    CLASSE_RISQUE,

    LIBELLE_RISQUE,

    NOMBRE_DOSSIERS,

    POURCENTAGE_DOSSIERS

FROM SNOWCREDIT_DB.MART.REPARTITION_RISQUES

ORDER BY CLASSE_RISQUE;


-- ============================================================
-- 5. CONTROLE DES TOTAUX
-- ============================================================
-- Resultats attendus :
-- TOTAL_DOSSIERS = 1000
-- TOTAL_POURCENTAGE = 100.00
-- ============================================================

SELECT

    SUM(NOMBRE_DOSSIERS)
        AS TOTAL_DOSSIERS,

    SUM(POURCENTAGE_DOSSIERS)
        AS TOTAL_POURCENTAGE

FROM SNOWCREDIT_DB.MART.REPARTITION_RISQUES;


-- ============================================================
-- 6. VERIFICATION DE LA STRUCTURE
-- ============================================================

DESCRIBE TABLE
    SNOWCREDIT_DB.MART.REPARTITION_RISQUES;


-- ============================================================
-- FIN DU SCRIPT
-- ============================================================
