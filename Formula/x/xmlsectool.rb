class Xmlsectool < Formula
  desc "Check schema validity and signature of an XML document"
  homepage "https://wiki.shibboleth.net/confluence/display/XSTJ3/xmlsectool+V3+Home"
  url "https://shibboleth.net/downloads/tools/xmlsectool/4.0.0/xmlsectool-4.0.0-bin.zip"
  sha256 "32a5fd3c92cddb7833249e22c97253fbbf02ae2dc0a385896e6e7ac1d1a77de4"
  license "Apache-2.0"

  livecheck do
    url "https://shibboleth.net/downloads/tools/xmlsectool/latest/"
    regex(/href=.*?xmlsectool[._-]v?(\d+(?:\.\d+)+)(?:-bin)?\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8c96a42cbce1a2f648e740c9b81d868009eccd90cb83ef3cfd74a2cdcf06c6f3"
  end

  depends_on "openjdk"

  def install
    prefix.install "doc/LICENSE.txt"
    rm_r("doc")
    libexec.install Dir["*"]
    (bin/"xmlsectool").write_env_script "#{libexec}/xmlsectool.sh", JAVA_HOME: Formula["openjdk"].opt_prefix
  end

  test do
    system bin/"xmlsectool", "--listAlgorithms"
  end
end
