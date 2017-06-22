class Saxon < Formula
  desc "XSLT and XQuery processor"
  homepage "https://saxon.sourceforge.io"
  url "https://downloads.sourceforge.net/project/saxon/Saxon-HE/9.8/SaxonHE9-8-0-1J.zip"
  version "9.8.0.1"
  sha256 "9479016bfd8e60019d7a78f4ec73ed71e26adb8f0e73a00cc8aed452afaa09ae"

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
