class Saxon < Formula
  desc "XSLT and XQuery processor"
  homepage "https://github.com/Saxonica/Saxon-HE"
  url "https://github.com/Saxonica/Saxon-HE/blob/main/12/Java/SaxonHE12-0J.zip?raw=true"
  version "12.0"
  sha256 "c476746275dd5a0de1d203e89c21a249a02efe33350b560c4086cb08b0816be7"
  license all_of: ["BSD-3-Clause", "MIT", "MPL-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f251d15ee9c43c8c24034263f84fe9b5b81bddec4507e4891d657597964b078b"
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
