# ============================================================
# PROJET     : SnowCredit Sazotech
# ENTREPRISE : SAZOTECH SOLUTIONS
# FICHIER    : app/streamlit_app.py
# VERSION    : 1.6
# OBJECTIF   : 6 KPI et 3 graphiques sur une seule page
# ============================================================

import streamlit as st


# ============================================================
# 1. CONFIGURATION ET STYLE
# ============================================================

st.set_page_config(
    page_title="SnowCredit Sazotech",
    page_icon="❄️",
    layout="wide",
    initial_sidebar_state="expanded",
)

st.html("""
<style>
.stApp, [data-testid="stAppViewContainer"] {
    background: #F4FAFF !important;
    color: #173B60 !important;
}
[data-testid="stMainBlockContainer"] {
    max-width: 1600px;
    padding-top: 1rem;
    padding-bottom: 1.5rem;
}
.stApp h1, .stApp h2, .stApp h3 {
    color: #10345B !important;
}
.snowcredit-header {
    padding: 18px 25px;
    margin-bottom: 12px;
    background: linear-gradient(110deg, #FFFFFF, #D4F0FF);
    border: 1px solid #B8E4FF;
    border-left: 5px solid #1597E5;
    border-radius: 14px;
}
.snowcredit-header h1 {
    color: #075A9E !important;
    font-size: 30px;
    margin: 0 0 5px;
    font-weight: 800;
}
.snowcredit-header p {
    color: #244F75 !important;
    margin: 0 0 5px;
    font-size: 15px;
}
.snowcredit-brand {
    color: #1685C7 !important;
    font-size: 11px;
    font-weight: 700;
    letter-spacing: 1px;
}
.snowcredit-title {
    color: #10345B !important;
    font-size: 21px;
    font-weight: 750;
    margin: 8px 0 12px;
}
[data-testid="stMetric"] {
    background: linear-gradient(120deg, #FFFFFF, #E1F3FF) !important;
    border: 1px solid #B5E2FC !important;
    border-radius: 11px !important;
    padding: 13px 16px !important;
    min-height: 98px;
}
[data-testid="stMetricLabel"],
[data-testid="stMetricLabel"] p {
    color: #315E85 !important;
    font-size: 13px !important;
    font-weight: 600 !important;
}
[data-testid="stMetricValue"],
[data-testid="stMetricValue"] div {
    color: #0862A9 !important;
    font-size: 27px !important;
    font-weight: 750 !important;
}
[data-testid="stSidebar"] {
    background: linear-gradient(180deg, #102C4D, #073B70) !important;
}
.snowcredit-sidebar-name {
    color: #FFFFFF !important;
    font-size: 24px;
    font-weight: 800;
    padding-top: 12px;
}
.snowcredit-sidebar-subtitle {
    color: #B6DBFA !important;
    font-size: 12px;
    margin-top: 5px;
}
.snowcredit-sidebar-item {
    background: #247AC3;
    color: #FFFFFF !important;
    border-radius: 9px;
    padding: 12px;
    margin: 15px 0;
    font-weight: 700;
}
.snowcredit-sidebar-note {
    color: #D4EAFB !important;
    font-size: 13px;
    line-height: 1.7;
}
.snowcredit-footer {
    color: #365E82 !important;
    font-size: 12px;
    line-height: 1.6;
    margin: 8px 0;
}
/* Couleur des titres et libelles, sans dependre du theme par defaut */
[data-testid="stMarkdownContainer"] p {
    line-height: 1.4;
}
</style>
""")


# ============================================================
# 2. FONCTIONS UTILITAIRES
# ============================================================

def format_entier(valeur):
    """Nombre entier en francais."""
    if valeur is None:
        return "—"
    return f"{int(valeur):,}".replace(",", " ")


def format_decimal(valeur):
    """Nombre decimal en francais, avec deux decimales."""
    if valeur is None:
        return "—"
    return f"{float(valeur):,.2f}".replace(",", " ").replace(".", ",")


def convertir_lignes(lignes, colonnes_entieres, colonnes_decimales):
    """Convertit les lignes Snowflake en dictionnaires pour les graphiques."""
    resultat = []
    for ligne in lignes:
        element = ligne.as_dict()
        for colonne in colonnes_entieres:
            element[colonne] = int(element[colonne])
        for colonne in colonnes_decimales:
            element[colonne] = float(element[colonne])
        resultat.append(element)
    return resultat


def graphique_donut(donnees):
    """Diagramme en anneau : classes de risque."""
    return {
        "$schema": "https://vega.github.io/schema/vega-lite/v5.json",
        "data": {"values": donnees},
        "background": "#FFFFFF",
        "height": 255,
        "mark": {
            "type": "arc",
            "innerRadius": 66,
            "outerRadius": 99,
            "stroke": "#FFFFFF",
            "strokeWidth": 3,
        },
        "encoding": {
            "theta": {"field": "NOMBRE_DOSSIERS", "type": "quantitative"},
            "color": {
                "field": "LIBELLE_RISQUE",
                "type": "nominal",
                "scale": {
                    "domain": ["Bon risque", "Mauvais risque"],
                    "range": ["#16A085", "#E66767"],
                },
                "legend": {
                    "title": None,
                    "orient": "bottom",
                    "labelColor": "#10345B",
                    "labelFontSize": 11,
                },
            },
            "tooltip": [
                {"field": "LIBELLE_RISQUE", "type": "nominal", "title": "Risque"},
                {"field": "NOMBRE_DOSSIERS", "type": "quantitative", "title": "Dossiers"},
                {"field": "POURCENTAGE_DOSSIERS", "type": "quantitative", "title": "Part (%)", "format": ".2f"},
            ],
        },
        "view": {"stroke": None},
    }


def graphique_barres(donnees, champ_tranche, couleur):
    """Histogramme horizontal : taux de mauvais risque par tranche."""
    return {
        "$schema": "https://vega.github.io/schema/vega-lite/v5.json",
        "data": {"values": donnees},
        "background": "#FFFFFF",
        "height": 255,
        "mark": {
            "type": "bar",
            "color": couleur,
            "cornerRadiusEnd": 5,
        },
        "encoding": {
            "y": {
                "field": champ_tranche,
                "type": "nominal",
                "sort": {"field": "ORDRE_TRANCHE", "order": "ascending"},
                "axis": {
                    "title": None,
                    "labelColor": "#315E85",
                    "labelFontSize": 11,
                    "labelLimit": 135,
                },
            },
            "x": {
                "field": "TAUX_MAUVAIS_RISQUE_PCT",
                "type": "quantitative",
                "scale": {"domain": [0, 100]},
                "axis": {
                    "title": "Mauvais risque (%)",
                    "labelColor": "#315E85",
                    "titleColor": "#10345B",
                    "gridColor": "#DBEAF5",
                },
            },
            "tooltip": [
                {"field": champ_tranche, "type": "nominal", "title": "Tranche"},
                {"field": "NOMBRE_DOSSIERS", "type": "quantitative", "title": "Dossiers"},
                {"field": "NOMBRE_BONS_RISQUES", "type": "quantitative", "title": "Bons risques"},
                {"field": "NOMBRE_MAUVAIS_RISQUES", "type": "quantitative", "title": "Mauvais risques"},
                {"field": "TAUX_MAUVAIS_RISQUE_PCT", "type": "quantitative", "title": "Taux (%)", "format": ".2f"},
            ],
        },
        "view": {"stroke": None},
    }


# ============================================================
# 3. MENU LATERAL ET BANDEAU
# ============================================================

with st.sidebar:
    st.html("""
    <div class="snowcredit-sidebar-name">❄️ SnowCredit</div>
    <div class="snowcredit-sidebar-subtitle">SAZOTECH SOLUTIONS</div>
    <div class="snowcredit-sidebar-item">📊 Vue d'ensemble</div>
    <div class="snowcredit-sidebar-note">
        Une seule page :<br>
        • 6 indicateurs bancaires<br>
        • Répartition des risques<br>
        • Risque par montant<br>
        • Risque par durée<br><br>
        Version 1.6 — Snowflake
    </div>
    """)

st.html("""
<div class="snowcredit-header">
    <h1>❄️ SnowCredit Sazotech</h1>
    <p>Tableau de bord — Analyse du risque de crédit bancaire</p>
    <div class="snowcredit-brand">SAZOTECH SOLUTIONS | DATA ANALYTICS | SNOWFLAKE</div>
</div>
""")


# ============================================================
# 4. CHARGEMENT DES DONNEES SNOWFLAKE
# ============================================================

try:
    # Connexion fournie par Streamlit in Snowflake.
    # Aucun mot de passe dans le fichier.
    conn = st.connection("snowflake")
    session = conn.session()
    session.use_warehouse("SNOWCREDIT_WH")

    lignes_kpi = session.sql("""
        SELECT NOMBRE_TOTAL_CREDITS,
               NOMBRE_BONS_RISQUES,
               NOMBRE_MAUVAIS_RISQUES,
               TAUX_MAUVAIS_RISQUE_PCT,
               MONTANT_TOTAL_CREDITS,
               DUREE_MOYENNE_MOIS
        FROM SNOWCREDIT_DB.MART.KPI_PORTEFEUILLE_CREDIT
    """).collect()

    if not lignes_kpi:
        st.warning("La table des KPI MART est vide.")
        st.stop()

    kpi = lignes_kpi[0].as_dict()

    repartition = convertir_lignes(
        session.sql("""
            SELECT CLASSE_RISQUE, LIBELLE_RISQUE,
                   NOMBRE_DOSSIERS, POURCENTAGE_DOSSIERS
            FROM SNOWCREDIT_DB.MART.REPARTITION_RISQUES
            ORDER BY CLASSE_RISQUE
        """).collect(),
        ["NOMBRE_DOSSIERS"],
        ["POURCENTAGE_DOSSIERS"],
    )

    montant = convertir_lignes(
        session.sql("""
            SELECT ORDRE_TRANCHE, TRANCHE_MONTANT,
                   NOMBRE_DOSSIERS, NOMBRE_BONS_RISQUES,
                   NOMBRE_MAUVAIS_RISQUES, TAUX_MAUVAIS_RISQUE_PCT
            FROM SNOWCREDIT_DB.MART.RISQUE_PAR_TRANCHE_MONTANT
            ORDER BY ORDRE_TRANCHE
        """).collect(),
        ["ORDRE_TRANCHE", "NOMBRE_DOSSIERS", "NOMBRE_BONS_RISQUES", "NOMBRE_MAUVAIS_RISQUES"],
        ["TAUX_MAUVAIS_RISQUE_PCT"],
    )

    duree = convertir_lignes(
        session.sql("""
            SELECT ORDRE_TRANCHE, TRANCHE_DUREE,
                   NOMBRE_DOSSIERS, NOMBRE_BONS_RISQUES,
                   NOMBRE_MAUVAIS_RISQUES, TAUX_MAUVAIS_RISQUE_PCT
            FROM SNOWCREDIT_DB.MART.RISQUE_PAR_DUREE
            ORDER BY ORDRE_TRANCHE
        """).collect(),
        ["ORDRE_TRANCHE", "NOMBRE_DOSSIERS", "NOMBRE_BONS_RISQUES", "NOMBRE_MAUVAIS_RISQUES"],
        ["TAUX_MAUVAIS_RISQUE_PCT"],
    )

    # ========================================================
    # 5. SIX KPI SUR DEUX LIGNES
    # ========================================================

    st.html('<div class="snowcredit-title">📊 Indicateurs du portefeuille</div>')

    cartes_kpi = [
        ("Nombre total de crédits", format_entier(kpi["NOMBRE_TOTAL_CREDITS"])),
        ("Crédits à bon risque", format_entier(kpi["NOMBRE_BONS_RISQUES"])),
        ("Crédits à mauvais risque", format_entier(kpi["NOMBRE_MAUVAIS_RISQUES"])),
        ("Taux de mauvais risque", format_decimal(kpi["TAUX_MAUVAIS_RISQUE_PCT"]) + " %"),
        ("Montant total des crédits", format_entier(kpi["MONTANT_TOTAL_CREDITS"])),
        ("Durée moyenne des crédits", format_decimal(kpi["DUREE_MOYENNE_MOIS"]) + " mois"),
    ]

    for debut in (0, 3):
        colonnes = st.columns(3, gap="small")
        for colonne, (libelle, valeur) in zip(colonnes, cartes_kpi[debut:debut + 3]):
            with colonne:
                st.metric(label=libelle, value=valeur)

    # ========================================================
    # 6. TROIS GRAPHIQUES COTE A COTE : MEME PAGE
    # ========================================================

    st.html('<div class="snowcredit-title">📈 Analyses du risque de crédit</div>')
    colonne_1, colonne_2, colonne_3 = st.columns(3, gap="small")

    with colonne_1:
        with st.container(border=True):
            st.markdown("**1. Répartition des risques**")
            if repartition:
                st.vega_lite_chart(
                    spec=graphique_donut(repartition),
                    width="stretch",
                    theme=None,
                )
                st.caption("Bon / mauvais risque — portefeuille global")
            else:
                st.warning("Aucune donnée de répartition.")

    with colonne_2:
        with st.container(border=True):
            st.markdown("**2. Risque selon le montant**")
            if montant:
                st.vega_lite_chart(
                    spec=graphique_barres(montant, "TRANCHE_MONTANT", "#1597E5"),
                    width="stretch",
                    theme=None,
                )
                st.caption("Taux de mauvais risque par tranche de montant")
            else:
                st.warning("Aucune donnée par montant.")

    with colonne_3:
        with st.container(border=True):
            st.markdown("**3. Risque selon la durée**")
            if duree:
                st.vega_lite_chart(
                    spec=graphique_barres(duree, "TRANCHE_DUREE", "#28B5C9"),
                    width="stretch",
                    theme=None,
                )
                st.caption("Taux de mauvais risque par tranche de durée")
            else:
                st.warning("Aucune donnée par durée.")

    # ========================================================
    # 7. VERIFICATION ET SOURCES (REPLIEES)
    # ========================================================

    total = int(kpi["NOMBRE_TOTAL_CREDITS"])
    bons = int(kpi["NOMBRE_BONS_RISQUES"])
    mauvais = int(kpi["NOMBRE_MAUVAIS_RISQUES"])

    def controle_tranches(lignes):
        return (
            sum(ligne["NOMBRE_DOSSIERS"] for ligne in lignes) == total
            and sum(ligne["NOMBRE_BONS_RISQUES"] for ligne in lignes) == bons
            and sum(ligne["NOMBRE_MAUVAIS_RISQUES"] for ligne in lignes) == mauvais
        )

    repartition_ok = (
        sum(ligne["NOMBRE_DOSSIERS"] for ligne in repartition) == total
        and len(repartition) > 0
    )
    montant_ok = bool(montant) and controle_tranches(montant)
    duree_ok = bool(duree) and controle_tranches(duree)

    if repartition_ok and montant_ok and duree_ok:
        st.success("✅ Connexion Snowflake active — 3 analyses cohérentes avec les KPI.")
    else:
        st.warning("Certains totaux MART sont à vérifier dans les analyses.")

    with st.expander("Sources, contrôles de données et précisions métier", expanded=False):
        st.write("**Total des dossiers :**", format_entier(total))
        st.write("**Répartition :**", "OK" if repartition_ok else "À vérifier")
        st.write("**Par montant :**", "OK" if montant_ok else "À vérifier")
        st.write("**Par durée :**", "OK" if duree_ok else "À vérifier")
        st.code(
            "SNOWCREDIT_DB.MART.KPI_PORTEFEUILLE_CREDIT\n"
            "SNOWCREDIT_DB.MART.REPARTITION_RISQUES\n"
            "SNOWCREDIT_DB.MART.RISQUE_PAR_TRANCHE_MONTANT\n"
            "SNOWCREDIT_DB.MART.RISQUE_PAR_DUREE",
            language="text",
        )
        st.info(
            "Le dataset ne précise pas l'unité monétaire. "
            "La catégorie « mauvais risque » n'est pas nécessairement "
            "un défaut de paiement constaté."
        )

except Exception as erreur:
    st.error("Impossible de charger le tableau de bord depuis Snowflake.")
    st.exception(erreur)

# ============================================================
# FIN DE L'APPLICATION — VERSION 1.6
# ============================================================
