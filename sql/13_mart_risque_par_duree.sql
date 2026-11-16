
-- ============================================================
-- PROJET     : SnowCredit Sazotech
-- ENTREPRISE : SAZOTECH SOLUTIONS
-- PLATEFORME : Snowflake
-- FICHIER    : 13_mart_risque_par_duree.sql
-- OBJECTIF   : Analyse du risque selon la duree du credit
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
-- Cible  : MART.RISQUE_PAR_DUREE
--
-- Categories :
-- 1 : 1 a 12 mois
-- 2 : 13 a 24 mois
-- 3 : 25 a 36 mois
-- 4 : Plus de 36 mois
-- 5 : Duree invalide
-- 6 : Duree non renseignee
--
-- Les categories 5 et 6 evitent de perdre des dossiers.
-- ============================================================

CREATE OR REPLACE TABLE
    SNOWCREDIT_DB.MART.RISQUE_PAR_DUREE

AS

WITH DOSSIERS_CLASSES AS (

    SELECT

        DUREE_MOIS,

        CLASSE_RISQUE,

        -- Ordre des tranches
        CASE

            WHEN DUREE_MOIS IS NULL THEN 6

            WHEN DUREE_MOIS <= 0 THEN 5

            WHEN DUREE_MOIS <= 12 THEN 1

            WHEN DUREE_MOIS <= 24 THEN 2

            WHEN DUREE_MOIS <= 36 THEN 3

            ELSE 4

        END AS ORDRE_TRANCHE,


        -- Libelles en francais
        CASE

            WHEN DUREE_MOIS IS NULL
                THEN 'Duree non renseignee'

            WHEN DUREE_MOIS <= 0
                THEN 'Duree invalide'

            WHEN DUREE_MOIS <= 12
                THEN '1 a 12 mois'

            WHEN DUREE_MOIS <= 24
                THEN '13 a 24 mois'

            WHEN DUREE_MOIS <= 36
                THEN '25 a 36 mois'

            ELSE 'Plus de 36 mois'

        END AS TRANCHE_DUREE

    FROM SNOWCREDIT_DB.CLEAN.CREDITS_NETTOYES

)

SELECT

    ORDRE_TRANCHE,

    TRANCHE_DUREE,

    -- Nombre total de dossiers
    COUNT(*) AS NOMBRE_DOSSIERS,

    -- Nombre de bons risques
    SUM(
        IFF(CLASSE_RISQUE = 1, 1, 0)
    ) AS NOMBRE_BONS_RISQUES,

    -- Nombre de mauvais risques
    SUM(
        IFF(CLASSE_RISQUE = 2, 1, 0)
    ) AS NOMBRE_MAUVAIS_RISQUES,

    -- Taux de mauvais risque par tranche (%)
    ROUND(
        100.0
        * SUM(IFF(CLASSE_RISQUE = 2, 1, 0))
        / NULLIF(COUNT(*), 0),
        2
    ) AS TAUX_MAUVAIS_RISQUE_PCT

FROM DOSSIERS_CLASSES

GROUP BY
    ORDRE_TRANCHE,
    TRANCHE_DUREE;


-- ============================================================
-- 3. VERIFIER LA CREATION
-- ============================================================

SHOW TABLES LIKE 'RISQUE_PAR_DUREE'
IN SCHEMA SNOWCREDIT_DB.MART;


-- ============================================================
-- 4. AFFICHER LES RESULTATS
-- ============================================================

SELECT

    TRANCHE_DUREE,

    NOMBRE_DOSSIERS,

    NOMBRE_BONS_RISQUES,

    NOMBRE_MAUVAIS_RISQUES,

    TAUX_MAUVAIS_RISQUE_PCT

FROM SNOWCREDIT_DB.MART.RISQUE_PAR_DUREE

ORDER BY ORDRE_TRANCHE;


-- ============================================================
-- 5. CONTROLE DE COHERENCE
-- ============================================================
-- Resultats attendus :
-- 1000 dossiers dans CLEAN et MART
-- 700 bons risques
-- 300 mauvais risques
-- TRUE pour REPARTITION_COHERENTE
-- 0 dossier avec duree invalide ou manquante
-- ============================================================

SELECT

    (
        SELECT COUNT(*)
        FROM SNOWCREDIT_DB.CLEAN.CREDITS_NETTOYES
    ) AS TOTAL_SOURCE_CLEAN,

    SUM(NOMBRE_DOSSIERS)
        AS TOTAL_DOSSIERS_MART,

    SUM(NOMBRE_BONS_RISQUES)
        AS TOTAL_BONS_RISQUES,

    SUM(NOMBRE_MAUVAIS_RISQUES)
        AS TOTAL_MAUVAIS_RISQUES,

    SUM(
        IFF(ORDRE_TRANCHE IN (5, 6), NOMBRE_DOSSIERS, 0)
    ) AS DOSSIERS_DUREE_ANORMALE,

    (
        SUM(NOMBRE_DOSSIERS)
        =
        (
            SELECT COUNT(*)
            FROM SNOWCREDIT_DB.CLEAN.CREDITS_NETTOYES
        )
        AND
        SUM(NOMBRE_DOSSIERS)
        =
        SUM(NOMBRE_BONS_RISQUES)
        +
        SUM(NOMBRE_MAUVAIS_RISQUES)
    ) AS REPARTITION_COHERENTE

FROM SNOWCREDIT_DB.MART.RISQUE_PAR_DUREE;


-- ============================================================
-- 6. VERIFIER LA STRUCTURE
-- ============================================================

DESCRIBE TABLE
    SNOWCREDIT_DB.MART.RISQUE_PAR_DUREE;


-- ============================================================
-- FIN DU SCRIPT
-- ============================================================
