
-- ============================================================
-- PROJET     : SnowCredit Sazotech
-- ENTREPRISE : SAZOTECH SOLUTIONS
-- PLATEFORME : Snowflake
-- FICHIER    : 02_creation_base_snowcredit.sql
-- OBJECTIF   : Creation de la base de donnees du projet
-- ============================================================

-- 1. Creation de la base de donnees
CREATE DATABASE IF NOT EXISTS SNOWCREDIT_DB
    COMMENT = 'Base de donnees du projet SnowCredit Sazotech';

-- 2. Verification de la creation
SHOW DATABASES LIKE 'SNOWCREDIT_DB';
