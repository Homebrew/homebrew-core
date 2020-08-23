class Vnu < Formula
  desc "Nu Markup Checker: command-line and server HTML validator"
  homepage "https://validator.github.io/validator/"
  url "https://github.com/validator/validator/releases/download/20.3.16/vnu.jar_20.3.16.zip"
  sha256 "1d5b3f0ded0a1e6f9d26a0be5c051a9590a11c8aab2e12d208120a3063e7bdcd"
  license "MIT"
  revision 1
  version_scheme 1

  bottle :unneeded

  depends_on "openjdk"

  def install
    libexec.install "vnu.jar"
    bin.write_jar_script libexec/"vnu.jar", "vnu"
  end

  test do
    (testpath/"index.html").write <<~EOS
      <!DOCTYPE html>
      <html>
      <head>
        <title>hi</title>
      </head>
      <body>
      </body>
      </html>
    EOS
    system bin/"vnu", testpath/"index.html"
  end
end
