class Saxon < Formula
  desc "XSLT and XQuery processor"
  homepage "https://saxon.sourceforge.io"
  url "https://downloads.sourceforge.net/project/saxon/Saxon-HE/9.8/SaxonHE9-8-0-4J.zip"
  version "9.8.0.4"
  sha256 "e19cdc64111af9e4c84b6d67bed792c3017775465cb42f6063af9f2d66ff5154"

  bottle :unneeded

  def install
    libexec.install Dir["*.jar", "doc", "notices"]
    bin.write_jar_script libexec/"saxon9he.jar", "saxon"
  end

  test do
    (testpath/"test.xml").write <<-XML.undent
      <test>It works!</test>
    XML
    (testpath/"test.xsl").write <<-XSL.undent
      <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
        <xsl:template match="/">
          <html>
            <body>
              <p><xsl:value-of select="test"/></p>
            </body>
          </html>
        </xsl:template>
      </xsl:stylesheet>
    XSL
    assert_equal <<-HTML.undent.chop, shell_output("#{bin}/saxon test.xml test.xsl")
      <html>
         <body>
            <p>It works!</p>
         </body>
      </html>
    HTML
  end
end
