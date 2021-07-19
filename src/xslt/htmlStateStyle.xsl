<?xml version="1.0" encoding="UTF-8"?>
<!-- <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"> -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/">
        <xsl:variable name="state-name" select="state/@name" />
        <html lang="en">
            <head>
                <!-- custom css -->
                <link rel="stylesheet" href="../css/stateStyle.css" />
                <!-- font awesome -->
                <script src="https://kit.fontawesome.com/aecfdbcad3.js" crossorigin="anonymous"></script>
                <!-- custom script -->
                <script src="../javaScript/script.js"></script>
            </head>

            <body>
                <div class="container">

                    <!-- scroll up button -->
                    <div class="scroll-up-btn" onclick="scrollUp()">
                        <i class="fas fa-angle-up"></i>
                    </div>

                    <div class="heading-flag">
                        <!-- main heading -->
                        <h1>
                            <xsl:value-of select="$state-name" />
                        </h1>
                        <!-- flag picture -->
                        <img>
                            <xsl:attribute name="src">
                                <xsl:text>../../images/flags/</xsl:text>
                                <xsl:value-of select="$state-name" />
                                <xsl:text>Flag.jpg</xsl:text>
                            </xsl:attribute>
                            <xsl:attribute name="alt">
                                <xsl:value-of select="$state-name" />
                                <xsl:text> flag</xsl:text>
                            </xsl:attribute>
                        </img>
                    </div>


                    <!-- contain sections and aside menu -->
                    <div class="flex-container">

                        <!-- menu  - left column -->
                        <ul class="menu card">
                            <li class="home">
                                <i class="fas fa-home" />
                                <a href="index.html">home</a>
                            </li>
                            <hr />
                            <!-- main sections -->
                            <xsl:for-each select="state/section">
                                <li>
                                    <a>
                                        <xsl:attribute name="href">
                                            <xsl:text>#</xsl:text>
                                            <xsl:value-of select="@heading" />
                                        </xsl:attribute>
                                        <xsl:value-of select="@heading" />
                                    </a>
                                </li>
                            </xsl:for-each>
                        </ul>

                        <!-- main sections - right column -->
                        <div class="sections card">

                            <xsl:for-each select="state/section">
                                <section class="section">
                                    <!-- id, to be able link this section -->
                                    <xsl:attribute name="id">
                                        <xsl:value-of select="@heading" />
                                    </xsl:attribute>

                                    <!-- section heading -->
                                    <h2>
                                        <xsl:value-of select="@heading" />
                                    </h2>

                                    <!-- locator map image -->
                                    <xsl:if test="not(compare(@heading, 'geography'))">
                                        <img class="map">
                                            <xsl:attribute name="src">
                                                <xsl:text>../../images/maps/</xsl:text>
                                                <xsl:value-of select="$state-name" />
                                                <xsl:text>LocatorMap.jpg</xsl:text>
                                            </xsl:attribute>
                                            <xsl:attribute name="alt">
                                                <xsl:text>locator map of </xsl:text>
                                                <xsl:value-of select="$state-name" />
                                            </xsl:attribute>
                                        </img>
                                    </xsl:if>


                                    <!-- subsecections -->
                                    <xsl:for-each select="subsection">
                                        <section class="subsection">
                                            <h3>
                                                <xsl:value-of select="@heading" />
                                            </h3>

                                            <!-- subsection paragraphas -->
                                            <xsl:for-each select="subsectionparagraph">
                                                <p>
                                                    <!-- paragraph fields -->
                                                    <xsl:for-each select="field">
                                                        <!-- subject -->
                                                        <strong>
                                                            <xsl:value-of select="subject" />
                                                        </strong>
                                                        <xsl:text> </xsl:text>
                                                        <!-- data -->
                                                        <xsl:value-of select="data" />
                                                        <br />
                                                    </xsl:for-each>
                                                </p>
                                            </xsl:for-each>

                                        </section>
                                    </xsl:for-each>

                                </section>
                            </xsl:for-each>

                        </div>
                    </div>
                </div>

            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>