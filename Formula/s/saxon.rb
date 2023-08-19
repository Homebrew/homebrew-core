class Saxon < Formula
  desc "XSLT and XQuery processor"
  homepage "https://github.com/Saxonica/Saxon-HE"
  url "https://github.com/Saxonica/Saxon-HE/releases/download/SaxonHE12-3/SaxonHE12-3J.zip"
  version "12.3"
  sha256 "3b69ea2f817cab49072f9e85dae5e01979515f2458844f7334d26025f5ec9418"
  license all_of: ["BSD-3-Clause", "MIT", "MPL-2.0"]

  livecheck do
    url "https://raw.githubusercontent.com/Saxonica/Saxon-HE/main/README.md"
    regex(/latest\s+release\s+of\s+Saxon-HE\s+is\s+\[?(v?(\d+(?:\.\d+)*))\]?/im)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5f98a7699d038c3a265100a9cdcab9861549b945ac8848f87778acd0a277a350"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*.jar", "doc", "lib", "notices"]
    bin.write_jar_script libexec/"saxon-he-#{version.major_minor}.jar", "saxon"
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
      <!DOCTYPE HTML>
      <html>
         <body>
            <p>It works!</p>
         </body>
      </html>
    EOS
  end
end
