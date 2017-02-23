class Vnu < Formula
  desc "Nu Markup Checker: command-line and server HTML validator"
  homepage "https://validator.github.io/validator/"
  url "https://github.com/validator/validator/releases/download/17.2.1/vnu.jar_17.2.1.zip"
  sha256 "e859b26b9532b4d1a5cb5c3bc873c85dc7a64c05ef7cb3f98ef040690d95609b"
  version_scheme 1

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    libexec.install "vnu.jar"
    bin.write_jar_script libexec/"vnu.jar", "vnu"
  end

  test do
    (testpath/"index.html").write <<-EOS.undent
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
