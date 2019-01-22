class Swagger2markupCli < Formula
  # Original description from GitHub (too long for HomeBrew):
  # "A Swagger to AsciiDoc or Markdown converter to simplify the generation of
  # an up-to-date RESTful API documentation by combining documentation that's
  # been hand-written with auto-generated API documentation."
  desc "Swagger to AsciiDoc or Markdown converter"
  homepage "https://github.com/Swagger2Markup/swagger2markup"
  url "https://jcenter.bintray.com/io/github/swagger2markup/swagger2markup-cli/1.3.3/swagger2markup-cli-1.3.3.jar"
  sha256 "93ff10990f8279eca35b7ac30099460e557b073d48b52d16046ab1aeab248a0a"

  bottle :unneeded
  depends_on :java => "1.8"

  def install
    libexec.install "swagger2markup-cli-#{version}.jar"
    bin.write_jar_script libexec/"swagger2markup-cli-#{version}.jar", "swagger2markup"
  end

  test do
    system bin/"swagger2markup"
  end
end
