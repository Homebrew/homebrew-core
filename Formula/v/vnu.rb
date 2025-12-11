class Vnu < Formula
  desc "Nu Markup Checker: command-line and server HTML validator"
  homepage "https://validator.github.io/validator/"
  url "https://registry.npmjs.org/vnu-jar/-/vnu-jar-25.12.11.tgz"
  sha256 "ec2d96b3b77a36870c1ecd19fa9d37af134eb767894f2d0cad923690070531bb"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "28927b99d78c0376d0ba749671d2e9da3c67939c9c4a3e82739eeea32160f0e8"
  end

  depends_on "openjdk"

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
