class Saxon < Formula
  desc "XSLT and XQuery processor"
  homepage "https://saxon.sourceforge.io"
  url "https://downloads.sourceforge.net/project/saxon/Saxon-HE/11/Java/SaxonHE11-4J.zip"
  version "11.4"
  sha256 "2ec48dde4092862b1d3510d7a673d3149ad48885f8831c7878c9a85d79417094"
  license all_of: ["BSD-3-Clause", "MIT", "MPL-2.0"]

  livecheck do
    url :stable
    regex(%r{url=.*?/SaxonHE(\d+(?:[.-]\d+)+)J?\.(?:t|zip)}i)
    strategy :sourceforge do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub("-", ".") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "39e9110c49b68bd767e5faabff06a566bd60649b69e7f0d068006702713eafb8"
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
