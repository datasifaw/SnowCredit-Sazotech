# ❄️ SnowCredit Sazotech

**Analyse du risque de crédit bancaire avec Snowflake et Streamlit**

*Un projet Data Engineering & Data Analytics — SAZOTECH SOLUTIONS*

![Tableau de bord SnowCredit Sazotech](<images/Tableau de bord du risque de crédit.png>)

> **Aperçu de l'application :** tableau de bord en français, thème bleu ciel, 6 indicateurs bancaires et 3 graphiques d'analyse sur une seule page.

## 🎯 Présentation

**SnowCredit Sazotech** est un projet de bout en bout qui transforme un jeu de données historique de crédits bancaires en un tableau de bord analytique interactif. Le traitement des données est réalisé dans **Snowflake**, tandis que l'interface est développée en **Python avec Streamlit in Snowflake**.

Le projet illustre un workflow complet : ingestion de fichiers, contrôles de qualité, nettoyage SQL, création de tables analytiques, visualisation, sécurisation des accès et versionnage avec Git/GitHub.

## 🏗️ Architecture technique

![Architecture de SnowCredit Sazotech](<images/Architecture risque de crédit.png>)

Le pipeline suit trois couches de données dans la base `SNOWCREDIT_DB` :

| Couche | Objet principal | Rôle |
|---|---|---|
| **RAW** | `RAW.CREDITS_BRUTS` | Conserver les 21 colonnes du fichier original sous forme de texte. |
| **CLEAN** | `CLEAN.CREDITS_NETTOYES` | Nettoyer les valeurs, typer les colonnes numériques et ajouter un libellé de risque en français. |
| **MART** | Tables analytiques | Fournir les indicateurs et les jeux de données des graphiques Streamlit. |

L'ingestion utilise le fichier `german.data`, le format `RAW.FF_GERMAN_DATA`, le stage interne `RAW.STG_GERMAN_CREDIT` et la commande Snowflake `COPY INTO`.

**Tables de la couche MART :**

- `MART.KPI_PORTEFEUILLE_CREDIT` — six KPI globaux.
- `MART.REPARTITION_RISQUES` — répartition des classes de risque.
- `MART.RISQUE_PAR_TRANCHE_MONTANT` — analyse par tranche de montant.
- `MART.RISQUE_PAR_DUREE` — analyse par tranche de durée.

## 📊 Résultats du portefeuille

Le tableau de bord exploite **1 000 dossiers** issus du jeu de données German Credit.

| Indicateur | Valeur |
|---|---:|
| Nombre total de crédits | **1 000** |
| Crédits classés à bon risque | **700** |
| Crédits classés à mauvais risque | **300** |
| Taux de mauvais risque | **30,00 %** |
| Montant total des crédits | **3 271 258** |
| Durée moyenne des crédits | **20,90 mois** |

**Remarque :** le jeu de données ne spécifie pas de devise ; le montant total est présenté **sans symbole monétaire**. La classification « mauvais risque » ne doit pas être interprétée automatiquement comme un défaut de paiement effectivement constaté.

### Visualisations disponibles

1. **Répartition des risques** — diagramme en anneau : 70 % bons risques, 30 % mauvais risques.
2. **Risque selon le montant** — taux de mauvais risque par tranche de montant de crédit.
3. **Risque selon la durée** — taux de mauvais risque par tranche de durée de crédit.

Les graphiques interrogent directement les tables analytiques de Snowflake.

## 🛠️ Technologies utilisées

| Technologie | Usage |
|---|---|
| **Snowflake** | Stockage, transformations SQL, stage, warehouse et contrôles de données |
| **SQL** | Création des couches RAW / CLEAN / MART et calcul des KPI |
| **Python & Streamlit** | Application interactive en français |
| **Vega-Lite** | Graphiques interactifs |
| **VS Code** | Développement local |
| **Git & GitHub Desktop** | Versionnage et synchronisation du code |
| **GitHub** | Hébergement du dépôt et documentation |

## 📁 Organisation du dépôt

```text
SnowCredit-Sazotech/
├── app/
│   └── streamlit_app.py
├── data/
│   └── raw/
│       ├── german.data
│       └── german.doc
├── images/
│   ├── Architecture risque de crédit.png
│   └── Tableau de bord du risque de crédit.png
├── sql/
│   ├── 01_initialisation_snowcredit.sql
│   ├── 02_creation_base_snowcredit.sql
│   ├── 03_creation_schemas_snowcredit.sql
│   ├── 04_creation_table_raw_snowcredit.sql
│   ├── 05_creation_format_snowcredit.sql
│   ├── 06_creation_stage_snowcredit.sql
│   ├── 07_verification_stage_snowcredit.sql
│   ├── 08_chargement_credits_raw.sql
│   ├── 09_creation_table_clean_snowcredit.sql
│   ├── 10_creation_kpi_mart_snowcredit.sql
│   ├── 11_mart_repartition_risques.sql
│   ├── 12_mart_risque_par_montant.sql
│   ├── 13_mart_risque_par_duree.sql
│   ├── 14_controle_qualite_mart.sql
│   ├── 15_creation_role_streamlit.sql
│   └── 16_permissions_role_streamlit.sql
├── .gitignore
└── README.md
```

> Selon les choix de versionnage, les fichiers sources dans `data/raw/` peuvent être conservés localement plutôt que publiés sur GitHub. Les scripts de gestion des rôles doivent être adaptés au compte Snowflake de chaque utilisateur avant exécution.

## 🚀 Reproduire le projet

**Prérequis :** un compte Snowflake autorisé à créer les objets nécessaires, un warehouse adapté, un environnement Streamlit in Snowflake et le dataset source.

1. Récupérer le dataset **Statlog (German Credit Data)** depuis l'UCI Machine Learning Repository.
2. Exécuter, dans l'ordre, les scripts SQL `01` à `07` pour configurer Snowflake et vérifier le stage.
3. Téléverser `german.data` dans le stage `SNOWCREDIT_DB.RAW.STG_GERMAN_CREDIT`.
4. Exécuter les scripts `08` à `14` pour charger les données, construire CLEAN et MART, puis vérifier les résultats.
5. Configurer les rôles applicatifs et leurs permissions selon l'environnement Snowflake (scripts `15` et `16`, **à adapter avant exécution**).
6. Ouvrir `app/streamlit_app.py` dans **Streamlit in Snowflake**, sélectionner les ressources appropriées et déployer l'application.
7. Vérifier les six KPI et les trois graphiques dans l'application.

Le warehouse de requêtes prévu pour le projet est `SNOWCREDIT_WH` (taille **X-Small**, suspension automatique configurée). Un rôle applicatif dédié, `SNOWCREDIT_APP_ROLE`, limite l'accès aux ressources nécessaires.

## ✅ Contrôles de qualité

- **Chargement RAW :** 1 000 lignes chargées, **0 erreur** dans le résultat `COPY INTO`.
- **CLEAN :** conversion des valeurs numériques et conservation des catégories originales.
- **MART :** contrôles de cohérence entre le nombre total de dossiers et les effectifs par classe de risque.
- **Streamlit :** consultation des indicateurs et graphiques depuis les tables MART.

## 📚 Source des données

**Statlog (German Credit Data)** — UCI Machine Learning Repository :

https://archive.ics.uci.edu/dataset/144/statlog-german-credit-data

Le jeu de données comprend **1 000 dossiers**, **20 variables descriptives** et **une classe de risque** (`1` : bon risque ; `2` : mauvais risque).

## 🔒 Sécurité et limites

Ce projet est une **démonstration pédagogique** ; il ne constitue pas un système de notation réglementaire, de décision automatisée d'octroi ou de suivi de défauts réellement observés. Les seuils de montant et de durée sont des regroupements analytiques choisis pour l'exploration des données.

Les mots de passe, secrets et fichiers de connexion ne doivent pas être ajoutés au dépôt GitHub. L'application doit utiliser un rôle Snowflake disposant des privilèges minimaux nécessaires.

---

**SnowCredit Sazotech** · **SAZOTECH SOLUTIONS**

*Snowflake · SQL · Python · Streamlit · Data Engineering · Banking Analytics*