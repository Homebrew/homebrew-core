class Vnu < Formula
  desc "Nu Markup Checker: command-line and server HTML validator"
  homepage "https://validator.github.io/validator/"
  url "https://registry.npmjs.org/vnu-jar/-/vnu-jar-26.3.17.tgz"
  sha256 "59a62c35b6a9d95e02f3400daa67ec240d8d7aebe63bf00193b94fcf7d2766e1"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ebb057854d8cc89b6773624e2fc6b513ec9c47b6d77e893cdff8a80eda1cc279"
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
