<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xpath-default-namespace="http://www.dmg.org/PMML-4_3" xmlns:pmml="http://www.dmg.org/PMML-4_3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.dmg.org/PMML-4_3 http://www.dmg.org/v4-3/pmml-4-3.xsd">
	<xsl:output method="html"/>
	    <xsl:variable name="vAllowedSymbols"
        select="'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_012345678'"/>

	<xsl:template match="/pmml:PMML">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="pmml:Header">
	</xsl:template>

	<xsl:template match="pmml:MiningModel">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="pmml:Segmentation">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="pmml:Segment">/**Segment <xsl:value-of select="@id"/>**/<xsl:apply-templates/></xsl:template>

	<xsl:template match="pmml:True" mode="particular">
		true
	</xsl:template>

	<xsl:template match="pmml:TreeModel">

		<xsl:apply-templates select="pmml:Node"/>
	</xsl:template>

	<xsl:template match="pmml:Node">
		<xsl:if test="position() != last()">
			Array(
		</xsl:if>
		new DecisionTree (
			<xsl:apply-templates select="pmml:True|pmml:CompoundPredicate|pmml:SimplePredicate" mode="particular"/>, <xsl:choose>
			<xsl:when test="pmml:Node">
				<xsl:apply-templates select="pmml:Node"/>
			</xsl:when>
			<xsl:otherwise>
				"<xsl:value-of select="@score"/>"
			</xsl:otherwise>
			</xsl:choose>)
		<xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if>
		<xsl:if test="position() = last() and position() != 1"><xsl:text>)</xsl:text></xsl:if>
	</xsl:template>

	<xsl:template match="pmml:CompoundPredicate" mode="particular">
	        function(observation) { 
	        	return( <xsl:apply-templates select="pmml:SimplePredicate"/> true);
	        }

	</xsl:template>

					  <xsl:template match="pmml:SimplePredicate">observation.<xsl:value-of
					    select="translate(@field, translate(@field, $vAllowedSymbols, ''), '_')"/>
					    <xsl:call-template name="operator">
					      <xsl:with-param name="operator" select = "@operator" />
					    </xsl:call-template>
					   	<xsl:value-of select="@value"/> &amp;&amp;
					  </xsl:template>
					  
					  <xsl:template match="pmml:SimplePredicate" mode="particular">function(observation) { 
	        	        return observation.<xsl:value-of
					    select="translate(@field, translate(@field, $vAllowedSymbols, ''), '_')"/>
					    <xsl:call-template name="operator">
					      <xsl:with-param name="operator" select = "@operator" />
					    </xsl:call-template>
					   	<xsl:value-of select="@value"/>}
					  </xsl:template>

	<xsl:template name ="operator">
	<xsl:param name = "operator" />
	<xsl:choose>
		<xsl:when test="$operator='lessThan'">
		<xsl:text disable-output-escaping="yes"> &lt; </xsl:text>
		</xsl:when>
		<xsl:when test="$operator='greaterOrEqual'">
		<xsl:text disable-output-escaping="yes"> &gt;= </xsl:text>
		</xsl:when>
		<xsl:otherwise> ? </xsl:otherwise>
	</xsl:choose>
	</xsl:template>

	<xsl:template match="*">
	</xsl:template>

</xsl:stylesheet>
