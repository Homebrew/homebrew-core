class Saxon < Formula
  desc "XSLT and XQuery processor"
  homepage "https://github.com/Saxonica/Saxon-HE"
  url "https://github.com/Saxonica/Saxon-HE/blob/main/12/Java/SaxonHE12-1J.zip?raw=true"
  version "12.1"
  sha256 "efd00db987f76f36c472f92f4ece8d9899aa02e667fd6bec5ed2afd4adc6afd8"
  license all_of: ["BSD-3-Clause", "MIT", "MPL-2.0"]

  livecheck do
    url "https://raw.githubusercontent.com/Saxonica/Saxon-HE/main/README.md"
    regex(/latest\s+release\s+of\s+Saxon-HE\s+is\s+\[?(v?(\d+(?:\.\d+)*))\]?/im)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6e57596a66b1bf41dbdd07498b2deb5dbdd943275d89a8f9d7d7b289154639f7"
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
      <!DOCTYPE HTML><html>
         <body>
            <p>It works!</p>
         </body>
      </html>
    EOS
  end
end
