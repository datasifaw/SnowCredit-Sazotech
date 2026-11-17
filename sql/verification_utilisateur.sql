
-- ============================================================
-- PROJET   : SnowCredit Sazotech
-- OBJECTIF : Diagnostic de l'attribution du role Streamlit
-- ============================================================

-- 1. Utiliser le role administrateur

USE ROLE ACCOUNTADMIN;


-- 2. Identifier l'utilisateur et le role de la session

SELECT
    CURRENT_USER() AS UTILISATEUR_SESSION,
    CURRENT_ROLE() AS ROLE_SESSION;


-- 3. Lister les utilisateurs existants

SHOW USERS;


-- 4. Afficher uniquement leurs identifiants Snowflake
-- sans exposer les adresses e-mail ni les noms complets

SELECT
    "name" AS NOM_UTILISATEUR_SNOWFLAKE

FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()))

ORDER BY "name";


-- ============================================================
-- FIN DU DIAGNOSTIC
-- ============================================================
