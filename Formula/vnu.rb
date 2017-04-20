class Vnu < Formula
  desc "Nu Markup Checker: command-line and server HTML validator"
  homepage "https://validator.github.io/validator/"
  url "https://github.com/validator/validator/releases/download/17.3.0/vnu.jar_17.3.0.zip"
  sha256 "12d9baab16c08daa142a50ad368f3906e1aa460dc993a7f2124f003366c590aa"
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
