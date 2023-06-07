class Saxon < Formula
  desc "XSLT and XQuery processor"
  homepage "https://github.com/Saxonica/Saxon-HE"
  url "https://github.com/Saxonica/Saxon-HE/blob/main/12/Java/SaxonHE12-2J.zip?raw=true"
  version "12.2"
  sha256 "eaeaf67c3538839406482c4dfcdf0a386e68acbcaaaa094f207c7696136681d0"
  license all_of: ["BSD-3-Clause", "MIT", "MPL-2.0"]

  livecheck do
    url "https://raw.githubusercontent.com/Saxonica/Saxon-HE/main/README.md"
    regex(/latest\s+release\s+of\s+Saxon-HE\s+is\s+\[?(v?(\d+(?:\.\d+)*))\]?/im)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "367cdfe8143ea90e87868904b725cf1a50e8eecb4ac8458c90fd85bae54d0a00"
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
