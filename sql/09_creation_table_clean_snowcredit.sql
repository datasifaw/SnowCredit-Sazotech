
-- ============================================================
-- PROJET     : SnowCredit Sazotech
-- ENTREPRISE : SAZOTECH SOLUTIONS
-- PLATEFORME : Snowflake
-- FICHIER    : 09_creation_table_clean_snowcredit.sql
-- OBJECTIF   : Nettoyage et conversion des donnees bancaires
-- ============================================================


-- ============================================================
-- 1. CONFIGURATION DU CONTEXTE
-- ============================================================

USE WAREHOUSE SNOWCREDIT_WH;

USE DATABASE SNOWCREDIT_DB;

USE SCHEMA CLEAN;


-- ============================================================
-- 2. CREATION DE LA TABLE CLEAN
-- ============================================================
-- Source : RAW.CREDITS_BRUTS
-- Cible  : CLEAN.CREDITS_NETTOYES
--
-- Les codes categoriels restent au format VARCHAR.
-- Les colonnes numeriques sont converties en NUMBER.
--
-- TRY_TO_NUMBER retourne NULL en cas de conversion impossible.
-- NULLIF transforme une chaine vide en NULL.
--
-- CREATE OR REPLACE permet de reconstruire la table CLEAN.
-- Attention : une table CLEAN existante serait remplacee.
-- La table RAW ne sera pas modifiee.
-- ============================================================

CREATE OR REPLACE TABLE
    SNOWCREDIT_DB.CLEAN.CREDITS_NETTOYES

AS

SELECT

    -- 1. Statut du compte bancaire
    NULLIF(TRIM(STATUT_COMPTE), '')
        AS STATUT_COMPTE,

    -- 2. Duree du credit en mois
    TRY_TO_NUMBER(NULLIF(TRIM(DUREE_MOIS), ''))
        AS DUREE_MOIS,

    -- 3. Historique de credit
    NULLIF(TRIM(HISTORIQUE_CREDIT), '')
        AS HISTORIQUE_CREDIT,

    -- 4. Objet du credit
    NULLIF(TRIM(OBJET_CREDIT), '')
        AS OBJET_CREDIT,

    -- 5. Montant du credit
    TRY_TO_NUMBER(NULLIF(TRIM(MONTANT_CREDIT), ''))
        AS MONTANT_CREDIT,

    -- 6. Epargne
    NULLIF(TRIM(EPARGNE), '')
        AS EPARGNE,

    -- 7. Anciennete dans l'emploi
    NULLIF(TRIM(ANCIENNETE_EMPLOI), '')
        AS ANCIENNETE_EMPLOI,

    -- 8. Part de la mensualite dans le revenu
    TRY_TO_NUMBER(
        NULLIF(TRIM(PART_MENSUALITE_REVENU), '')
    ) AS PART_MENSUALITE_REVENU,

    -- 9. Statut personnel
    NULLIF(TRIM(STATUT_PERSONNEL), '')
        AS STATUT_PERSONNEL,

    -- 10. Autres debiteurs ou garants
    NULLIF(TRIM(AUTRES_DEBITEURS), '')
        AS AUTRES_DEBITEURS,

    -- 11. Anciennete de residence
    TRY_TO_NUMBER(
        NULLIF(TRIM(ANCIENNETE_RESIDENCE), '')
    ) AS ANCIENNETE_RESIDENCE,

    -- 12. Patrimoine
    NULLIF(TRIM(PATRIMOINE), '')
        AS PATRIMOINE,

    -- 13. Age
    TRY_TO_NUMBER(NULLIF(TRIM(AGE), ''))
        AS AGE,

    -- 14. Autres plans de credit
    NULLIF(TRIM(AUTRES_PLANS_CREDIT), '')
        AS AUTRES_PLANS_CREDIT,

    -- 15. Logement
    NULLIF(TRIM(LOGEMENT), '')
        AS LOGEMENT,

    -- 16. Nombre de credits existants
    TRY_TO_NUMBER(
        NULLIF(TRIM(NOMBRE_CREDITS_EXISTANTS), '')
    ) AS NOMBRE_CREDITS_EXISTANTS,

    -- 17. Emploi
    NULLIF(TRIM(EMPLOI), '')
        AS EMPLOI,

    -- 18. Nombre de personnes a charge
    TRY_TO_NUMBER(
        NULLIF(TRIM(PERSONNES_A_CHARGE), '')
    ) AS PERSONNES_A_CHARGE,

    -- 19. Telephone
    NULLIF(TRIM(TELEPHONE), '')
        AS TELEPHONE,

    -- 20. Travailleur etranger
    NULLIF(TRIM(TRAVAILLEUR_ETRANGER), '')
        AS TRAVAILLEUR_ETRANGER,

    -- 21. Classe de risque
    TRY_TO_NUMBER(NULLIF(TRIM(CLASSE_RISQUE), ''))
        AS CLASSE_RISQUE,

    -- 22. Libelle du risque en francais
    CASE
        WHEN TRIM(CLASSE_RISQUE) = '1'
            THEN 'Bon risque'

        WHEN TRIM(CLASSE_RISQUE) = '2'
            THEN 'Mauvais risque'

        ELSE 'Inconnu'
    END AS LIBELLE_RISQUE

FROM SNOWCREDIT_DB.RAW.CREDITS_BRUTS;


-- ============================================================
-- 3. VERIFIER LA CREATION DE LA TABLE
-- ============================================================

SHOW TABLES LIKE 'CREDITS_NETTOYES'
IN SCHEMA SNOWCREDIT_DB.CLEAN;


-- ============================================================
-- 4. VERIFIER LE NOMBRE DE DOSSIERS
-- ============================================================

SELECT
    COUNT(*) AS NOMBRE_TOTAL_CREDITS
FROM SNOWCREDIT_DB.CLEAN.CREDITS_NETTOYES;


-- ============================================================
-- 5. VERIFIER LES CLASSES DE RISQUE
-- ============================================================

SELECT
    CLASSE_RISQUE,
    LIBELLE_RISQUE,
    COUNT(*) AS NOMBRE_DOSSIERS

FROM SNOWCREDIT_DB.CLEAN.CREDITS_NETTOYES

GROUP BY
    CLASSE_RISQUE,
    LIBELLE_RISQUE

ORDER BY CLASSE_RISQUE;


-- ============================================================
-- 6. CONTROLE DES CONVERSIONS NUMERIQUES
-- ============================================================
-- Compte les lignes ayant au moins une valeur numerique
-- manquante ou impossible a convertir.
-- Le resultat attendu est 0.
-- ============================================================

SELECT
    COUNT(*) AS TOTAL_DOSSIERS,

    SUM(
        IFF(
            DUREE_MOIS IS NULL
            OR MONTANT_CREDIT IS NULL
            OR PART_MENSUALITE_REVENU IS NULL
            OR ANCIENNETE_RESIDENCE IS NULL
            OR AGE IS NULL
            OR NOMBRE_CREDITS_EXISTANTS IS NULL
            OR PERSONNES_A_CHARGE IS NULL
            OR CLASSE_RISQUE IS NULL,
            1,
            0
        )
    ) AS LIGNES_AVEC_ANOMALIE_NUMERIQUE

FROM SNOWCREDIT_DB.CLEAN.CREDITS_NETTOYES;


-- ============================================================
-- 7. VERIFIER LA STRUCTURE DES COLONNES
-- ============================================================

DESCRIBE TABLE SNOWCREDIT_DB.CLEAN.CREDITS_NETTOYES;


-- ============================================================
-- FIN DU SCRIPT
-- ============================================================
