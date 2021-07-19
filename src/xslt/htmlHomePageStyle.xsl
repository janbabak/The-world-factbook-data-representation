<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/">
        <html lang="en">
            <head>
                <link rel="stylesheet" href="../css/homePageStyle.css"/>
            </head>

            <body>
                <!-- navigation bar -->
                <nav>
                    <ul>
                        <xsl:for-each select="data/states/state">
                            <li>
                                <a>
                                    <xsl:attribute name ="href">
                                        <xsl:value-of select="@name"/>
                                        <xsl:text>.html</xsl:text>
                                    </xsl:attribute>
                                    <xsl:value-of select="@name"/>
                                </a>
                            </li>
                        </xsl:for-each>
                    </ul>
                </nav>

                <!-- page content -->
                <div class="content">
                    <h1>Fact book</h1>
                    <div class="text">discover curiosities about Europe</div>
                </div>
                <img src="../../images/homePagePicture.svg"/>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
