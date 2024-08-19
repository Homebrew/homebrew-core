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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ac4085e4f707a91b86a0254c7f45e5acf92ccc0b47c0e195f1392892d2d4ca40"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac4085e4f707a91b86a0254c7f45e5acf92ccc0b47c0e195f1392892d2d4ca40"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac4085e4f707a91b86a0254c7f45e5acf92ccc0b47c0e195f1392892d2d4ca40"
    sha256 cellar: :any_skip_relocation, sonoma:         "ac4085e4f707a91b86a0254c7f45e5acf92ccc0b47c0e195f1392892d2d4ca40"
    sha256 cellar: :any_skip_relocation, ventura:        "0f43e474b01c6429b086d7573dbc8a4da1bf5bec5095d190e874528fe0468f2b"
    sha256 cellar: :any_skip_relocation, monterey:       "ac4085e4f707a91b86a0254c7f45e5acf92ccc0b47c0e195f1392892d2d4ca40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "108a2c67d34a7e79fa57431cf707b0c7eee33c49940e2a8f9a972d244fe53393"
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
