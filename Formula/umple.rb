class Umple < Formula
  desc "Modeling tool/programming language that enables Model-Oriented Programming"
  homepage "https://www.umple.org"
  url "https://github.com/umple/umple/releases/download/v1.31.1/umple-1.31.1.5860.78bb27cc6.jar"
  version "1.31.1.5860.78bb27cc6"
  sha256 "686beb3c8aa3c0546f4a218dad353f4efce05aed056c59ccf3d5394747c0e13d"
  license "MIT"

  livecheck do
    url :stable
    regex(/href=.*?umple[._-]v?(\d+(?:\.\d+)+(?:\.[\da-f]+)?)\.jar/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b588ed54d528a7301c1450bd03a8651abcb88119e18dd9166631adf3143a2180"
    sha256 cellar: :any_skip_relocation, big_sur:       "b588ed54d528a7301c1450bd03a8651abcb88119e18dd9166631adf3143a2180"
    sha256 cellar: :any_skip_relocation, catalina:      "b588ed54d528a7301c1450bd03a8651abcb88119e18dd9166631adf3143a2180"
    sha256 cellar: :any_skip_relocation, mojave:        "b588ed54d528a7301c1450bd03a8651abcb88119e18dd9166631adf3143a2180"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8290ce892b832b7c4fa229b7ad10b0e2b8f78371f3c23c07a07542f2ae4af18b"
    sha256 cellar: :any_skip_relocation, all:           "fd3ee458d75e5ae83f3fcdda38e5ac0687abd1db886a0006a313085463c8691a"
  end

  depends_on "openjdk"

  def install
    libexec.install "umple-#{version}.jar"
    bin.write_jar_script libexec/"umple-#{version}.jar", "umple"
  end

  test do
    (testpath/"test.ump").write("class X{ a; }")
    system "#{bin}/umple", "test.ump", "-c", "-"
    assert_predicate testpath/"X.java", :exist?
    assert_predicate testpath/"X.class", :exist?
  end
end
