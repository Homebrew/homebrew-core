class Vnu < Formula
  desc "Nu Markup Checker: command-line and server HTML validator"
  homepage "https://validator.github.io/validator/"
  url "https://registry.npmjs.org/vnu-jar/-/vnu-jar-22.9.29.tgz"
  sha256 "651b8183b1ffed596260b19b4e2865ff6f4711b1881fdbfe5525af4a72f7cd63"
  license "MIT"
  version_scheme 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "3655c6eb02716c52cda549fb8b86eff95126d71671dfe805a5015748f1181574"
  end

  depends_on "openjdk"

  def install
    libexec.install "build/dist/vnu.jar"
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
