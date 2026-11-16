
-- ============================================================
-- PROJET     : SnowCredit Sazotech
-- ENTREPRISE : SAZOTECH SOLUTIONS
-- PLATEFORME : Snowflake
-- FICHIER    : 12_mart_risque_par_montant.sql
-- OBJECTIF   : Analyse du risque par tranche de montant
-- ============================================================


-- ============================================================
-- 1. CONFIGURATION SNOWFLAKE
-- ============================================================

USE WAREHOUSE SNOWCREDIT_WH;

USE DATABASE SNOWCREDIT_DB;

USE SCHEMA MART;


-- ============================================================
-- 2. CREATION DE LA TABLE ANALYTIQUE
-- ============================================================
-- Source : CLEAN.CREDITS_NETTOYES
-- Cible  : MART.RISQUE_PAR_TRANCHE_MONTANT
--
-- Nous classons les credits selon leur montant.
-- Les montants manquants ou invalides sont conserves
-- dans des categories distinctes pour eviter toute perte.
--
-- Le taux de mauvais risque est calcule par tranche.
-- Il ne represente pas un taux de defaut constate.
-- ============================================================

CREATE OR REPLACE TABLE
    SNOWCREDIT_DB.MART.RISQUE_PAR_TRANCHE_MONTANT

AS

WITH DOSSIERS_CLASSES AS (

    SELECT

        MONTANT_CREDIT,

        CLASSE_RISQUE,

        -- Ordre des tranches pour les graphiques
        CASE

            WHEN MONTANT_CREDIT IS NULL THEN 6

            WHEN MONTANT_CREDIT <= 0 THEN 5

            WHEN MONTANT_CREDIT < 2000 THEN 1

            WHEN MONTANT_CREDIT < 5000 THEN 2

            WHEN MONTANT_CREDIT < 10000 THEN 3

            ELSE 4

        END AS ORDRE_TRANCHE,


        -- Libelles des tranches en francais
        CASE

            WHEN MONTANT_CREDIT IS NULL
                THEN 'Montant non renseigne'

            WHEN MONTANT_CREDIT <= 0
                THEN 'Montant invalide'

            WHEN MONTANT_CREDIT < 2000
                THEN 'Moins de 2000'

            WHEN MONTANT_CREDIT < 5000
                THEN '2000 a 4999'

            WHEN MONTANT_CREDIT < 10000
                THEN '5000 a 9999'

            ELSE '10000 et plus'

        END AS TRANCHE_MONTANT

    FROM SNOWCREDIT_DB.CLEAN.CREDITS_NETTOYES

)

SELECT

    ORDRE_TRANCHE,

    TRANCHE_MONTANT,

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

    -- Taux de mauvais risque par tranche
    ROUND(
        100.0
        * SUM(IFF(CLASSE_RISQUE = 2, 1, 0))
        / NULLIF(COUNT(*), 0),
        2
    ) AS TAUX_MAUVAIS_RISQUE_PCT

FROM DOSSIERS_CLASSES

GROUP BY
    ORDRE_TRANCHE,
    TRANCHE_MONTANT;


-- ============================================================
-- 3. VERIFIER LA CREATION DE LA TABLE
-- ============================================================

SHOW TABLES LIKE 'RISQUE_PAR_TRANCHE_MONTANT'
IN SCHEMA SNOWCREDIT_DB.MART;


-- ============================================================
-- 4. AFFICHER LES RESULTATS DE L'ANALYSE
-- ============================================================

SELECT

    TRANCHE_MONTANT,

    NOMBRE_DOSSIERS,

    NOMBRE_BONS_RISQUES,

    NOMBRE_MAUVAIS_RISQUES,

    TAUX_MAUVAIS_RISQUE_PCT

FROM SNOWCREDIT_DB.MART.RISQUE_PAR_TRANCHE_MONTANT

ORDER BY ORDRE_TRANCHE;


-- ============================================================
-- 5. CONTROLE DE COHERENCE
-- ============================================================
-- Nous verifions :
--
-- 1. Le total des dossiers dans CLEAN.
-- 2. Le total des dossiers dans MART.
-- 3. Le total des bons risques.
-- 4. Le total des mauvais risques.
-- 5. L'absence de perte de dossiers.
--
-- Resultats attendus :
-- 1000 dossiers
-- 700 bons risques
-- 300 mauvais risques
-- TRUE pour REPARTITION_COHERENTE
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

FROM SNOWCREDIT_DB.MART.RISQUE_PAR_TRANCHE_MONTANT;


-- ============================================================
-- 6. VERIFIER LA STRUCTURE
-- ============================================================

DESCRIBE TABLE
    SNOWCREDIT_DB.MART.RISQUE_PAR_TRANCHE_MONTANT;


-- ============================================================
-- FIN DU SCRIPT
-- ============================================================
