class Vnu < Formula
  desc "Nu Markup Checker: command-line and server HTML validator"
  homepage "https://validator.github.io/validator/"
  url "https://github.com/validator/validator/releases/download/18.8.29/vnu.jar_18.8.29.zip"
  sha256 "d3a93efe04b7695c831ba72f06401f371d48f444e95152dbfa75e8c91797531a"
  version_scheme 1

  bottle :unneeded

  depends_on :java => "1.8+"

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
