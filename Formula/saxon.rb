class Saxon < Formula
  desc "XSLT and XQuery processor"
  homepage "https://saxon.sourceforge.io"
  url "https://downloads.sourceforge.net/project/saxon/Saxon-HE/10/Java/SaxonHE10-6J.zip"
  version "10.6"
  sha256 "0e590ede60eef6d8a98e759f72769c20417173f99191ebbc2f9ec4e331dbc296"

  livecheck do
    url :stable
    regex(%r{url=.*?/SaxonHE(\d+(?:[.-]\d+)+)J?\.(?:t|zip)}i)
    strategy :sourceforge do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub("-", ".") }
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "4db59b57012438613c9fac1e2685c22598b91a3ce7ebbff0a1e3eb1dd2320092"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*.jar", "doc", "notices"]
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
