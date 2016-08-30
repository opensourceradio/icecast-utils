<xsl:stylesheet
    xmlns:xalan="http://xml.apache.org/xalan"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">
  <xsl:output
      omit-xml-declaration="no"
      method="text"
      indent="yes"
      encoding="UTF-8"
      doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
      doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" />
  <xsl:template match="/icestats" >
  <!-- <xsl:template match="id('foo')" > -->
    <!-- calulate the total number of listeners -->
    <!-- and then display each mount point -->
    <xsl:for-each select="source" xml:space="preserve">
      <mountpoint> <xsl:value-of select="@mount" /> </mountpoint>:<listener> <xsl:value-of select="listeners" />:
</listener>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
