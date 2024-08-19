class Vnu < Formula
  desc "Nu Markup Checker: command-line and server HTML validator"
  homepage "https://validator.github.io/validator/"
  url "https://registry.npmjs.org/vnu-jar/-/vnu-jar-23.4.11.tgz"
  sha256 "cbba595a86d680d48e9c5261a16d9ef409e5658ad8aa47081c593690a652cf0f"
  license "MIT"
  version_scheme 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "81b343a03a3a7f211a61a6793bdea0d180afb01e95b2cd311ce4fb296ee11503"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "81b343a03a3a7f211a61a6793bdea0d180afb01e95b2cd311ce4fb296ee11503"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81b343a03a3a7f211a61a6793bdea0d180afb01e95b2cd311ce4fb296ee11503"
    sha256 cellar: :any_skip_relocation, sonoma:         "81b343a03a3a7f211a61a6793bdea0d180afb01e95b2cd311ce4fb296ee11503"
    sha256 cellar: :any_skip_relocation, ventura:        "81b343a03a3a7f211a61a6793bdea0d180afb01e95b2cd311ce4fb296ee11503"
    sha256 cellar: :any_skip_relocation, monterey:       "81b343a03a3a7f211a61a6793bdea0d180afb01e95b2cd311ce4fb296ee11503"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3a803564acec3a4e5ed15e65dfa6d61d1e4e957254a1018f5b131a5846e1b01"
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
