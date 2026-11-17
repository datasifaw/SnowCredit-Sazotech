
-- ============================================================
-- PROJET     : SnowCredit Sazotech
-- ENTREPRISE : SAZOTECH SOLUTIONS
-- PLATEFORME : Snowflake
-- FICHIER    : 16_permissions_role_streamlit.sql
-- OBJECTIF   : Configurer les permissions du role Streamlit
-- VERSION    : 1.1 - Correction de l'identifiant utilisateur
-- ============================================================


-- ============================================================
-- 1. UTILISER LE ROLE ADMINISTRATEUR
-- ============================================================

USE ROLE ACCOUNTADMIN;


-- ============================================================
-- 2. ACCES A LA BASE DE DONNEES
-- ============================================================

GRANT USAGE
ON DATABASE SNOWCREDIT_DB
TO ROLE SNOWCREDIT_APP_ROLE;


-- ============================================================
-- 3. ACCES AU SCHEMA DE L'APPLICATION
-- ============================================================

GRANT USAGE
ON SCHEMA SNOWCREDIT_DB.PUBLIC
TO ROLE SNOWCREDIT_APP_ROLE;

GRANT CREATE STREAMLIT
ON SCHEMA SNOWCREDIT_DB.PUBLIC
TO ROLE SNOWCREDIT_APP_ROLE;


-- ============================================================
-- 4. ACCES AU SCHEMA ANALYTIQUE MART
-- ============================================================

GRANT USAGE
ON SCHEMA SNOWCREDIT_DB.MART
TO ROLE SNOWCREDIT_APP_ROLE;


-- ============================================================
-- 5. LECTURE DES TABLES MART
-- ============================================================

-- KPI du portefeuille bancaire

GRANT SELECT
ON TABLE SNOWCREDIT_DB.MART.KPI_PORTEFEUILLE_CREDIT
TO ROLE SNOWCREDIT_APP_ROLE;


-- Repartition des risques

GRANT SELECT
ON TABLE SNOWCREDIT_DB.MART.REPARTITION_RISQUES
TO ROLE SNOWCREDIT_APP_ROLE;


-- Analyse du risque selon le montant

GRANT SELECT
ON TABLE SNOWCREDIT_DB.MART.RISQUE_PAR_TRANCHE_MONTANT
TO ROLE SNOWCREDIT_APP_ROLE;


-- Analyse du risque selon la duree

GRANT SELECT
ON TABLE SNOWCREDIT_DB.MART.RISQUE_PAR_DUREE
TO ROLE SNOWCREDIT_APP_ROLE;


-- ============================================================
-- 6. UTILISATION DU WAREHOUSE
-- ============================================================

GRANT USAGE
ON WAREHOUSE SNOWCREDIT_WH
TO ROLE SNOWCREDIT_APP_ROLE;


-- ============================================================
-- 7. UTILISATION DU COMPUTE POOL
-- ============================================================

GRANT USAGE
ON COMPUTE POOL SYSTEM_COMPUTE_POOL_CPU
TO ROLE SNOWCREDIT_APP_ROLE;


-- ============================================================
-- 8. ATTRIBUTION DU ROLE A L'UTILISATEUR
-- ============================================================
-- CORRECTION :
--
-- SHOW USERS a confirme que le nom interne du compte
-- est en minuscules.
--
-- Les guillemets doubles conservent la casse exacte.
--
-- Cette commande attribue uniquement le role dedie
-- a l'application. Elle n'accorde pas ACCOUNTADMIN.
-- ============================================================

GRANT ROLE SNOWCREDIT_APP_ROLE
TO USER "s_azoughli";


-- ============================================================
-- 9. VERIFICATION DES PERMISSIONS DU ROLE
-- ============================================================

SHOW GRANTS TO ROLE SNOWCREDIT_APP_ROLE;


-- ============================================================
-- 10. VERIFICATION DE L'ATTRIBUTION A L'UTILISATEUR
-- ============================================================

SHOW GRANTS TO USER "s_azoughli";


-- ============================================================
-- FIN DU SCRIPT
-- ============================================================
