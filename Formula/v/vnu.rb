class Vnu < Formula
  desc "Nu Markup Checker: command-line and server HTML validator"
  homepage "https://validator.github.io/validator/"
  url "https://registry.npmjs.org/vnu-jar/-/vnu-jar-26.11.20.tgz"
  sha256 "ebd60284d4c918754d4e21204db6ac46fb59108313ea69d6cbf93e009e616e45"
  license "MIT"
  version_scheme 1

  bottle do
    manifest_sha256 "9edb0a5a7401c6bdf5ea0c02dab96d15a72d1fb218dd04f93d8cd8117d9e6c1b"
    sha256 cellar: :any_skip_relocation, all: "da1af0fdae0ba4ce0d15baec082a44dd8b690af509bd2a69eaf5d7a80f86e751"
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
