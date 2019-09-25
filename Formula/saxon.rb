class Saxon < Formula
  desc "XSLT and XQuery processor"
  homepage "https://saxon.sourceforge.io"
  url "https://downloads.sourceforge.net/project/saxon/Saxon-HE/9.9/SaxonHE9-9-1-4J.zip"
  version "9.9.1.4"
  sha256 "5c0b4ad1f81958ebe18cc40641518671c39be36f25a1a10ace73b69c1f2eb671"

  bottle :unneeded

  def install
    libexec.install Dir["*.jar", "doc", "notices"]
    bin.write_jar_script libexec/"saxon9he.jar", "saxon"
  end

  test do
    (testpath/"test.xml").write <<~EOS
      <test>It works!</test>
    EOS
    (testpath/"test.xsl").write <<~EOS
      <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
        <xsl:template match="/">
          <html>
            <body>
              <p><xsl:value-of select="test"/></p>
            </body>
          </html>
        </xsl:template>
      </xsl:stylesheet>
    EOS
    assert_equal <<~EOS.chop, shell_output("#{bin}/saxon test.xml test.xsl")
      <html>
         <body>
            <p>It works!</p>
         </body>
      </html>
    EOS
  end
end
