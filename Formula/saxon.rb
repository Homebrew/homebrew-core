class Saxon < Formula
  desc "XSLT and XQuery processor"
  homepage "https://saxon.sourceforge.io"
  url "https://downloads.sourceforge.net/project/saxon/Saxon-HE/10/Java/SaxonHE10-5J.zip"
  version "10.5"
  sha256 "2e400e33facc77eb6a31aae93f68525e3203be8639685c0d6e55507605709b1d"

  livecheck do
    url :stable
    regex(%r{url=.*?/SaxonHE(\d+(?:[.-]\d+)+)J?\.(?:t|zip)}i)
    strategy :sourceforge do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub("-", ".") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5ee8d289ede04614c9656c1de0945563936d8e73696bbecb35cd8e80859525b7"
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
