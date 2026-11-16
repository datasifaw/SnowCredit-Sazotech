
# ❄️ SnowCredit Sazotech

### Analyse du risque de crédit bancaire avec Snowflake

Projet Data Engineering & Data Analytics développé sous la marque **SAZOTECH SOLUTIONS**.

## 📌 Présentation du projet

**SnowCredit Sazotech** est un projet d'analyse de données bancaires réalisé avec la plateforme Snowflake.

L'objectif est de construire une solution analytique permettant d'étudier un portefeuille de crédits bancaires, d'identifier les profils de risque et de visualiser les principaux indicateurs métier.

Ce projet est développé progressivement, avec un versionnage Git dès le démarrage.

## 🖥️ Aperçu de l'application

![Tableau de bord SnowCredit Sazotech](<images/Tableau de bord du risque de crédit.png>)

*Maquette illustrative du futur tableau de bord. Les données et graphiques présentés dans cette image ne correspondent pas encore aux résultats réels de notre analyse Snowflake.*

## 🎯 Objectifs du projet

- Importer un jeu de données de crédit bancaire dans Snowflake.
- Construire une architecture de données RAW / CLEAN / MART.
- Nettoyer et transformer les données avec SQL.
- Effectuer des contrôles de qualité des données.
- Analyser le portefeuille de crédits.
- Calculer les principaux indicateurs de risque.
- Construire un tableau de bord analytique en français.
- Versionner les fichiers avec Git et GitHub.

## 🏦 Contexte métier

Une banque souhaite mieux comprendre les risques associés à son portefeuille de crédits.

Le projet devra répondre notamment aux questions suivantes :

- Combien de dossiers de crédit sont étudiés ?
- Quelle est la proportion de crédits classés à risque ?
- Comment le risque varie-t-il selon les montants empruntés ?
- Quelle est la répartition des crédits selon leur durée ?
- Quels indicateurs permettent de mieux suivre le portefeuille ?

## 🛠️ Technologies utilisées

| Technologie | Utilisation |
|------------|-------------|
| Snowflake | Stockage, traitement et analyse des données |
| SQL | Nettoyage, transformation et calcul des KPI |
| Git | Versionnage du projet |
| GitHub | Hébergement du code et documentation |
| GitHub Desktop | Gestion graphique des commits |
| VS Code | Développement |
| Python | Préparation éventuelle des données |

## 🏗️ Architecture prévue

```text
Dataset CSV
     |
     v
SNOWFLAKE
     |
     v
RAW
Données brutes
     |
     v
CLEAN
Données nettoyées
     |
     v
MART
Indicateurs métier
     |
     v
TABLEAU DE BORD
Analyse du risque de crédit
```

## 📊 Indicateurs envisagés

- Nombre total de dossiers de crédit
- Montant total des crédits
- Répartition par classe de risque
- Taux de dossiers classés à risque
- Analyse du risque par montant emprunté
- Analyse des crédits par durée

Les indicateurs définitifs seront adaptés aux données réellement disponibles.

## 📂 Source des données

**German Credit Data — UCI Machine Learning Repository**

https://archive.ics.uci.edu/dataset/144/statlog-german-credit-data

Ce jeu de données historique contient 1 000 dossiers de crédit et 20 variables descriptives.

## 📁 Organisation du projet

Le projet sera organisé progressivement autour des éléments suivants :

- Scripts SQL Snowflake
- Données sources
- Contrôles de qualité
- Requêtes analytiques
- Visualisations
- Images
- Documentation

## 📅 Planning prévisionnel

| Jour | Objectif |
|------|----------|
| Jour 1 | Configuration, Git, Snowflake et import des données |
| Jour 2 | Architecture et transformations SQL |
| Jour 3 | KPI et tableau de bord |
| Jour 4 | Tests, documentation et finalisation |

## 🚀 État du projet

**En cours de développement**

Les fonctionnalités seront ajoutées et versionnées progressivement.

## ⚠️ Avertissement

Ce projet est réalisé à des fins pédagogiques et de démonstration.

Il utilise un jeu de données historique et ne constitue pas un système réel d'octroi de crédit ni un outil opérationnel de décision bancaire.

---

**SnowCredit Sazotech — SAZOTECH SOLUTIONS**

*Data Engineering | Snowflake | SQL | Banking Analytics*
