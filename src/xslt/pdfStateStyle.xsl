<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/">
        <xsl:variable name="state-name" select="state/@name" />
        
        <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">

            <!-- layout -->
            <fo:layout-master-set>
                <fo:simple-page-master master-name="states" page-height="11in" page-width="8.5in">
                    <!-- body -->
                    <fo:region-body region-name="only_region" margin="1in" background-color="white" />
                    <!-- header -->
                    <fo:region-before extent="11mm" />
                    <!-- footer -->
                    <fo:region-after extent="10mm" />
                </fo:simple-page-master>
            </fo:layout-master-set>

            <fo:page-sequence master-reference="states">

                <!-- header - state name -->
                <fo:static-content flow-name="xsl-region-before">
                    <fo:block text-align="center" margin-top="15pt" text-transform="capitalize">
                        <!-- state name -->
                        <xsl:value-of select="$state-name" />
                    </fo:block>
                </fo:static-content>

                <!-- footer - page number -->
                <fo:static-content flow-name="xsl-region-after">
                    <fo:block text-align="center">
                        <xsl:text>Page </xsl:text>
                        <fo:page-number />
                    </fo:block>
                </fo:static-content>

                <!-- body -->
                <fo:flow flow-name="only_region">
                    <!-- heading -->
                    <fo:block text-align="center"
                              font-size="40pt"
                              margin-bottom="0.5in"
                              margin-top="2in"
                              color="tomato"
                              text-transform="capitalize"
                    >
                        <xsl:value-of select="$state-name" />
                    </fo:block>
                    
                    <!-- flag image -->
                    <fo:block margin-bottom="10mm" text-align="center">
                        <fo:external-graphic content-width="40mm" content-height="scale-to-fit">
                            <xsl:attribute name="src">
                                <xsl:text>url('../images/flags/</xsl:text>
                                <xsl:value-of select="$state-name" />
                                <xsl:text>Flag.jpg')</xsl:text>
                            </xsl:attribute>
                        </fo:external-graphic>
                    </fo:block>

                    <!-- locator map image -->
                    <fo:block margin-bottom="10mm" text-align="center">
                        <fo:external-graphic content-width="70mm" content-height="scale-to-fit">
                            <xsl:attribute name="src">
                                <xsl:text>url('../images/maps/</xsl:text>
                                <xsl:value-of select="$state-name" />
                                <xsl:text>LocatorMap.jpg')</xsl:text>
                            </xsl:attribute>
                        </fo:external-graphic>
                    </fo:block>

                    <!-- table of contents of document/navigation links -->
                    <fo:block font-size="25pt"
                              text-align="center"
                              margin-bottom="5pt"
                              margin-top="40pt"
                              break-before="page"
                    >
                        Table of contents:
                    </fo:block>
                    <fo:block break-after="page">
                        <xsl:for-each select="state/section">
                            <fo:block text-align="center"
                                      font-size="20pt"
                            >
                                <!-- link to section -->
                                <fo:basic-link color="blue"
                                            margin-bottom="9pt"
                                            text-decoration="underline"
                                >
                                    <xsl:attribute name="internal-destination"> 
                                        <xsl:value-of select="@heading" />
                                    </xsl:attribute>
                                    <xsl:value-of select="@heading" />
                                </fo:basic-link>
                            </fo:block>
                        </xsl:for-each>
                    </fo:block>

                    <!-- section -->
                    <xsl:for-each select="state/section">
                        <fo:block margin-bottom="10pt">
                            <!-- section name -->
                            <fo:block font-size="24pt"
                                    margin-bottom="7pt"
                                    text-transform="capitalize"
                                    font-weight="bold"
                                    color="tomato"
                            >
                                <xsl:attribute name="id">
                                    <xsl:value-of select="@heading" />
                                </xsl:attribute>
                                <xsl:number count="section" format="1. " />
                                <xsl:value-of select="@heading" />
                            </fo:block>

                            <!-- subsection -->
                            <xsl:for-each select="subsection">
                                <!-- subsection name -->
                                <fo:block font-size="20pt" margin-bottom="5pt">
                                    <xsl:number count="section" format="1." />
                                    <xsl:number count="subsection" format="1 " />
                                    <xsl:value-of select="@heading" />
                                </fo:block>

                                <!-- subsection content -->
                                <xsl:for-each select="subsectionparagraph">
                                    <!-- subsection paragraph -->
                                    <fo:block text-align="justify" margin-bottom="7pt">
                                        <xsl:for-each select="field">
                                            <fo:block font-weight="bold">
                                                <xsl:value-of select="subject" />
                                            </fo:block>
                                            <fo:block>
                                                <xsl:value-of select="data" />
                                            </fo:block>
                                        </xsl:for-each>
                                    </fo:block>
                                </xsl:for-each>

                            </xsl:for-each>
                        </fo:block>

                    </xsl:for-each>
                            
                </fo:flow>
                
            </fo:page-sequence>

        </fo:root>
    </xsl:template>
</xsl:stylesheet>