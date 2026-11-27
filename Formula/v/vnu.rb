class Vnu < Formula
  desc "Nu Markup Checker: command-line and server HTML validator"
  homepage "https://validator.github.io/validator/"
  url "https://registry.npmjs.org/vnu-jar/-/vnu-jar-26.11.26.tgz"
  sha256 "7b2bc855b7128232a733191fa06de5df7e01496b39668746f82c02b6f4ec94bf"
  license "MIT"
  version_scheme 1

  bottle do
    manifest_sha256 "a15cd6ca6a3e7771a9016f4c3bb73f86fb65cfdb0ce417d3e51959a5046afa0c"
    sha256 cellar: :any_skip_relocation, all: "e250dec7cd81c24d3c809e8bb1bdd15296213c13b6cbe296b716de86ec4f979b"
  end

  depends_on "openjdk"

  deny_network_access!

  def install
    libexec.install "build/dist/vnu.jar"
    bin.write_jar_script libexec/"vnu.jar", "vnu"
  end

  test do
    (testpath/"index.html").write <<~HTML
      <!DOCTYPE html>
      <html>
      <head>
        <title>hi</title>
      </head>
      <body>
      </body>
      </html>
    HTML
    system bin/"vnu", testpath/"index.html"
  end
end
