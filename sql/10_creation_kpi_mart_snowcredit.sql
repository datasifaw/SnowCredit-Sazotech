
-- ============================================================
-- PROJET     : SnowCredit Sazotech
-- ENTREPRISE : SAZOTECH SOLUTIONS
-- PLATEFORME : Snowflake
-- FICHIER    : 10_creation_kpi_mart_snowcredit.sql
-- OBJECTIF   : Creation des 6 KPI du portefeuille de credits
-- ============================================================


-- ============================================================
-- 1. CONFIGURATION DU CONTEXTE SNOWFLAKE
-- ============================================================

USE WAREHOUSE SNOWCREDIT_WH;

USE DATABASE SNOWCREDIT_DB;

USE SCHEMA MART;


-- ============================================================
-- 2. CREATION DE LA TABLE DES KPI
-- ============================================================
--
-- Source :
-- SNOWCREDIT_DB.CLEAN.CREDITS_NETTOYES
--
-- Destination :
-- SNOWCREDIT_DB.MART.KPI_PORTEFEUILLE_CREDIT
--
-- KPI :
-- 1. Nombre total de dossiers de credit
-- 2. Nombre de bons risques
-- 3. Nombre de mauvais risques
-- 4. Taux de mauvais risque en pourcentage
-- 5. Montant total des credits
-- 6. Duree moyenne des credits en mois
--
-- La table MART peut etre reconstruite sans modifier RAW
-- ou CLEAN.
-- ============================================================

CREATE OR REPLACE TABLE
    SNOWCREDIT_DB.MART.KPI_PORTEFEUILLE_CREDIT

AS

SELECT

    -- KPI 1 : Nombre total de dossiers
    COUNT(*)
        AS NOMBRE_TOTAL_CREDITS,


    -- KPI 2 : Nombre de bons risques
    SUM(
        IFF(CLASSE_RISQUE = 1, 1, 0)
    ) AS NOMBRE_BONS_RISQUES,


    -- KPI 3 : Nombre de mauvais risques
    SUM(
        IFF(CLASSE_RISQUE = 2, 1, 0)
    ) AS NOMBRE_MAUVAIS_RISQUES,


    -- KPI 4 : Taux de mauvais risque (%)
    -- NULLIF evite une division par zero.
    ROUND(
        100.0
        * SUM(IFF(CLASSE_RISQUE = 2, 1, 0))
        / NULLIF(COUNT(*), 0),
        2
    ) AS TAUX_MAUVAIS_RISQUE_PCT,


    -- KPI 5 : Montant total des credits
    -- Unite monetaire non precisee dans le dataset.
    COALESCE(
        SUM(MONTANT_CREDIT),
        0
    ) AS MONTANT_TOTAL_CREDITS,


    -- KPI 6 : Duree moyenne en mois
    ROUND(
        AVG(DUREE_MOIS),
        2
    ) AS DUREE_MOYENNE_MOIS


FROM SNOWCREDIT_DB.CLEAN.CREDITS_NETTOYES;


-- ============================================================
-- 3. VERIFICATION DE LA TABLE MART
-- ============================================================

SHOW TABLES LIKE 'KPI_PORTEFEUILLE_CREDIT'
IN SCHEMA SNOWCREDIT_DB.MART;


-- ============================================================
-- 4. AFFICHAGE DES SIX KPI
-- ============================================================

SELECT

    NOMBRE_TOTAL_CREDITS,
    NOMBRE_BONS_RISQUES,
    NOMBRE_MAUVAIS_RISQUES,
    TAUX_MAUVAIS_RISQUE_PCT,
    MONTANT_TOTAL_CREDITS,
    DUREE_MOYENNE_MOIS

FROM SNOWCREDIT_DB.MART.KPI_PORTEFEUILLE_CREDIT;


-- ============================================================
-- 5. CONTROLE DE COHERENCE
-- ============================================================
-- Les classes 1 et 2 doivent couvrir les 1000 dossiers.
-- Le resultat attendu est TRUE.
-- ============================================================

SELECT

    NOMBRE_TOTAL_CREDITS,

    NOMBRE_BONS_RISQUES + NOMBRE_MAUVAIS_RISQUES
        AS TOTAL_CLASSES_RISQUE,

    (
        NOMBRE_TOTAL_CREDITS =
        NOMBRE_BONS_RISQUES + NOMBRE_MAUVAIS_RISQUES
    ) AS REPARTITION_COHERENTE

FROM SNOWCREDIT_DB.MART.KPI_PORTEFEUILLE_CREDIT;


-- ============================================================
-- 6. VERIFICATION DE LA STRUCTURE
-- ============================================================

DESCRIBE TABLE
    SNOWCREDIT_DB.MART.KPI_PORTEFEUILLE_CREDIT;


-- ============================================================
-- FIN DU SCRIPT
-- ============================================================
