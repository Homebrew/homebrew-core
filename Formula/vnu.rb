class Vnu < Formula
  desc "Nu Markup Checker: command-line and server HTML validator"
  homepage "https://validator.github.io/validator/"
  url "https://github.com/validator/validator/releases/download/18.11.5/vnu.jar_18.11.5.zip"
  sha256 "b9785a3ab51671509c8d418cc84298b1389ca2d82107aa0537544090a7c51862"
  revision 1
  version_scheme 1

  bottle :unneeded

  depends_on "openjdk"

  def install
    libexec.install "vnu.jar"
    (bin/"vnu").write <<~EOS
      #!/bin/bash
      exec "#{Formula["openjdk"].opt_bin}/java" -jar "#{libexec}/vnu.jar" "$@"
    EOS
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
