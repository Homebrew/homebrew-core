class Vnu < Formula
  desc "Nu Markup Checker: command-line and server HTML validator"
  homepage "https://validator.github.io/validator/"
  url "https://registry.npmjs.org/vnu-jar/-/vnu-jar-23.4.11.tgz"
  sha256 "cbba595a86d680d48e9c5261a16d9ef409e5658ad8aa47081c593690a652cf0f"
  license "MIT"
  version_scheme 1

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "78a79722951e515741231ad763a31c877c22311e38a212760cf33cb64e03d06f"
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
