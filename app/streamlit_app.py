
# ============================================================
# PROJET     : SnowCredit Sazotech
# ENTREPRISE : SAZOTECH SOLUTIONS
# APPLICATION: Streamlit in Snowflake
# FICHIER    : streamlit_app.py
# VERSION    : 1.3
# OBJECTIF   : KPI bancaires et premier graphique de risque
# ============================================================

import streamlit as st


# ============================================================
# 1. CONFIGURATION GENERALE
# ============================================================

st.set_page_config(
    page_title="SnowCredit Sazotech",
    page_icon="❄️",
    layout="wide",
    initial_sidebar_state="expanded"
)


# ============================================================
# 2. DESIGN - BLEU CIEL ET BLANC
# ============================================================

st.html("""
<style>

/* FOND GENERAL */

.stApp,
[data-testid="stAppViewContainer"] {
    background-color: #F4FAFF !important;
    color: #153453 !important;
}

/* TITRES */

.stApp h1,
.stApp h2,
.stApp h3 {
    color: #10345B !important;
}

/* BANDEAU PRINCIPAL */

.snowcredit-header {
    background: linear-gradient(
        110deg,
        #FFFFFF 0%,
        #E6F6FF 60%,
        #CCEFFF 100%
    );

    border: 1px solid #B8E4FF;
    border-left: 5px solid #1597E5;

    border-radius: 16px;
    padding: 28px 32px;
    margin-bottom: 28px;

    box-shadow: 0 4px 14px
        rgba(31, 119, 177, 0.08);
}

.snowcredit-header h1 {
    color: #075A9E !important;
    font-size: 36px;
    font-weight: 800;
    line-height: 1.3;
    margin: 0 0 12px 0;
}

.snowcredit-header p {
    color: #244F75 !important;
    font-size: 17px;
    font-weight: 500;
    margin: 0 0 12px 0;
}

.snowcredit-header .brand {
    color: #1685C7 !important;
    font-size: 12px;
    font-weight: 700;
    letter-spacing: 1.2px;
}

/* TITRES DES SECTIONS */

.snowcredit-section {
    color: #10345B !important;
    font-size: 25px;
    font-weight: 750;
    margin: 10px 0 20px 0;
}

/* CARTES KPI */

[data-testid="stMetric"] {
    background: linear-gradient(
        135deg,
        #FFFFFF 0%,
        #DDF2FF 100%
    ) !important;

    border: 1px solid #B5E2FC !important;
    border-radius: 14px !important;

    padding: 22px !important;
    min-height: 130px;

    box-shadow: 0 4px 12px
        rgba(18, 111, 178, 0.07);
}

/* LIBELLES KPI */

[data-testid="stMetricLabel"],
[data-testid="stMetricLabel"] p,
[data-testid="stMetricLabel"] div {
    color: #315E85 !important;
    font-size: 15px !important;
    font-weight: 600 !important;
}

/* VALEURS KPI */

[data-testid="stMetricValue"],
[data-testid="stMetricValue"] div {
    color: #0862A9 !important;
    font-size: 31px !important;
    font-weight: 750 !important;
}

/* MENU LATERAL */

[data-testid="stSidebar"] {
    background: linear-gradient(
        180deg,
        #102C4D 0%,
        #073B70 100%
    ) !important;
}

.sidebar-brand {
    color: #FFFFFF !important;
    font-size: 26px;
    font-weight: 800;
    margin-bottom: 5px;
}

.sidebar-subtitle {
    color: #B6DBFA !important;
    font-size: 12px;
    letter-spacing: 1px;
}

.sidebar-section {
    color: #E7F5FF !important;
    font-size: 16px;
    font-weight: 700;
    margin: 18px 0 16px 0;
}

.sidebar-item {
    color: #E2F3FF !important;
    padding: 11px 13px;
    margin-bottom: 7px;

    background-color:
        rgba(255, 255, 255, 0.05);

    border-radius: 9px;
    font-size: 14px;
}

.sidebar-item-active {
    background-color: #0875C9;
    color: #FFFFFF !important;
    font-weight: 700;
}

.sidebar-version {
    background-color:
        rgba(100, 180, 255, 0.15);

    color: #CDE9FF !important;
    padding: 14px;
    border-radius: 10px;
    margin-top: 18px;
    font-size: 12px;
    line-height: 1.7;
}

/* MESSAGES */

.snowcredit-success {
    background-color: #DDF7ED;
    color: #086346 !important;

    border: 1px solid #99DFC4;
    border-radius: 10px;

    padding: 16px 20px;
    font-size: 14px;
    font-weight: 600;
}

.snowcredit-info {
    background-color: #E5F2FF;
    color: #174F82 !important;

    border: 1px solid #BADCF5;
    border-radius: 10px;

    padding: 16px 20px;
    margin-top: 14px;

    font-size: 14px;
    line-height: 1.6;
}

.snowcredit-source {
    color: #476A89 !important;
    font-size: 12px;
    margin-top: 14px;
}

/* CARTE DU GRAPHIQUE */

.snowcredit-chart-title {
    color: #10345B !important;
    font-size: 21px;
    font-weight: 750;
    margin: 15px 0;
}

.snowcredit-chart-description {
    color: #315E85 !important;
    font-size: 14px;
    line-height: 1.7;
    margin-bottom: 12px;
}

hr {
    border-color: #C9DFEF !important;
}

</style>
""")


# ============================================================
# 3. FONCTIONS DE FORMATAGE FRANCAIS
# ============================================================

def format_entier(valeur):
    """Afficher un entier avec separateur de milliers."""

    if valeur is None:
        return "—"

    return f"{int(valeur):,}".replace(",", " ")


def format_decimal(valeur):
    """Afficher un decimal au format francais."""

    if valeur is None:
        return "—"

    resultat = f"{float(valeur):,.2f}"

    return (
        resultat
        .replace(",", " ")
        .replace(".", ",")
    )


# ============================================================
# 4. MENU LATERAL
# ============================================================

with st.sidebar:

    st.html("""
    <div class="sidebar-brand">
        ❄️ SnowCredit
    </div>

    <div class="sidebar-subtitle">
        SAZOTECH SOLUTIONS
    </div>
    """)

    st.divider()

    st.html("""
    <div class="sidebar-section">
        Navigation
    </div>

    <div class="sidebar-item sidebar-item-active">
        📊 Tableau de bord
    </div>

    <div class="sidebar-item">
        🏦 Portefeuille de crédits
    </div>

    <div class="sidebar-item">
        📈 Analyse des risques
    </div>

    <div class="sidebar-item">
        📋 Rapports
    </div>
    """)

    st.divider()

    st.html("""
    <div class="sidebar-version">
        Version 1.3<br>
        Application SnowCredit Sazotech<br>
        Connectée à Snowflake
    </div>
    """)


# ============================================================
# 5. BANDEAU PRINCIPAL
# ============================================================

st.html("""
<div class="snowcredit-header">

    <h1>❄️ SnowCredit Sazotech</h1>

    <p>
        Tableau de bord —
        Analyse du risque de crédit bancaire
    </p>

    <div class="brand">
        SAZOTECH SOLUTIONS |
        DATA ANALYTICS |
        SNOWFLAKE
    </div>

</div>
""")


# ============================================================
# 6. CONNEXION A SNOWFLAKE
# ============================================================

try:

    # Connexion native de Streamlit in Snowflake.
    # Aucun identifiant sensible dans le code.

    conn = st.connection("snowflake")

    session = conn.session()

    session.use_warehouse("SNOWCREDIT_WH")


    # ========================================================
    # 7. RECUPERATION DES SIX KPI
    # ========================================================

    requete_kpi = """
        SELECT
            NOMBRE_TOTAL_CREDITS,
            NOMBRE_BONS_RISQUES,
            NOMBRE_MAUVAIS_RISQUES,
            TAUX_MAUVAIS_RISQUE_PCT,
            MONTANT_TOTAL_CREDITS,
            DUREE_MOYENNE_MOIS

        FROM SNOWCREDIT_DB.MART.KPI_PORTEFEUILLE_CREDIT
    """

    resultats = session.sql(requete_kpi).collect()

    if not resultats:

        st.warning(
            "Aucun indicateur disponible dans la couche MART."
        )

        st.stop()

    kpi = resultats[0].as_dict()


    # ========================================================
    # 8. AFFICHAGE DES KPI
    # ========================================================

    st.html("""
    <div class="snowcredit-section">
        📊 Indicateurs du portefeuille
    </div>
    """)

    col1, col2, col3 = st.columns(3)

    with col1:

        st.metric(
            label="Nombre total de crédits",
            value=format_entier(
                kpi["NOMBRE_TOTAL_CREDITS"]
            )
        )

    with col2:

        st.metric(
            label="Crédits à bon risque",
            value=format_entier(
                kpi["NOMBRE_BONS_RISQUES"]
            )
        )

    with col3:

        st.metric(
            label="Crédits à mauvais risque",
            value=format_entier(
                kpi["NOMBRE_MAUVAIS_RISQUES"]
            )
        )


    st.write("")

    col4, col5, col6 = st.columns(3)

    with col4:

        st.metric(
            label="Taux de mauvais risque",
            value=(
                format_decimal(
                    kpi["TAUX_MAUVAIS_RISQUE_PCT"]
                )
                + " %"
            )
        )

    with col5:

        st.metric(
            label="Montant total des crédits",
            value=format_entier(
                kpi["MONTANT_TOTAL_CREDITS"]
            )
        )

    with col6:

        st.metric(
            label="Durée moyenne des crédits",
            value=(
                format_decimal(
                    kpi["DUREE_MOYENNE_MOIS"]
                )
                + " mois"
            )
        )


    # ========================================================
    # 9. PREMIER GRAPHIQUE : REPARTITION DES RISQUES
    # ========================================================

    st.write("")

    st.divider()

    st.html("""
    <div class="snowcredit-section">
        📈 Analyse des risques bancaires
    </div>
    """)

    st.html("""
    <div class="snowcredit-chart-title">
        Répartition des crédits par niveau de risque
    </div>
    """)

    # Recuperation depuis notre table analytique MART.

    requete_repartition = """
        SELECT
            CLASSE_RISQUE,
            LIBELLE_RISQUE,
            NOMBRE_DOSSIERS,
            POURCENTAGE_DOSSIERS

        FROM SNOWCREDIT_DB.MART.REPARTITION_RISQUES

        ORDER BY CLASSE_RISQUE
    """

    lignes_repartition = session.sql(
        requete_repartition
    ).collect()

    if not lignes_repartition:

        st.warning(
            "Aucune donnée disponible pour la répartition "
            "des risques."
        )

    else:

        # Transformation des resultats Snowflake
        # en donnees utilisables par Vega-Lite.

        donnees_graphique = []

        for ligne in lignes_repartition:

            element = ligne.as_dict()

            donnees_graphique.append({
                "LIBELLE_RISQUE": str(
                    element["LIBELLE_RISQUE"]
                ),
                "NOMBRE_DOSSIERS": int(
                    element["NOMBRE_DOSSIERS"]
                ),
                "POURCENTAGE_DOSSIERS": float(
                    element["POURCENTAGE_DOSSIERS"]
                )
            })


        # ====================================================
        # 10. CONFIGURATION DU DONUT CHART
        # ====================================================

        graphique_donut = {

            "$schema":
                "https://vega.github.io/schema/vega-lite/v5.json",

            "description":
                "Répartition des dossiers de crédit par classe "
                "de risque à partir des données Snowflake.",

            "data": {
                "values": donnees_graphique
            },

            "background": "#FFFFFF",

            "mark": {
                "type": "arc",
                "innerRadius": 90,
                "outerRadius": 145,
                "stroke": "#FFFFFF",
                "strokeWidth": 3
            },

            "encoding": {

                "theta": {
                    "field": "NOMBRE_DOSSIERS",
                    "type": "quantitative"
                },

                "color": {
                    "field": "LIBELLE_RISQUE",
                    "type": "nominal",

                    "scale": {
                        "domain": [
                            "Bon risque",
                            "Mauvais risque"
                        ],
                        "range": [
                            "#16A085",
                            "#E66767"
                        ]
                    },

                    "legend": {
                        "title": None,
                        "labelColor": "#10345B",
                        "labelFontSize": 13
                    }
                },

                "tooltip": [

                    {
                        "field": "LIBELLE_RISQUE",
                        "type": "nominal",
                        "title": "Classe de risque"
                    },

                    {
                        "field": "NOMBRE_DOSSIERS",
                        "type": "quantitative",
                        "title": "Nombre de dossiers",
                        "format": ",d"
                    },

                    {
                        "field": "POURCENTAGE_DOSSIERS",
                        "type": "quantitative",
                        "title": "Pourcentage",
                        "format": ".2f"
                    }
                ]
            },

            "view": {
                "stroke": None
            },

            "config": {
                "font": "sans-serif",
                "legend": {
                    "labelColor": "#10345B"
                }
            }
        }


        # ====================================================
        # 11. AFFICHAGE DU GRAPHIQUE ET DES RESULTATS
        # ====================================================

        col_graphique, col_analyse = st.columns(
            [2, 1]
        )

        with col_graphique:

            st.vega_lite_chart(
                spec=graphique_donut,
                width="stretch",
                height=340,
                theme=None
            )


        with col_analyse:

            st.html("""
            <div class="snowcredit-chart-description">
                <strong>Lecture du graphique</strong><br>
                Répartition du portefeuille selon
                la classification de risque du dataset.
            </div>
            """)

            for element in donnees_graphique:

                libelle = element["LIBELLE_RISQUE"]

                pourcentage = element[
                    "POURCENTAGE_DOSSIERS"
                ]

                nombre = element[
                    "NOMBRE_DOSSIERS"
                ]

                st.markdown(
                    f"**{libelle}**"
                )

                st.write(
                    f"{format_entier(nombre)} dossiers"
                )

                st.write(
                    f"{format_decimal(pourcentage)} %"
                )

                st.write("")

        st.caption(
            "Source : "
            "SNOWCREDIT_DB.MART.REPARTITION_RISQUES"
        )


    # ========================================================
    # 12. MESSAGE DE CONNEXION
    # ========================================================

    st.write("")

    st.divider()

    st.html("""
    <div class="snowcredit-success">
        ✅ Connexion Snowflake réussie —
        Les données sont chargées depuis la couche MART.
    </div>
    """)

    st.html("""
    <div class="snowcredit-source">
        Source principale :
        SNOWCREDIT_DB.MART.KPI_PORTEFEUILLE_CREDIT
    </div>
    """)

    st.html("""
    <div class="snowcredit-info">
        ℹ️ Le dataset ne précise pas l'unité monétaire.
        Les montants sont donc affichés sans devise.
        <br>
        La classification « mauvais risque » ne
        constitue pas nécessairement un défaut de
        paiement constaté.
    </div>
    """)


# ============================================================
# 13. GESTION DES ERREURS
# ============================================================

except Exception as erreur:

    st.error(
        "Une erreur est survenue lors du chargement "
        "des données Snowflake."
    )

    st.exception(erreur)


# ============================================================
# FIN DE L'APPLICATION SNOWCREDIT SAZOTECH
# ============================================================
