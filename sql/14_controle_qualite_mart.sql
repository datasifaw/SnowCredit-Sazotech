
-- ============================================================
-- PROJET     : SnowCredit Sazotech
-- ENTREPRISE : SAZOTECH SOLUTIONS
-- PLATEFORME : Snowflake
-- FICHIER    : 14_controle_qualite_mart.sql
-- OBJECTIF   : Validation des quatre tables MART
-- ============================================================


-- ============================================================
-- 1. CONFIGURATION DU CONTEXTE
-- ============================================================

USE WAREHOUSE SNOWCREDIT_WH;

USE DATABASE SNOWCREDIT_DB;

USE SCHEMA MART;


-- ============================================================
-- 2. CONTROLE GLOBAL DES TABLES MART
-- ============================================================
-- Le script ne modifie aucune donnee.
--
-- Pour chaque table, nous verifions :
-- - Nombre de lignes dans la table analytique
-- - Nombre total de dossiers
-- - Nombre de bons risques
-- - Nombre de mauvais risques
-- - Coherence des resultats
-- ============================================================

WITH CONTROLES AS (

    -- --------------------------------------------------------
    -- CONTROLE 1 : KPI GLOBAUX
    -- --------------------------------------------------------

    SELECT
        'KPI GLOBAUX' AS ANALYSE,

        COUNT(*) AS LIGNES_MART,

        COALESCE(SUM(NOMBRE_TOTAL_CREDITS), 0)
            AS TOTAL_DOSSIERS,

        COALESCE(SUM(NOMBRE_BONS_RISQUES), 0)
            AS BONS_RISQUES,

        COALESCE(SUM(NOMBRE_MAUVAIS_RISQUES), 0)
            AS MAUVAIS_RISQUES,

        IFF(
            COUNT(*) = 1
            AND COALESCE(SUM(NOMBRE_TOTAL_CREDITS), 0) = 1000
            AND COALESCE(SUM(NOMBRE_BONS_RISQUES), 0) = 700
            AND COALESCE(SUM(NOMBRE_MAUVAIS_RISQUES), 0) = 300
            AND MAX(TAUX_MAUVAIS_RISQUE_PCT) = 30
            AND MAX(MONTANT_TOTAL_CREDITS) > 0
            AND MAX(DUREE_MOYENNE_MOIS) > 0,
            'OK',
            'A VERIFIER'
        ) AS STATUT

    FROM SNOWCREDIT_DB.MART.KPI_PORTEFEUILLE_CREDIT


    UNION ALL


    -- --------------------------------------------------------
    -- CONTROLE 2 : REPARTITION DES RISQUES
    -- --------------------------------------------------------

    SELECT
        'REPARTITION RISQUES',

        COUNT(*),

        COALESCE(SUM(NOMBRE_DOSSIERS), 0),

        COALESCE(SUM(
            IFF(CLASSE_RISQUE = 1, NOMBRE_DOSSIERS, 0)
        ), 0),

        COALESCE(SUM(
            IFF(CLASSE_RISQUE = 2, NOMBRE_DOSSIERS, 0)
        ), 0),

        IFF(
            COUNT(*) = 2
            AND COALESCE(SUM(NOMBRE_DOSSIERS), 0) = 1000
            AND COALESCE(SUM(
                IFF(CLASSE_RISQUE = 1, NOMBRE_DOSSIERS, 0)
            ), 0) = 700
            AND COALESCE(SUM(
                IFF(CLASSE_RISQUE = 2, NOMBRE_DOSSIERS, 0)
            ), 0) = 300
            AND SUM(POURCENTAGE_DOSSIERS) = 100,
            'OK',
            'A VERIFIER'
        )

    FROM SNOWCREDIT_DB.MART.REPARTITION_RISQUES


    UNION ALL


    -- --------------------------------------------------------
    -- CONTROLE 3 : RISQUE PAR MONTANT
    -- --------------------------------------------------------

    SELECT
        'RISQUE PAR MONTANT',

        COUNT(*),

        COALESCE(SUM(NOMBRE_DOSSIERS), 0),

        COALESCE(SUM(NOMBRE_BONS_RISQUES), 0),

        COALESCE(SUM(NOMBRE_MAUVAIS_RISQUES), 0),

        IFF(
            COALESCE(SUM(NOMBRE_DOSSIERS), 0) = 1000
            AND COALESCE(SUM(NOMBRE_BONS_RISQUES), 0) = 700
            AND COALESCE(SUM(NOMBRE_MAUVAIS_RISQUES), 0) = 300
            AND COALESCE(SUM(
                IFF(
                    ORDRE_TRANCHE IN (5, 6),
                    NOMBRE_DOSSIERS,
                    0
                )
            ), 0) = 0,
            'OK',
            'A VERIFIER'
        )

    FROM SNOWCREDIT_DB.MART.RISQUE_PAR_TRANCHE_MONTANT


    UNION ALL


    -- --------------------------------------------------------
    -- CONTROLE 4 : RISQUE PAR DUREE
    -- --------------------------------------------------------

    SELECT
        'RISQUE PAR DUREE',

        COUNT(*),

        COALESCE(SUM(NOMBRE_DOSSIERS), 0),

        COALESCE(SUM(NOMBRE_BONS_RISQUES), 0),

        COALESCE(SUM(NOMBRE_MAUVAIS_RISQUES), 0),

        IFF(
            COALESCE(SUM(NOMBRE_DOSSIERS), 0) = 1000
            AND COALESCE(SUM(NOMBRE_BONS_RISQUES), 0) = 700
            AND COALESCE(SUM(NOMBRE_MAUVAIS_RISQUES), 0) = 300
            AND COALESCE(SUM(
                IFF(
                    ORDRE_TRANCHE IN (5, 6),
                    NOMBRE_DOSSIERS,
                    0
                )
            ), 0) = 0,
            'OK',
            'A VERIFIER'
        )

    FROM SNOWCREDIT_DB.MART.RISQUE_PAR_DUREE

)

SELECT
    ANALYSE,
    LIGNES_MART,
    TOTAL_DOSSIERS,
    BONS_RISQUES,
    MAUVAIS_RISQUES,
    STATUT

FROM CONTROLES

ORDER BY ANALYSE;


-- ============================================================
-- 3. VERIFICATION DES SIX KPI
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
-- FIN DU SCRIPT
-- ============================================================
