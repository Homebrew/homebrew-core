class Saxon < Formula
  desc "XSLT and XQuery processor"
  homepage "https://github.com/Saxonica/Saxon-HE"
  url "https://github.com/Saxonica/Saxon-HE/releases/download/SaxonHE12-5/SaxonHE12-5J.zip"
  version "12.5"
  sha256 "35a46728792bd4cec2fc262d48777b4c79b5cdeef03d2981e3a64ecb3a19f716"
  license all_of: ["BSD-3-Clause", "MIT", "MPL-2.0"]

  livecheck do
    url :stable
    regex(/^SaxonHE[._-]?v?(\d+(?:[.-]\d+)+)$/i)
    strategy :github_latest do |json, regex|
      match = json["tag_name"]&.match(regex)
      next if match.blank?

      match[1]&.tr("-", ".")
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "a3155919fc60b17e722c0f2c760f08c4a8e39812273cf86f11e3aa0e6e36b2ee"
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
