<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml" version="1.0">

<!-- Auteur : Didier Courtaud ( CEA )  sur une idée originale de Damien Guillaume ( Observatoire de Paris ) -->
<!-- Contributeur : Pierre Brochard ( CEA )-->

<!-- Declaration HTML5 -->
<xsl:output method="xml" omit-xml-declaration="yes" encoding="UTF-8" doctype-system="about:legacy-compat" indent="yes"/>

<!-- options (valeurs: oui|non) -->
<xsl:param name="commentaires"><xsl:choose>
    <xsl:when test="/EAST/PREFERENCES/REGLAGES/COMMENTAIRES"><xsl:value-of select="/EAST/PREFERENCES/REGLAGES/COMMENTAIRES"/></xsl:when>
    <xsl:otherwise>non</xsl:otherwise></xsl:choose>
</xsl:param>

<xsl:param name="impression"><xsl:choose>
    <xsl:when test="/EAST/PREFERENCES/REGLAGES/IMPRESSION"><xsl:value-of select="/EAST/PREFERENCES/REGLAGES/IMPRESSION"/></xsl:when>
    <xsl:otherwise>non</xsl:otherwise></xsl:choose>
</xsl:param>

<xsl:template match="/">
    <xsl:apply-templates select="EAST"/>
</xsl:template>

<xsl:template match="PAGE_TITRE" >
    <!-- <div class="cover"> -->
    <div class="slide" id="cover">

    <table width="100%">
    <tr>
      <td align="left" class="vingt logogauche"><xsl:apply-templates select="../LOGO_GAUCHE"/></td>
      <!-- <td align="center" class="soixante"> </td> -->
      <td/>
      <td align="right" class="vingt logodroit"><tt><xsl:apply-templates select="../LOGO_DROIT"/></tt></td>
    </tr>
    </table>

    <table id="table_titre">
    <tbody>
    <tr><td><xsl:if test="normalize-space(TITRE)!=''">
      <h1 class="pagetitre"><xsl:value-of select="TITRE"/></h1>
    </xsl:if></td></tr>
    <tr><td><h2 class="pagetitre"> <xsl:apply-templates select="SOUS_TITRE"/></h2></td></tr>
    <tr><td><h5 class="pagetitre"> <xsl:value-of select="AUTEUR"/></h5></td></tr>
    </tbody>
    <tfoot>
    <tr><td><h6 class="pagetitre"><tt> <xsl:apply-templates select="EMAIL"/></tt></h6></td></tr>
    </tfoot>
    </table>

    <table class="bas" width="100%">
      <tr>
        <td align="left" class="tiers"><tt class="piedgauche"><xsl:apply-templates select="../PIEDPAGE_GAUCHE"/></tt></td>
        <td align="center" class="tiers"><tt class="slidenumber"><xsl:value-of select="DATE_EXPOSE"/></tt></td>
        <td align="right" class="tiers"><tt class="pieddroit"><xsl:apply-templates select="../PIEDPAGE_DROIT"/></tt></td>
      </tr>
    </table>

    </div>
</xsl:template>

<xsl:template match="PARTIE">
  <xsl:variable name="nbpart"> <xsl:value-of select="count(preceding::PARTIE)+1"/>  </xsl:variable>
  <div class="slide" id="partie{$nbpart}">

    <!-- <table width="100%">
      <tr>
        <td align="left" class="vingt"><xsl:apply-templates select="../LOGO_GAUCHE"/></td>
        <td align="center" class="soixante">
        </td>
        <td align="right" class="vingt"><tt><xsl:apply-templates select="../LOGO_DROIT"/></tt></td>
      </tr>
    </table> -->

    <table width="100%" height="60%">
    <tbody>
    <tr>
      <td>
        <xsl:choose>
          <xsl:when test="normalize-space(TITRE)!=''">
            <h1 class="titrepartie"><xsl:value-of select="TITRE"/></h1>
          </xsl:when>
          <xsl:otherwise>
            <h1 class="titrepartie">Partie <xsl:value-of select="position()"/></h1>
          </xsl:otherwise>
          </xsl:choose>
      </td>
    </tr>
    </tbody>
    </table>

    <table class="bas" width="100%">
      <tr>
        <td align="left" class="tiers"><tt class="piedgauche"><xsl:apply-templates select="../PIEDPAGE_GAUCHE"/></tt></td>
        <td align="center" class="tiers"><tt class="slidenumber"><xsl:value-of select="DATE_EXPOSE"/></tt></td>
        <td align="right" class="tiers"><tt class="pieddroit"><xsl:apply-templates select="../PIEDPAGE_DROIT"/></tt></td>
      </tr>
    </table>
  </div>

  <xsl:apply-templates select="SECTION"/>
</xsl:template>

<xsl:template name="sommaire">
  <div class="slide" id="sommaire">

    <table width="100%">
      <tr>
        <td align="left" class="vingt"><xsl:apply-templates select="LOGO_GAUCHE"/></td>
        <td align="center" class="soixante">
          <h1 class="titresommaire"> Plan </h1>
        </td>
        <td align="right" class="vingt"><tt><xsl:apply-templates select="LOGO_DROIT"/></tt></td>
      </tr>
    </table>

    <xsl:if test="count(METADONNEES/AUTEUR)&gt;0">
        <div class="auteur">- <xsl:apply-templates select="METADONNEES/AUTEUR"/></div>
    </xsl:if>

    <ul class="accordion">
    <xsl:for-each select="PARTIE">
      <!-- <xsl:variable name="nbsec"> <xsl:value-of select="count(preceding::SECTION)+count(preceding::PAGE_TITRE)"/>  </xsl:variable> -->
      <li class="elsommaire">
        <span>
        <xsl:choose>
          <xsl:when test="normalize-space(TITRE)!=''">
            <xsl:value-of select="TITRE"/>
          </xsl:when>
          <xsl:otherwise>
            Partie <xsl:value-of select="position()"/>
          </xsl:otherwise>
        </xsl:choose>

          <ul id="liste_sections">
          <xsl:for-each select="SECTION">
            <xsl:variable name="nbsec2">
              <xsl:choose>
                <xsl:when test="normalize-space(count(preceding::PAGE_TITRE))=0">
                  <xsl:value-of select="count(preceding::SECTION)+1"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="count(preceding::SECTION)+count(preceding::PAGE_TITRE)"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>

            <li class="elsommaire2">
              <span>
                <a href="#slide{$nbsec2}" class="linkitem">
                  <xsl:choose>
                    <xsl:when test="normalize-space(TITRE)!=''">
                      <xsl:value-of select="TITRE"/>
                    </xsl:when>
                    <xsl:otherwise>
                      Section<xsl:value-of select="position()"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </a>
              </span>
            </li>

          </xsl:for-each>
          </ul>
        </span>
      </li>
    </xsl:for-each>
    </ul>

    <xsl:if test="$commentaires='oui'">
      <div class="commentaire">
        note: les commentaires sont affiches
      </div>
    </xsl:if>
  </div>
</xsl:template>

<xsl:template match="EAST">
  <html>
  <head>
    <xsl:choose>
      <xsl:when test="normalize-space(PAGE_TITRE/TITRE)!=''">
        <title><xsl:value-of select="PAGE_TITRE/TITRE"/></title>
      </xsl:when>
      <xsl:otherwise>
        <title>Presentation</title>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:choose>
      <xsl:when test="normalize-space(PAGE_TITRE/IDENTIFIANT)!=''">
        <META name="id" content="{normalize-space(PAGE_TITRE/IDENTIFIANT)}"/>
        <META name="type" content="{normalize-space(PAGE_TITRE/IDENTIFIANT/@TYPE)}"/>
      </xsl:when>
    </xsl:choose>

    <style type="text/css">
      <xsl:call-template name="css"/>
    </style>

    <meta charset="UTF-8" />

    <link rel="stylesheet" type="text/css" href="config_EAST/EAST_transitions.css"><xsl:text> </xsl:text></link>
    <link rel="stylesheet" type="text/css" href="config_EAST/EAST.css"><xsl:text> </xsl:text></link>
    <link rel="stylesheet" type="text/css" href="config_EAST/EAST_config.css"><xsl:text> </xsl:text></link>
    <link rel="timesheet" type="application/smil+xml" href="config_EAST/EAST.smil"><xsl:text> </xsl:text></link>

    <xsl:text disable-output-escaping="yes" > &lt;!--[if lt IE 9]&gt; </xsl:text>

    <script type="text/javascript" src="config_EAST/lib/sizzle.js"></script>
    <script type="text/javascript" src="config_EAST/lib/html5.js"></script>
    <script type="text/javascript" src="config_EAST/lib/mediaelement.js"></script>

    <xsl:text disable-output-escaping="yes"> &lt;![endif]--&gt; </xsl:text>

    <script type="text/javascript" src="config_EAST/EAST.js"><xsl:text> </xsl:text></script>

    <script type="text/javascript" src="config_EAST/lib/timesheets.js"><xsl:text> </xsl:text></script>
    <script type="text/javascript" src="config_EAST/lib/timesheets-navigation.js"><xsl:text> </xsl:text></script>

    <script type="text/javascript" src="config_EAST/EAST_session.js"><xsl:text> </xsl:text></script>
	<script type="text/javascript" src="config_EAST/EAST_audio.js"><xsl:text> </xsl:text></script>
  </head>

  <xsl:variable name="body_transition">
    <xsl:choose>
      <xsl:when test="normalize-space(@transition)!=''">
        <xsl:value-of select="@transition"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'carousel'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <body class="{$body_transition}" style="font-size: 100%">

    <div id="slideshow">
      <xsl:apply-templates select="PAGE_TITRE"/>
      <xsl:call-template name="sommaire"/>
      <xsl:apply-templates select="PARTIE"/>

      <!-- Barre des boutons -->
      <!-- Toggle par BARRE_BOUTONS -->

      <xsl:if test="normalize-space(/EAST/PREFERENCES/BARRE_BOUTONS/@display)!='non'">
        <p id="navigation_par" class="menu">
          <button id="first" title="first slide">  &lt;&lt; begin   </button>
          <button id="prev"  title="previous slide"> &lt; prev </button>
          <button id="next"  title="next slide">     next &gt; </button>
          <button id="last"  title="last slide">         end &gt;&gt;  </button>
          <button id="plan"  title="Plan" onclick="location.href='#sommaire'"> Plan </button>
          <button id="print" title="Print" onclick="make_print();"> Print </button>
        </p>
        <p id="text_size_par" class="menuts">
          <button id="A++" title="A++" onclick="increase_body_size();">  A++ </button>
          <button id="A--" title="A--" onclick="decrease_body_size();">  A-- </button>
        </p>
      </xsl:if>
    </div>

    <div id="erreur">
      <h1> Problème </h1>
      <ul>
        <h3> Francais </h3>
        <li> La configuration de EAST n'a pas été trouvée et cela empêche le fonctionnement normal de EAST. </li>
        <li> Pour corriger ce probleme, placez le répertoire <em> config_EAST </em>  à côté de votre fichier HTML dans le même répertoire et rechargez votre fichier HTML</li>
      </ul>
      <ul>
        <h3> English </h3>
        <li> EAST configuration has not been found and EAST cannot work normally. </li>
        <li> To fix this problem, just put the directory <em> config_EAST </em>  beside your HTML file in the same directory and reload your HTML file</li>
      </ul>
    </div>

    </body>
  </html>
</xsl:template>

<xsl:template name="css">
/* Page */
  <xsl:variable name="fontpage">
    <xsl:choose>
      <xsl:when test="/EAST/PREFERENCES/PAGE/@font">
        <xsl:value-of select="/EAST/PREFERENCES/PAGE/@font"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="''"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

body { background: #FFFFFF <xsl:if test="$fontpage!=''"> ; font-family: "<xsl:value-of select="$fontpage"/>"</xsl:if>}
h1 { text-align: center; font-size: 150%; font-family: <xsl:if test="$fontpage!=''">"<xsl:value-of select="$fontpage"/>",</xsl:if>sans-serif; color: #963232 }
h2 { text-align: center; font-size: 110%; font-weight: bold; font-family: <xsl:if test="$fontpage!=''">"<xsl:value-of select="$fontpage"/>",</xsl:if>sans-serif; color: #963232 }
h3 { font-size: 100%; font-weight: bold; font-family: <xsl:if test="$fontpage!=''">"<xsl:value-of select="$fontpage"/>",</xsl:if>serif; margin-bottom: 0.5em }
h5 { text-align: center; font-size: 90%; font-weight: bold; font-family: <xsl:if test="$fontpage!=''">"<xsl:value-of select="$fontpage"/>",</xsl:if>serif; margin-bottom: 0.5em; color: #963232 }
h6 { text-align: center; font-size: 70%; font-weight: bold; font-family: <xsl:if test="$fontpage!=''">"<xsl:value-of select="$fontpage"/>",</xsl:if>serif; margin-bottom: 0.5em; color: #963232 }
.auteur { text-align: center }
.date { text-align: left }
.sommaire { page-break-after: always; background: #F5F5FF; margin: 0.5em; padding: 0.5em; <xsl:if test="$impression='non'">border: gray outset</xsl:if> }
.cover { page-break-after: always; background: #F5F5FF; margin: 0.5em; padding: 0.5em; <xsl:if test="$impression='non'">border: gray outset</xsl:if> }
.section { page-break-after: always; background: #FFFFEB; margin: 2em 0.5em; padding: 0.5em; <xsl:if test="$impression='non'">border: gray outset</xsl:if> }
  <xsl:choose>
    <xsl:when test="/EAST/PREFERENCES/PAGE/@image">
      .slide { page-break-after: always; margin: 2em 0.5em; padding: 0.5em; <xsl:if test="$impression='non'">border: gray outset;</xsl:if> background-size: cover; -webkit-background-size: cover; -moz-background-size: cover; -o-background-size: cover; background-image: url('<xsl:value-of select="normalize-space(/EAST/PREFERENCES/PAGE/@image)"/>');}
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="fondpage">
        <xsl:choose>
          <xsl:when test="/EAST/PREFERENCES/PAGE/@backcolor">
            <xsl:value-of select="/EAST/PREFERENCES/PAGE/@backcolor"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="'#FFFFEB'"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      .slide { page-break-after: always; background: <xsl:value-of select="$fondpage"/>; margin: 2em 0.5em; padding: 0.5em; <xsl:if test="$impression='non'">border: gray outset</xsl:if> }
    </xsl:otherwise>
  </xsl:choose>
/* Fin page */

/* Page de titre */

.pagetitre {
  <xsl:variable name="titlepagecolor">
    <xsl:choose>
      <xsl:when test="/EAST/PREFERENCES/TITLE_PAGE/@textcolor">
        <xsl:value-of select="/EAST/PREFERENCES/TITLE_PAGE/@textcolor"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="/EAST/PREFERENCES/PAGE/@textcolor"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="titlepageback">
    <xsl:choose>
      <xsl:when test="/EAST/PREFERENCES/TITLE_PAGE/@backcolor">
        <xsl:value-of select="/EAST/PREFERENCES/TITLE_PAGE/@backcolor"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="/EAST/PREFERENCES/PAGE/@backcolor"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

color: <xsl:value-of select="$titlepagecolor"/> ;
<xsl:if test="$titlepageback!=''"> background : <xsl:value-of select="$titlepageback"/> ;</xsl:if>
<xsl:if test="/EAST/PREFERENCES/TITLE_PAGE/@image">background-image: url('<xsl:value-of select="/EAST/PREFERENCES/TITLE_PAGE/@image"/>') ;</xsl:if>
<xsl:if test="/EAST/PREFERENCES/TITLE_PAGE/@font">font-family: <xsl:value-of select="/EAST/PREFERENCES/TITLE_PAGE/@font"/> ;</xsl:if>
}

/* Fin Page de titre */

/* Environnements d'image et de video */
  <xsl:variable name="fondenv">
    <xsl:choose>
      <xsl:when test="/EAST/PREFERENCES/ENV/@backcolor">
        <xsl:value-of select="/EAST/PREFERENCES/ENV/@backcolor"/>
      </xsl:when>
      <xsl:otherwise>
          <xsl:value-of select="'#EBFFEB'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="fontenv">
    <xsl:choose>
      <xsl:when test="/EAST/PREFERENCES/ENV/@font">
        <xsl:value-of select="/EAST/PREFERENCES/ENV/@font"/>
      </xsl:when>
      <xsl:otherwise>
          <xsl:value-of select="''"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="fontitre">
    <xsl:choose>
      <xsl:when test="/EAST/PREFERENCES/ENV/@titlefont">
        <xsl:value-of select="/EAST/PREFERENCES/ENV/@titlefont"/>
      </xsl:when>
      <xsl:otherwise>
          <xsl:value-of select="''"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="fondtitre">
    <xsl:choose>
      <xsl:when test="/EAST/PREFERENCES/ENV/@titleback">
        <xsl:value-of select="/EAST/PREFERENCES/ENV/@titleback"/>
      </xsl:when>
      <xsl:otherwise>
          <xsl:value-of select="'#E0E0FF'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="colorenv">
    <xsl:choose>
      <xsl:when test="/EAST/PREFERENCES/ENV/@textcolor">
        <xsl:value-of select="/EAST/PREFERENCES/ENV/@textcolor"/>
      </xsl:when>
      <xsl:otherwise>
          <xsl:value-of select="'black'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="imagenv">
    <xsl:choose>
      <xsl:when test="/EAST/PREFERENCES/ENV/@image">
        <xsl:value-of select="/EAST/PREFERENCES/ENV/@image"/>
      </xsl:when>
      <xsl:otherwise>
          <xsl:value-of select="''"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="titlecolor">
    <xsl:choose>
      <xsl:when test="/EAST/PREFERENCES/ENV/@titlecolor">
        <xsl:value-of select="/EAST/PREFERENCES/ENV/@titlecolor"/>
      </xsl:when>
      <xsl:otherwise>
          <xsl:value-of select="'black'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

.titreimage { text-align: center; font-weight: bold; background-color: <xsl:value-of select="$fondtitre"/> ; <xsl:if test="$fontitre!=''">font-family: <xsl:value-of select="$fontitre"/></xsl:if> ; color: <xsl:value-of select="$titlecolor"/>}
.envimage { text-align: center; border: gray outset; padding: 0; margin: 1em; background: <xsl:value-of select="$fondenv"/> <xsl:if test="$imagenv!=''"> ; background-image: url(<xsl:value-of select="$imagenv"/>)</xsl:if> }
.legende { font-family: <xsl:if test="$fontenv!=''">"<xsl:value-of select="$fontenv"/>",</xsl:if>sans-serif; margin-top: 1em ; color: <xsl:value-of select="$colorenv"/>}

/* Fin environnements */
  <xsl:variable name="fondpage">
    <xsl:choose>
      <xsl:when test="/EAST/PREFERENCES/PAGE/@backcolor">
        <xsl:value-of select="/EAST/PREFERENCES/PAGE/@backcolor"/>
      </xsl:when>
      <xsl:otherwise>
          <xsl:value-of select="'#EBFFEB'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="colorpage">
    <xsl:choose>
      <xsl:when test="/EAST/PREFERENCES/PAGE/@textcolor">
        <xsl:value-of select="/EAST/PREFERENCES/PAGE/@textcolor"/>
      </xsl:when>
      <xsl:otherwise>
          <xsl:value-of select="'#963232'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="linkpage">
    <xsl:choose>
      <xsl:when test="/EAST/PREFERENCES/PAGE/@linkcolor">
        <xsl:value-of select="/EAST/PREFERENCES/PAGE/@linkcolor"/>
      </xsl:when>
      <xsl:otherwise>
          <xsl:value-of select="'#663399'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

pre.code_xml { color: <xsl:value-of select="$colorpage"/> } ;
pre { background: <xsl:value-of select="$fondpage"/>; padding-left: 2em; padding-bottom: 0.5em }
tt { color: <xsl:value-of select="$colorpage"/> ; font-family: <xsl:if test="$fontpage!=''">"<xsl:value-of select="$fontpage"/>",</xsl:if> sans-serif}
li { margin-bottom: 0.5em; }
dt { font-weight: bold; }
dd { margin-bottom: 0.5em; }
.elsommaire { font-size: 110%; color: <xsl:value-of select="$colorpage"/> ; text-decoration: none; font-weight: bold }
.elsommaire:hover { font-size: 110%; color: <xsl:value-of select="$linkpage"/>; text-decoration: none; font-weight: bold }
.elsommaire2 { font-size: 110%; color: <xsl:value-of select="$colorpage"/> ; text-decoration: none}
.elsommaire2:hover { font-size: 110%; color: <xsl:value-of select="$linkpage"/>; text-decoration: none }
<xsl:if test="/EAST/PREFERENCES/PAGE/@linkcolor!=''">.linkitem { color: <xsl:value-of select="$colorpage"/> }</xsl:if>
<xsl:if test="/EAST/PREFERENCES/PAGE/@linkcolor!=''">.linkitem:hover { color: <xsl:value-of select="/EAST/PREFERENCES/PAGE/@linkcolor"/> }</xsl:if>

/* Tableaux */

table#table_titre {
height: 80%;
margin-top: 10 %;
margin-bottom: 10 %;
width: 80%;
margin-left: 10%;
margin-right: 10%;
}

/* Entetes */
  <xsl:variable name="fondentete">
    <xsl:choose>
      <xsl:when test="/EAST/PREFERENCES/TABLES/TAB_ENTETE/@backcolor">
        <xsl:value-of select="/EAST/PREFERENCES/TABLES/TAB_ENTETE/@backcolor"/>
      </xsl:when>
      <xsl:otherwise>
          <xsl:value-of select="'#FFF0E0'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="colorentete">
    <xsl:choose>
      <xsl:when test="/EAST/PREFERENCES/TABLES/TAB_ENTETE/@textcolor">
        <xsl:value-of select="/EAST/PREFERENCES/TABLES/TAB_ENTETE/@textcolor"/>
      </xsl:when>
      <xsl:otherwise>
          <xsl:value-of select="'black'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

th {
background: <xsl:value-of select="$fondentete"/> ;
color: <xsl:value-of select="$colorentete"/> ;
<xsl:if test="/EAST/PREFERENCES/TABLES/TAB_ENTETE/@image"> background-image: url(<xsl:value-of select="/EAST/PREFERENCES/TABLES/TAB_ENTETE/@image"/> ) ;</xsl:if>
<xsl:if test="/EAST/PREFERENCES/TABLES/TAB_ENTETE/@font"> font-family: <xsl:value-of select="/EAST/PREFERENCES/TABLES/TAB_ENTETE/@font"/>  ;</xsl:if>
}

/* Corps des tableaux */
  <xsl:variable name="fondcorps">
    <xsl:choose>
      <xsl:when test="/EAST/PREFERENCES/TABLES/TAB_CORPS/@backcolor">
        <xsl:value-of select="/EAST/PREFERENCES/TABLES/TAB_CORPS/@backcolor"/>
      </xsl:when>
      <xsl:otherwise>
          <xsl:value-of select="'#FFFAE0'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="colorcorps">
    <xsl:choose>
      <xsl:when test="/EAST/PREFERENCES/TABLES/TAB_CORPS/@textcolor">
        <xsl:value-of select="/EAST/PREFERENCES/TABLES/TAB_CORPS/@textcolor"/>
      </xsl:when>
      <xsl:otherwise>
          <xsl:value-of select="'black'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

.tableau1 {
background: <xsl:value-of select="$fondcorps"/> ;
color: <xsl:value-of select="$colorcorps"/> ;
<xsl:if test="/EAST/PREFERENCES/TABLES/TAB_CORPS/@image"> background-image: url(<xsl:value-of select="/EAST/PREFERENCES/TABLES/TAB_CORPS/@image"/> ) ;</xsl:if>
<xsl:if test="/EAST/PREFERENCES/TABLES/TAB_CORPS/@font"> font-family: <xsl:value-of select="/EAST/PREFERENCES/TABLES/TAB_CORPS/@font"/>  ;</xsl:if>
}
.tableau2 {
background: <xsl:value-of select="$fondcorps"/> ;
color: <xsl:value-of select="$colorcorps"/> ;
<xsl:if test="/EAST/PREFERENCES/TABLES/TAB_CORPS/@image"> background-image: url(<xsl:value-of select="/EAST/PREFERENCES/TABLES/TAB_CORPS/@image"/> ;)</xsl:if>
<xsl:if test="/EAST/PREFERENCES/TABLES/TAB_CORPS/@font"> font-family: <xsl:value-of select="/EAST/PREFERENCES/TABLES/TAB_CORPS/@font"/> ; </xsl:if>
}

td.tiers { width: 33% }
td.vingt { width: 20% }
table.bas { position: absolute; bottom: 2% ; left:0 }

/* Fin tableaux */
  <xsl:variable name="colorcomm">
    <xsl:choose>
      <xsl:when test="/EAST/PREFERENCES/COMMENTAIRE/@color">
        <xsl:value-of select="/EAST/PREFERENCES/COMMENTAIRES/@color"/>
      </xsl:when>
      <xsl:otherwise>
          <xsl:value-of select="'#196419'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

.commentaire {
margin: 1em;
color: <xsl:value-of select="$colorcomm"/> ;
}

.equation { vertical-align : middle }
  <xsl:variable name="fondcontenu">
    <xsl:choose>
      <xsl:when test="normalize-space(/EAST/PREFERENCES/PAGE/@backcolor)">
        <xsl:value-of select="normalize-space(/EAST/PREFERENCES/PAGE/@backcolor)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="''"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="colorpied">
    <xsl:choose>
      <xsl:when test="normalize-space(/EAST/PREFERENCES/PAGE/@textcolor)">
        <xsl:value-of select="normalize-space(/EAST/PREFERENCES/PAGE/@textcolor)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'#963232'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="colorcontenu">
    <xsl:choose>
      <xsl:when test="normalize-space(/EAST/PREFERENCES/PAGE/@textcolor)">
        <xsl:value-of select="normalize-space(/EAST/PREFERENCES/PAGE/@textcolor)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="''"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

ul { margin-top: 0.5em <xsl:if test="$fondcontenu!=''">; background : <xsl:value-of select="$fondcontenu"/></xsl:if><xsl:if test="$colorcontenu!=''">; color : <xsl:value-of select="$colorcontenu"/></xsl:if>}
p { text-indent: 1em; text-align: justify; margin-top: 0.5em <xsl:if test="$fondcontenu!=''">; background : <xsl:value-of select="$fondcontenu"/></xsl:if><xsl:if test="$colorcontenu!=''">; color : <xsl:value-of select="$colorcontenu"/></xsl:if>}
.spanli { <xsl:if test="$fondcontenu!=''">background : <xsl:value-of select="$fondcontenu"/></xsl:if><xsl:if test="$colorcontenu!=''">; color : <xsl:value-of select="$colorcontenu"/></xsl:if>}

p#navigation_par {text-indent: 1em; text-align: justify; margin-top: 0.5em ; background : none }
p#text_size_par {text-indent: 1em; text-align: justify; margin-top: 0.5em ; background : none }

<xsl:if test="/EAST/LOGO_GAUCHE">
  td.logogauche{ <xsl:if test="$fondcontenu!=''">; background : <xsl:value-of select="$fondcontenu"/></xsl:if><xsl:if test="$colorcontenu!=''">; color : <xsl:value-of select="$colorcontenu"/></xsl:if> }
</xsl:if>

<xsl:if test="/EAST/LOGO_DROIT">
  td.logodroit{ <xsl:if test="$fondcontenu!=''">; background : <xsl:value-of select="$fondcontenu"/></xsl:if><xsl:if test="$colorcontenu!=''">; color : <xsl:value-of select="$colorcontenu"/></xsl:if> }
</xsl:if>

tt.slidenumber { color : <xsl:value-of select="$colorpied"/> <xsl:if test="$fondcontenu!=''">; background : <xsl:value-of select="$fondcontenu"/> </xsl:if> }

<xsl:if test="/EAST/PIEDPAGE_GAUCHE">
  tt.piedgauche { color : <xsl:value-of select="$colorpied"/> <xsl:if test="$fondcontenu!=''">; background : <xsl:value-of select="$fondcontenu"/> </xsl:if>}
</xsl:if>

<xsl:if test="/EAST/PIEDPAGE_DROIT">
  tt.pieddroit { color : <xsl:value-of select="$colorpied"/> <xsl:if test="$fondcontenu!=''">; background : <xsl:value-of select="$fondcontenu"/>  </xsl:if>}
</xsl:if>

/* Titres */

td.soixante { width: 60% ; background : <xsl:value-of select="/EAST/PREFERENCES/TITLES/@backcolor"/> }

.slide_title  , .titrepartie , .titresommaire {
  <xsl:variable name="titrecolor">
    <xsl:choose>
      <xsl:when test="/EAST/PREFERENCES/TITLES/@textcolor">
        <xsl:value-of select="/EAST/PREFERENCES/TITLES/@textcolor"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'#963232'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

color : <xsl:value-of select="$titrecolor"/> ;
<xsl:if test="/EAST/PREFERENCES/TITLES/@backcolor"> background : <xsl:value-of select="/EAST/PREFERENCES/TITLES/@backcolor"/> ; </xsl:if>
<xsl:if test="/EAST/PREFERENCES/TITLES/@image"> background-image: url(<xsl:value-of select="/EAST/PREFERENCES/TITLES/@image"/> ) ; </xsl:if>
<xsl:if test="/EAST/PREFERENCES/TITLES/@font"> font-familiy : <xsl:value-of select="/EAST/PREFERENCES/TITLES/@font"/> ;</xsl:if>
}

/* Fin Titres */

#slideshow div.slide {
  position: absolute;
  left: 10%;
  top: 3%;
  width:80%;
  height:80%;
}
#slideshow div.print {
  position: relative !important;
}

#slideshow div.image {
align:center;
}

#slideshow div.moitie {
  float:left;
  width:50%;
}

#slideshow div.tiers {
  float:left;
  width:33%;
}
#slideshow div.quart {
  float:left;
  width:25%;
}

#navigation_par.print {
  display: none;
  opacity: 0;
}

#text_size_par.print {
  display: none;
  opacity: 0;
}

/* navigation menu */
#slideshow .menu {
  position: absolute;
  /*bottom: 0;*/
  /*right: 2em;*/
  /*font-size: 0.75em;*/
  bottom: 0%;
  right: 9%;
  margin: 0;
  border-radius         : 0px;
  -o-border-radius      : 0px;
  -moz-border-radius    : 0px;
  -webkit-border-radius : 0px;
  box-shadow         : none;
  -o-box-shadow      : none;
  -moz-box-shadow    : none;
  -webkit-box-shadow : none;
  z-index: 2;
}
/* no transition for the menu! */
#slideshow .menu {
  opacity: 1 ;
  visibility: visible ;
}
#slideshow .menu button {
  opacity: 1;
  transition         : none;
  -o-transition      : none;
  -moz-transition    : none;
  -webkit-transition : none;
}
#slideshow .menu button[smil=idle] {
  opacity: 0.5;
  transform         : none;
  -o-transform      : none;
  -moz-transform    : none;
  -webkit-transform : none;
}

/* text sizing menu */
#slideshow .menuts {
  position: absolute;
  /*bottom: 0;*/
  /*right: 2em;*/
  /*font-size: 0.75em;*/
  bottom: 0%;
  left: 9%;
  margin: 0;
  border-radius         : 0px;
  -o-border-radius      : 0px;
  -moz-border-radius    : 0px;
  -webkit-border-radius : 0px;
  box-shadow         : none;
  -o-box-shadow      : none;
  -moz-box-shadow    : none;
  -webkit-box-shadow : none;
  z-index: 2;
}
/* no transition for the menu! */
#slideshow .menuts {
  opacity: 1 ;
  visibility: visible ;
}
#slideshow .menuts button {
  opacity: 1;
  transition         : none;
  -o-transition      : none;
  -moz-transition    : none;
  -webkit-transition : none;
}
#slideshow .menuts button[smil=idle] {
  opacity: 0.5;
  transform         : none;
  -o-transform      : none;
  -moz-transform    : none;
  -webkit-transform : none;
}

/* Code en colonnes */

div.code_cols {

   column-gap: 1em;
   -o-column-gap: 1em;
   -moz-column-gap: 1em;
   -webkit-column-gap: 1em;
   column-rule:1px solid;
   -o-column-rule:1px solid;
   -moz-column-rule:1px solid;
   -webkit-column-rule:1px solid;
   color: #963232;
   white-space:pre-wrap ;
   word-wrap:break-word;
}

#slideshow div[smil="active"] {

   display: block;
}

/*  Tous les slides et les boutons sont caches par defaut
    pour verifier la presence du repertoire de configuration qui contient
    le fichier CSS qui va les rendre visibles

    Un slide d'erreur est affiche */

#slideshow {

  display: none;

}

p.menu {
  display: none;
}

p.menuts {
  display: none;
}

div#erreur {
  display: block;

  position: absolute;
  left: 10%;
  top: 3%;
  width:80%;
  height:80%;
  background: #FFFFEB;
  margin: 2em 0.5em;
  padding: 0.5em;
  border: gray outset
}

</xsl:template>

<xsl:template match="LOGO_GAUCHE">
  <xsl:choose>
    <xsl:when test="@url!=''">
      <a href="{@url}"><img align="left" alt="{@alt}" border="0" src="{@fichier}" height="{@hauteur_SVG}%" title="{@alt}" width="{@largeur_SVG}%"/></a>
    </xsl:when>
    <xsl:otherwise>
      <img align="left" alt="{@alt}" src="{@fichier}" height="{@hauteur_SVG}%" title="{@alt}" width="{@largeur_SVG}%"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="LOGO_DROIT">
  <xsl:choose>
    <xsl:when test="@url!=''">
      <a href="{@url}"><img align="right" alt="{@alt}" border="0" src="{@fichier}" height="{@hauteur_SVG}%" title="{@alt}" width="{@largeur_SVG}%"/></a>
    </xsl:when>
    <xsl:otherwise>
      <img align="right" alt="{@alt}" src="{@fichier}" height="{@hauteur_SVG}%" title="{@alt}" width="{@largeur_SVG}%"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="SECTION">
  <xsl:variable name="numero"> <xsl:value-of select="count(preceding::SECTION)+1"/>  </xsl:variable>

  <div class="slide" id="slide{$numero}">
    <table width="100%">
        <tr>
          <td align="left" class="vingt logogauche"><xsl:apply-templates select="../../LOGO_GAUCHE"/></td>
          <td align="center" class="soixante"><h2 class="slide_title"><xsl:value-of select="TITRE"/></h2></td>
          <td align="right" class="vingt logodroit"><xsl:apply-templates select="../../LOGO_DROIT"/></td>
        </tr>
    </table>

    <xsl:apply-templates/>

    <table class="bas" width="100%">
      <tr>
        <td align="left" class="tiers"><tt class="piedgauche"><xsl:apply-templates select="../../PIEDPAGE_GAUCHE"/></tt></td>
        <td align="center" class="tiers"><tt class="slidenumber"><xsl:value-of select="$numero"/>/<xsl:value-of select="count(//SECTION)"/></tt></td>
        <td align="right" class="tiers"><tt class="pieddroit"><xsl:apply-templates select="../../PIEDPAGE_DROIT"/></tt></td>
      </tr>
    </table>
  </div>
</xsl:template>

<xsl:template match="AUTEUR">
  <xsl:value-of select="."/> -
</xsl:template>

<xsl:template match="DATECRE">
  <div class="date"><xsl:value-of select="."/></div>
</xsl:template>

<xsl:template match="TITRE">
</xsl:template>

<xsl:template match="PARAGRAPHE">
  <xsl:if test="normalize-space(TITRE)!=''">
    <h3><xsl:value-of select="TITRE"/></h3>
  </xsl:if>
    <p><xsl:apply-templates/></p>
</xsl:template>

<xsl:template match="EXEMPLE">
  <xsl:if test="normalize-space(@label)!=''">
    <h3><xsl:value-of select="@label"/></h3>
  </xsl:if>
    <pre><xsl:apply-templates/></pre>
</xsl:template>

<xsl:template match="CODE">
  <xsl:variable name="cod1">
  <xsl:choose>
    <xsl:when test="normalize-space(@textcolor)!=''">
      <xsl:value-of select="concat('color: ',@textcolor,';')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="''"/>
    </xsl:otherwise>
  </xsl:choose>
  </xsl:variable>

  <xsl:variable name="cod2">
    <xsl:choose>
      <xsl:when test="normalize-space(@backcolor)!=''">
        <xsl:value-of select="concat('background: ',@backcolor,';')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="''"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="cod3">
    <xsl:choose>
      <xsl:when test="normalize-space(@image)!=''">
        <xsl:value-of select="concat('background-image: url(',@image,');')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="''"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="cod4">
    <xsl:choose>
      <xsl:when test="normalize-space(@font)!=''">
        <xsl:value-of select="concat('font-family: ',@font,';')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="''"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="allcods">
    <xsl:value-of select="concat($cod1,$cod2,$cod3,$cod4)"/>
  </xsl:variable>
  <tt style="{$allcods}"><xsl:apply-templates/></tt>
</xsl:template>

<xsl:template match="CODE_COLS">
  <xsl:variable name="nombre_colonnes">
    <xsl:choose>
      <xsl:when test="normalize-space(@nbcols)!=''">
        <xsl:value-of select="@nbcols"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'1'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="tt1">
    <xsl:choose>
      <xsl:when test="normalize-space(@textcolor)!=''">
        <xsl:value-of select="concat('color: ',@textcolor,';')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="''"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="cc2">
    <xsl:choose>
      <xsl:when test="normalize-space(@backcolor)!=''">
        <xsl:value-of select="concat('background: ',@backcolor,';')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="''"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="cc3">
    <xsl:choose>
      <xsl:when test="normalize-space(@image)!=''">
        <xsl:value-of select="concat('background-image: url(',@image,');')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="''"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="tt4">
    <xsl:choose>
      <xsl:when test="normalize-space(@font)!=''">
        <xsl:value-of select="concat('font-family: ',@font,';')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="''"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="allccs">
    <xsl:value-of select="concat($cc2,$cc3)"/>
  </xsl:variable>

  <xsl:variable name="alltts">
    <xsl:value-of select="concat($tt1,$tt4)"/>
  </xsl:variable>

  <xsl:variable name="npart"> <xsl:value-of select="count(ancestor-or-self::PARTIE)"/>  </xsl:variable>
  <xsl:variable name="nsect"> <xsl:value-of select="count(preceding::SECTION)"/>  </xsl:variable>
  <xsl:variable name="ncode"> <xsl:value-of select="count(preceding-sibling::CODE_COLS)"/>  </xsl:variable>
  <xsl:variable name="id_code"> <xsl:value-of select="concat('d',$npart,$nsect,$ncode)"/> </xsl:variable>

  <div class="code_cols" id="{$id_code}" style="{$allccs}">
    <tt style="{$alltts}">
      <xsl:apply-templates/>
    </tt>
  </div>

  <script type="text/javascript">
    var div<xsl:value-of select="$id_code"/> = document.getElementById("<xsl:value-of select="$id_code"/>");

    div<xsl:value-of select="$id_code"/>.style.columnCount = "<xsl:value-of select="$nombre_colonnes"/>";
    div<xsl:value-of select="$id_code"/>.style.MozColumnCount = "<xsl:value-of select="$nombre_colonnes"/>";
    div<xsl:value-of select="$id_code"/>.style.webkitColumnCount = "<xsl:value-of select="$nombre_colonnes"/>";
    div<xsl:value-of select="$id_code"/>.style.oColumnCount = "<xsl:value-of select="$nombre_colonnes"/>";
  </script>
</xsl:template>

<xsl:template match="EMPHASE">
  <em><xsl:apply-templates/></em>
</xsl:template>

<xsl:template match="LIEN_INTERNE">
  <xsl:if test="count(child::text()) != 0">
    <a href="#slide{@num}"><xsl:apply-templates/></a>
  </xsl:if>
</xsl:template>

<xsl:template match="LIEN_EXTERNE">
  <xsl:if test="count(child::text()) != 0">
    <a href="{@href}"><xsl:apply-templates/></a>
  </xsl:if>
</xsl:template>

<xsl:template match="LISTE">
  <xsl:if test="normalize-space(TITRE)!=''">
    <xsl:choose>
      <xsl:when test="normalize-space(@mode)='incremental_ombre'">
        <h3 class="shadowinc"><xsl:value-of select="TITRE"/></h3>
      </xsl:when>
      <xsl:when test="normalize-space(@mode)='incremental'">
        <h3 class="incremental"><xsl:value-of select="TITRE"/></h3>
      </xsl:when>
      <xsl:when test="normalize-space(@mode)='incremental_allume'">
        <h3 class="highinc"><xsl:value-of select="TITRE"/></h3>
      </xsl:when>
      <xsl:otherwise>
        <h3><xsl:value-of select="TITRE"/></h3>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>

  <xsl:variable name="list_level"><xsl:value-of select="count(ancestor-or-self::LISTE)"/></xsl:variable>
  <xsl:variable name="list_type">
    <xsl:choose>
      <xsl:when test="normalize-space(@type)!=''">
        <xsl:value-of select="@type"/>
      </xsl:when>
      <xsl:when test="normalize-space(/EAST/PREFERENCES/PUCE[@level=$list_level]/@type)!=''">
        <xsl:value-of select="normalize-space(/EAST/PREFERENCES/PUCE[@level=$list_level]/@type)"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>

    <xsl:when test="normalize-space(@mode)='pliage'">
      <xsl:choose>
        <xsl:when test="count(ancestor::LISTE)!=0">
          <xsl:choose>
            <xsl:when test="normalize-space($list_type)!=''">
              <ul type="{$list_type}">
                <xsl:apply-templates select="EL"/>
              </ul>
            </xsl:when>
            <xsl:otherwise>
              <ul>
                <xsl:apply-templates select="EL"/>
              </ul>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="normalize-space($list_type)!=''">
              <ul class="outline" type="{$list_type}">
                <xsl:apply-templates select="EL"/>
              </ul>
            </xsl:when>
            <xsl:otherwise>
              <ul class="outline">
                <xsl:apply-templates select="EL"/>
              </ul>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>

    <xsl:when test="normalize-space(@mode)='accordeon'">
      <xsl:choose>
        <xsl:when test="count(ancestor::LISTE)!=0">
          <xsl:choose>
            <xsl:when test="normalize-space($list_type)!=''">
              <ul type="{$list_type}">
                <xsl:apply-templates select="EL"/>
              </ul>
            </xsl:when>
            <xsl:otherwise>
              <ul>
                <xsl:apply-templates select="EL"/>
              </ul>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="normalize-space($list_type)!=''">
              <ul class="accordion" type="{$list_type}">
                <xsl:apply-templates select="EL"/>
              </ul>
            </xsl:when>
            <xsl:otherwise>
              <ul class="accordion">
                <xsl:apply-templates select="EL"/>
              </ul>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>

    <xsl:when test="normalize-space(@mode)='incremental'">
      <xsl:choose>
        <xsl:when test="count(ancestor::LISTE)!=0">
          <xsl:choose>
            <xsl:when test="normalize-space($list_type)!=''">
              <ul type="{$list_type}">
                <xsl:apply-templates select="EL"/>
                <li class="signeplus"> <img src="config_EAST/signe_plus.png"/></li>
              </ul>
            </xsl:when>
            <xsl:otherwise>
              <ul>
                <xsl:apply-templates select="EL"/>
                <li class="signeplus"> <img src="config_EAST/signe_plus.png"/></li>
              </ul>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="normalize-space($list_type)!=''">
              <ul class="incremental" type="{$list_type}">
                <xsl:apply-templates select="EL"/>
                <li class="signeplus"> <img src="config_EAST/signe_plus.png"/></li>
              </ul>
            </xsl:when>
            <xsl:otherwise>
              <ul class="incremental">
                <xsl:apply-templates select="EL"/>
                <li class="signeplus"> <img src="config_EAST/signe_plus.png"/></li>
              </ul>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>

    <xsl:when test="normalize-space(@mode)='incremental_ombre'">
      <xsl:choose>
        <xsl:when test="count(ancestor::LISTE)!=0">
          <xsl:choose>
            <xsl:when test="normalize-space($list_type)!=''">
              <ul type="{$list_type}">
                <xsl:apply-templates select="EL"/>
                <li class="signeplus"> <img src="config_EAST/signe_plus.png"/></li>
              </ul>
            </xsl:when>
            <xsl:otherwise>
              <ul>
                <xsl:apply-templates select="EL"/>
                <li class="signeplus"> <img src="config_EAST/signe_plus.png"/></li>
              </ul>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="normalize-space($list_type)!=''">
              <ul class="shadowinc" type="{$list_type}">
                <xsl:apply-templates select="EL"/>
                <li class="signeplus"> <img src="config_EAST/signe_plus.png"/></li>
              </ul>
            </xsl:when>
            <xsl:otherwise>
              <ul class="shadowinc">
                <xsl:apply-templates select="EL"/>
                <li class="signeplus"> <img src="config_EAST/signe_plus.png"/></li>
              </ul>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>

    <xsl:when test="normalize-space(@mode)='incremental_allume'">
      <xsl:choose>
        <xsl:when test="count(ancestor::LISTE)!=0">
          <xsl:choose>
            <xsl:when test="normalize-space($list_type)!=''">
              <ul type="{$list_type}">
                <xsl:apply-templates select="EL"/>
                <li class="signeplus"> <img src="config_EAST/signe_plus.png"/></li>
              </ul>
            </xsl:when>
            <xsl:otherwise>
              <ul>
                <xsl:apply-templates select="EL"/>
                <li class="signeplus"> <img src="config_EAST/signe_plus.png"/></li>
              </ul>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="normalize-space($list_type)!=''">
              <ul class="highinc" type="{$list_type}">
                <xsl:apply-templates select="EL"/>
                <li class="signeplus"> <img src="config_EAST/signe_plus.png"/></li>
              </ul>
            </xsl:when>
            <xsl:otherwise>
              <ul class="highinc">
                <xsl:apply-templates select="EL"/>
                <li class="signeplus"> <img src="config_EAST/signe_plus.png"/></li>
              </ul>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>

    <xsl:when test="normalize-space(@mode)='progressif'">
      <xsl:choose>
        <xsl:when test="count(ancestor::LISTE)!=0">
          <xsl:choose>
            <xsl:when test="normalize-space($list_type)!=''">
              <ul type="{$list_type}">
                <xsl:apply-templates select="EL"/>
                <li class="signeplus"> <img src="config_EAST/signe_plus.png"/></li>
              </ul>
            </xsl:when>
            <xsl:otherwise>
              <ul>
                <xsl:apply-templates select="EL"/>
                <li class="signeplus"> <img src="config_EAST/signe_plus.png"/></li>
              </ul>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="normalize-space($list_type)!=''">
              <ul class="progressive" type="{$list_type}">
                <xsl:apply-templates select="EL"/>
                <li class="signeplus"> <img src="config_EAST/signe_plus.png"/></li>
              </ul>
            </xsl:when>
            <xsl:otherwise>
              <ul class="progressive">
                <xsl:apply-templates select="EL"/>
                <li class="signeplus"> <img src="config_EAST/signe_plus.png"/></li>
              </ul>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>

    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="normalize-space($list_type)!=''">
            <ul type="{$list_type}">
              <xsl:apply-templates select="EL"/>
            </ul>
        </xsl:when>
        <xsl:otherwise>
          <ul>
            <xsl:apply-templates select="EL"/>
          </ul>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>

  </xsl:choose>
</xsl:template>

<xsl:template name="totallength">
  <xsl:param name="length" />
  <xsl:param name="textnode" />

  <xsl:if test="$textnode">
    <xsl:variable name="getlength">
      <xsl:value-of select="string-length(normalize-space($textnode))" />
    </xsl:variable>
    <xsl:call-template name="totallength">
      <xsl:with-param name="length" select="$length+$getlength" />
      <xsl:with-param name="textnode" select="$textnode/following-sibling::text()[1]" />
    </xsl:call-template>
  </xsl:if>

  <xsl:if test="not($textnode)">
    <xsl:value-of select="$length" />
  </xsl:if>
</xsl:template>

<xsl:template match="EL">
  <xsl:variable name="textlenght">
    <xsl:call-template name="totallength">
      <xsl:with-param name="length" select="0" />
      <xsl:with-param name="textnode" select="text()" />
    </xsl:call-template>
  </xsl:variable>

  <xsl:choose>
    <!-- Element de liste qui n'ont que des elements LISTE comme fils ( listes imbriquées ) : on laisse tomber -->
    <xsl:when test="$textlenght = 0 and count(child::*[name()!='LISTE']) = 0"><xsl:apply-templates/></xsl:when>
    <xsl:otherwise>
      <xsl:variable name="npart"> <xsl:value-of select="count(ancestor-or-self::PARTIE)"/>  </xsl:variable>
      <xsl:variable name="nsect"> <xsl:value-of select="count(ancestor-or-self::SECTION)"/>  </xsl:variable>
      <xsl:variable name="nlist"> <xsl:value-of select="count(ancestor-or-self::LISTE)"/>  </xsl:variable>
      <xsl:variable name="nitem"> <xsl:value-of select="count(preceding::EL)"/>  </xsl:variable>

      <xsl:variable name="id_el"> <xsl:value-of select="concat('l',$npart,$nsect,$nlist,$nitem)"/> </xsl:variable>
      <xsl:variable name="id_span"> <xsl:value-of select="concat('s',$npart,$nsect,$nlist,$nitem)"/> </xsl:variable>

      <xsl:variable name="li_class">
        <xsl:choose>
          <xsl:when test="count(ancestor::LISTE[@mode ='incremental_allume'])=0" >
            <xsl:value-of select="'li_class'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="'highlight'"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <li id="{$id_el}" class="{$li_class}">
        <span id="{$id_span}" class="spanli">
          <xsl:choose>
            <xsl:when test="count(descendant::LISTE)=0">
              <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
              <!-- <xsl:apply-templates select="text()|EMPHASE|CODE"/>-->
              <xsl:apply-templates select="child::*[name()!='LISTE'] | child::text()"/>
            </xsl:otherwise>
          </xsl:choose>
        </span>

        <!--<xsl:if test="count(descendant::LISTE)!=0"> <xsl:apply-templates select="child::*[name()!='EMPHASE' and name()!='CODE']"/> </xsl:if>-->
        <xsl:if test="count(descendant::LISTE)!=0"> <xsl:apply-templates select="LISTE"/> </xsl:if>
        <xsl:if test="normalize-space(../@mode)='pliage'">
          <xsl:if test="count(descendant::LISTE)!=0">
            <img class="plus" src="config_EAST/signe_plus.png"/>
          </xsl:if>
        </xsl:if>
        <xsl:if test="normalize-space(../@mode)='accordeon'">
          <img class="plus" src="config_EAST/signe_plus.png"/>
        </xsl:if>
      </li>
      <!--  Couleurs des puces et des textes -->

      <xsl:choose>
        <xsl:when test="normalize-space(../@image_puce)!='' or normalize-space(/EAST/PREFERENCES/PUCE[@level=$nlist]/@image)!='' or normalize-space(../@couleur_puce)!='' or normalize-space(/EAST/PREFERENCES/PUCE[@level=$nlist]/@colorpuce)!='' or normalize-space(/EAST/PREFERENCES/PUCE[@level=$nlist]/@colortexte)!='' or normalize-space(../@couleur_texte)!=''">
          <xsl:variable name="imagepuce">
            <xsl:choose>
              <xsl:when test="normalize-space(../@image_puce)!=''">
                <xsl:value-of select="../@image_puce"/>
              </xsl:when>
              <xsl:when test="normalize-space(/EAST/PREFERENCES/PUCE[@level=$nlist]/@image)!=''">
                <xsl:value-of select="/EAST/PREFERENCES/PUCE[@level=$nlist]/@image"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="''"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>

          <xsl:variable name="colpuce">
            <xsl:choose>
              <xsl:when test="normalize-space(../@couleur_puce)!=''">
                <xsl:value-of select="../@couleur_puce"/>
              </xsl:when>
              <xsl:when test="normalize-space(/EAST/PREFERENCES/PUCE[@level=$nlist]/@colorpuce)!=''">
                <xsl:value-of select="/EAST/PREFERENCES/PUCE[@level=$nlist]/@colorpuce"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="'black'"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>

          <xsl:variable name="coltext">
            <xsl:choose>
              <xsl:when test="normalize-space(../@couleur_texte)!=''">
                <xsl:value-of select="../@couleur_texte"/>
              </xsl:when>
              <xsl:when test="normalize-space(/EAST/PREFERENCES/PUCE[@level=$nlist]/@colortexte)!=''">
                <xsl:value-of select="/EAST/PREFERENCES/PUCE[@level=$nlist]/@colortexte"/>
              </xsl:when>
              <xsl:when test="normalize-space(/EAST/PREFERENCES/PAGE/@textcolor)!=''">
                <xsl:value-of select="/EAST/PREFERENCES/PAGE/@textcolor"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="'black'"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>

          <script type="text/javascript">
            var li<xsl:value-of select="$id_el"/> = document.getElementById("<xsl:value-of select="$id_el"/>");
            var span<xsl:value-of select="$id_span"/> = document.getElementById("<xsl:value-of select="$id_span"/>");

            li<xsl:value-of select="$id_el"/>.style.color = "<xsl:value-of select="$colpuce"/>";

            <xsl:if test="normalize-space(../@couleur_puce)=''">
              li<xsl:value-of select="$id_el"/>.style.listStyleImage = "url(<xsl:value-of select="$imagepuce"/>)";
            </xsl:if>

            <xsl:if test="$coltext!=''">span<xsl:value-of select="$id_span"/>.style.color = "<xsl:value-of select="$coltext"/>";</xsl:if>
          </script>
        </xsl:when>
        <xsl:otherwise>
          <!-- <xsl:if test="normalize-space(count(ancestor::LISTE[@mode ='incremental_allume'])) = 0"> -->
            <script type="text/javascript">
              var li<xsl:value-of select="$id_el"/> = document.getElementById("<xsl:value-of select="$id_el"/>");
              var span<xsl:value-of select="$id_span"/> = document.getElementById("<xsl:value-of select="$id_span"/>");

              li<xsl:value-of select="$id_el"/>.style.color = "black";
              span<xsl:value-of select="$id_span"/>.style.color = "black";
            </script>
          <!-- </xsl:if> -->
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="LISTEDEF">
  <xsl:if test="normalize-space(TITRE)!=''">
    <h3><xsl:value-of select="TITRE"/></h3>
  </xsl:if>
  <dl>
    <xsl:apply-templates select="TERME | DEF"/>
  </dl>
</xsl:template>

<xsl:template match="TERME">
  <dt><xsl:apply-templates/></dt>
</xsl:template>

<xsl:template match="DEF">
  <dd><xsl:apply-templates/></dd>
</xsl:template>

<xsl:template match="ESP"><xsl:text>&#xA0;</xsl:text></xsl:template>

<xsl:template match="BR"><br/></xsl:template>

<xsl:template match="IMAGE">
  <xsl:choose>
    <xsl:when test="normalize-space(@largeur)!='' or normalize-space(@hauteur)!=''">
      <xsl:variable name="width">
        <xsl:value-of select="concat(normalize-space(@largeur),'%')"/>
      </xsl:variable>
      <xsl:variable name="height">
        <xsl:value-of select="concat(normalize-space(@hauteur),'%')"/>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="normalize-space(@alt)!=''">
          <img alt="{@alt}" src="{@fichier}" width="{$width}" height="{$height}"/>
        </xsl:when>
        <xsl:otherwise>
          <img src="{@fichier}" width="{$width}" height="{$height}"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="normalize-space(@alt)!=''">
          <img alt="{@alt}" src="{@fichier}"/>
        </xsl:when>
        <xsl:otherwise>
          <img src="{@fichier}"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="VIDEO">

  <xsl:variable name="controls">
    <xsl:choose>
      <xsl:when test="normalize-space(@controls)!='' and normalize-space(@controls)!='false' and normalize-space(@controls)!='0'">
        <xsl:value-of select="'true'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'false'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="poster">
    <xsl:choose>
      <xsl:when test="normalize-space(@poster)=''">
        <xsl:value-of select="'config_EAST/videos.png'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="normalize-space(@poster)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="width">
    <xsl:choose>
      <xsl:when test="normalize-space(@largeur)!=''">
        <xsl:value-of select="concat(normalize-space(@largeur),'%')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="''"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="height">
    <xsl:choose>
      <xsl:when test="normalize-space(@hauteur)!=''">
        <xsl:value-of select="concat(normalize-space(@hauteur),'%')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="''"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="normalize-space(@autoplay)!='' or normalize-space(@controls)!=''">
      <xsl:choose>
        <xsl:when test="normalize-space(@autoplay)!='' and normalize-space(@autoplay)!='false' and normalize-space(@autoplay)!='0' and normalize-space(@controls)!='' and normalize-space(@controls)!='false' and normalize-space(@controls)!='0'">
          <xsl:choose>
            <xsl:when test="normalize-space(@hauteur)!='' or normalize-space(@largeur)!=''">
              <video src="{@fichier}" width="{$width}" height="{$height}" preload="auto" poster="{$poster}" controls="true" autoplay="true">x</video>
            </xsl:when>
            <xsl:otherwise>
              <video src="{@fichier}" preload="auto" poster="{$poster}" controls="true" autoplay="true">x</video>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="normalize-space(@autoplay)!='' and normalize-space(@autoplay)!='false' and normalize-space(@autoplay)!='0' and normalize-space(@controls)=''">
          <xsl:choose>
            <xsl:when test="normalize-space(@hauteur)!='' or normalize-space(@largeur)!=''">
              <video src="{@fichier}" width="{$width}" height="{$height}" preload="auto" poster="{$poster}" autoplay="true">x</video>
            </xsl:when>
            <xsl:otherwise>
              <video src="{@fichier}" preload="auto" poster="{$poster}" autoplay="true">x</video>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="normalize-space(@controls)!='' and normalize-space(@controls)!='false' and normalize-space(@controls)!='0' and normalize-space(@autoplay)=''">
          <xsl:choose>
            <xsl:when test="normalize-space(@hauteur)!='' or normalize-space(@largeur)!=''">
              <video src="{@fichier}" width="{$width}" height="{$height}" preload="auto" poster="{$poster}" controls="true">x</video>
            </xsl:when>
            <xsl:otherwise>
              <video src="{@fichier}" preload="auto" poster="{$poster}" controls="true">x</video>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="normalize-space(@hauteur)!='' or normalize-space(@largeur)!=''">
              <video src="{@fichier}" width="{$width}" height="{$height}" preload="auto" poster="{$poster}">x</video>
            </xsl:when>
            <xsl:otherwise>
              <video src="{@fichier}"  preload="auto" poster="{$poster}">x</video>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <video src="{@fichier}" width="{$width}" height="{$height}" preload="auto" poster="{$poster}">x</video>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="TABLEAU">
  <table border="1" width="100%">
    <xsl:apply-templates/>
  </table>
</xsl:template>

<xsl:template match="LT">
  <tr><xsl:apply-templates/></tr>
</xsl:template>

<xsl:template match="ET">

  <xsl:variable name="th1">
    <xsl:choose>
      <xsl:when test="normalize-space(@textcolor)!=''">
        <xsl:value-of select="concat('color: ',@textcolor,';')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="''"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="th2">
    <xsl:choose>
      <xsl:when test="normalize-space(@backcolor)!=''">
        <xsl:value-of select="concat('background: ',@backcolor,';')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="''"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="th3">
    <xsl:choose>
      <xsl:when test="normalize-space(@image)!=''">
        <xsl:value-of select="concat('background-image: url(',@image,');')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="''"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="th4">
    <xsl:choose>
      <xsl:when test="normalize-space(@font)!=''">
        <xsl:value-of select="concat('font-family: ',@font,';')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="''"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="allths">
    <xsl:value-of select="concat($th1,$th2,$th3,$th4)"/>
  </xsl:variable>

  <th style="{$allths}">
    <xsl:if test="@colspan"><xsl:attribute name="colspan"><xsl:value-of select="@colspan"/></xsl:attribute></xsl:if>
    <xsl:apply-templates/>
  </th>
</xsl:template>

<xsl:template match="CT">

  <xsl:variable name="ct1">
    <xsl:choose>
      <xsl:when test="normalize-space(@textcolor)!=''">
        <xsl:value-of select="concat('color: ',@textcolor,';')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="''"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="ct2">
    <xsl:choose>
      <xsl:when test="normalize-space(@backcolor)!=''">
        <xsl:value-of select="concat('background: ',@backcolor,';')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="''"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="ct3">
    <xsl:choose>
      <xsl:when test="normalize-space(@image)!=''">
        <xsl:value-of select="concat('background-image: url(',@image,');')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="''"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="ct4">
    <xsl:choose>
      <xsl:when test="normalize-space(@font)!=''">
        <xsl:value-of select="concat('font-family: ',@font,';')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="''"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="allcts">
    <xsl:value-of select="concat($ct1,$ct2,$ct3,$ct4)"/>
  </xsl:variable>

  <xsl:variable name="ltpos"><xsl:number count="LT" from="TABLEAU"/></xsl:variable>
  <td class="tableau{1+($ltpos mod 2)}" style="{$allcts}">
    <xsl:if test="@colspan"><xsl:attribute name="colspan"><xsl:value-of select="@colspan"/></xsl:attribute></xsl:if>
    <xsl:if test="@rowspan"><xsl:attribute name="rowspan"><xsl:value-of select="@rowspan"/></xsl:attribute></xsl:if>

    <xsl:apply-templates/>
 </td>
</xsl:template>

<xsl:template match="EQUATION">
  <img alt="{@texte}" class="equation" src="{@image}"/>
</xsl:template>

<xsl:template match="ENVIMAGE">

  <xsl:variable name="div_envimage">
    <xsl:choose>
      <xsl:when test="normalize-space(@image)!=''">
        <xsl:value-of select="concat('background-image: url(',@image,')')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="''"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="tab1">
    <xsl:choose>
      <xsl:when test="normalize-space(@backcolor)!=''">
        <xsl:value-of select="concat('background:',@backcolor,';')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="''"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="tab2">
    <xsl:choose>
      <xsl:when test="normalize-space(@textcolor)!=''">
        <xsl:value-of select="concat('color:',@textcolor,';')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="''"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="alltabs">
    <xsl:value-of select="concat($tab1,$tab2,$div_envimage)"/>
  </xsl:variable>

  <xsl:variable name="titre1">
    <xsl:choose>
      <xsl:when test="normalize-space(@titlecolor)!=''">
        <xsl:value-of select="concat('color:',@titlecolor,';')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="''"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="titre2">
    <xsl:choose>
      <xsl:when test="normalize-space(@titlefont)!=''">
        <xsl:value-of select="concat('font-family:',@titlefont,';')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="''"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="titre3">
    <xsl:choose>
      <xsl:when test="normalize-space(@titleback)!=''">
        <xsl:value-of select="concat('background:',@titleback,';')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="''"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="alltitres">
      <xsl:value-of select="concat($titre1,$titre2,$titre3)"/>
  </xsl:variable>

  <div align="center">
    <table border="0" cellspacing="10" class="envimage" style="{$alltabs}">
      <xsl:if test="normalize-space(TITRE)!=''">
        <tr>
          <td>
            <p class="titreimage" style="{$alltitres}"><xsl:value-of select="TITRE"/></p>
          </td>
        </tr>
      </xsl:if>
      <tr>
        <td>
          <xsl:apply-templates select="IMAGE"/>
        </td>
      </tr>
      <xsl:if test="normalize-space(LEGENDE)!=''">
        <tr>
          <td>
            <xsl:apply-templates select="LEGENDE"/>
          </td>
        </tr>
      </xsl:if>
    </table>
  </div>
</xsl:template>

<xsl:template match="ENVIDEO">

  <xsl:variable name="div_envideo">
    <xsl:choose>
      <xsl:when test="normalize-space(@image)!=''">
        <xsl:value-of select="concat('background-image: url(',@image,')')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="''"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="tab1">
    <xsl:choose>
      <xsl:when test="normalize-space(@backcolor)!=''">
        <xsl:value-of select="concat('background:',@backcolor,';')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="''"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="tab2">
    <xsl:choose>
      <xsl:when test="normalize-space(@textcolor)!=''">
        <xsl:value-of select="concat('color:',@textcolor,';')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="''"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="alltabs">
    <xsl:value-of select="concat($tab1,$tab2,$div_envideo)"/>
  </xsl:variable>

  <xsl:variable name="titre1">
    <xsl:choose>
      <xsl:when test="normalize-space(@titlecolor)!=''">
        <xsl:value-of select="concat('color:',@titlecolor,';')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="''"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="titre2">
    <xsl:choose>
      <xsl:when test="normalize-space(@titlefont)!=''">
        <xsl:value-of select="concat('font-family:',@titlefont,';')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="''"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="titre3">
    <xsl:choose>
      <xsl:when test="normalize-space(@titleback)!=''">
        <xsl:value-of select="concat('background:',@titleback,';')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="''"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="alltitres">
    <xsl:value-of select="concat($titre1,$titre2,$titre3)"/>
  </xsl:variable>

  <div align="center">
    <table border="0" cellspacing="10" class="envimage" style="{$alltabs}">
      <xsl:if test="normalize-space(TITRE)!=''">
        <tr>
          <td>
            <p class="titreimage" style="{$alltitres}"><xsl:value-of select="TITRE"/></p>
          </td>
        </tr>
      </xsl:if>
      <tr>
        <td>
          <xsl:apply-templates select="VIDEO"/>
        </td>
      </tr>
      <xsl:if test="normalize-space(LEGENDE)!=''">
        <tr>
          <td>
            <xsl:apply-templates select="LEGENDE"/>
          </td>
        </tr>
      </xsl:if>
    </table>
  </div>
</xsl:template>

<xsl:template match="LEGENDE">

  <xsl:variable name="fontleg">
    <xsl:choose>
      <xsl:when test="normalize-space(../@font)!=''">
        <xsl:value-of select="concat('font-family: ',../@font,';')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="''"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="colorleg">
    <xsl:choose>
      <xsl:when test="normalize-space(../@textcolor)!=''">
        <xsl:value-of select="concat('color: ',../@textcolor,';')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="''"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="styleleg">
    <xsl:value-of select="concat($fontleg,$colorleg)"/>
  </xsl:variable>

  <div class="legende" style="{$styleleg}">
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="COMMENTAIRE">
  <xsl:if test="$commentaires='oui'">
    <div class="commentaire">
      <xsl:apply-templates/>
    </div>
  </xsl:if>
</xsl:template>

<xsl:template match="APPLET">
  <applet archive="{@archive}" code="{@classe}" height="{@hauteur}" width="{@largeur}">
  <xsl:apply-templates/>
    </applet>
    <br/>
</xsl:template>

<xsl:template match="PARAM">
  <param name="{@nom}" value="{@valeur}"/>
</xsl:template>

<xsl:template match="HTML">
  <xsl:value-of select="." disable-output-escaping="yes"/>
</xsl:template>

</xsl:stylesheet>
