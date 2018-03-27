class Vnu < Formula
  desc "Nu Markup Checker: command-line and server HTML validator"
  homepage "https://validator.github.io/validator/"
  url "https://github.com/validator/validator/releases/download/18.3.0/vnu.jar_18.3.0.zip"
  sha256 "9f8bcdc94b5496b9fcb8c01e20fd22684a7dcbbae48804aeb027f17315fb3f8d"
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
