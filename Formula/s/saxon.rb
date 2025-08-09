class Saxon < Formula
  desc "XSLT and XQuery processor"
  homepage "https://github.com/Saxonica/Saxon-HE"
  url "https://github.com/Saxonica/Saxon-HE/releases/download/SaxonHE-12-8/SaxonHE12-8J.zip"
  version "12.8"
  sha256 "2ba851aec7925b882208182c48c936230205d558e335636bbe46626bd8003598"
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

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, all: "52b46e48018fc8f9837456bf22e740bb5c1372c481465f15198e7c196b1e0017"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*.jar", "doc", "lib", "notices"]
    bin.write_jar_script libexec/"saxon-he-#{version.major_minor}.jar", "saxon"
    (bin/"gizmo").write <<~EOS
      #!/bin/bash
      export JAVA_HOME="#{Language::Java.overridable_java_home_env("11+")[:JAVA_HOME]}"
      exec "${JAVA_HOME}/bin/java" -cp "#{libexec}/saxon-he-#{version.major_minor}.jar" net.sf.saxon.Gizmo "$@"
    EOS
  end

  test do
    (testpath/"test.xml").write <<~XML
      <test>It works!</test>
    XML
    (testpath/"test.xsl").write <<~XSL
      <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
        <xsl:template match="/">
          <html>
            <body>
              <p><xsl:value-of select="test"/></p>
            </body>
          </html>
        </xsl:template>
      </xsl:stylesheet>
    XSL
    assert_equal <<~HTML.chop, shell_output("#{bin}/saxon test.xml test.xsl")
      <!DOCTYPE HTML>
      <html>
         <body>
            <p>It works!</p>
         </body>
      </html>
    HTML

    (testpath/"test-gizmo.txt").write "show\n"

    # Run the command and capture output
    output = shell_output("#{bin}/gizmo -s:test.xml -q:test-gizmo.txt")

    # Split output into lines
    lines = output.lines.map(&:chomp)

    assert_equal "<test>It works!</test>", lines[1]
  end
end
