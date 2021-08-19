class Umple < Formula
  desc "Modeling tool/programming language that enables Model-Oriented Programming"
  homepage "https://www.umple.org"
  url "https://github.com/umple/umple/releases/download/v1.31.1/umple-1.31.1.5860.78bb27cc6.jar"
  version "1.31.1.5860.78bb27cc6"
  sha256 "686beb3c8aa3c0546f4a218dad353f4efce05aed056c59ccf3d5394747c0e13d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bd41188baf2192be2d75e098a45efa7a7d83e7c8a76daad5b059bdff6f859071"
    sha256 cellar: :any_skip_relocation, big_sur:       "bd41188baf2192be2d75e098a45efa7a7d83e7c8a76daad5b059bdff6f859071"
    sha256 cellar: :any_skip_relocation, catalina:      "bd41188baf2192be2d75e098a45efa7a7d83e7c8a76daad5b059bdff6f859071"
    sha256 cellar: :any_skip_relocation, mojave:        "bd41188baf2192be2d75e098a45efa7a7d83e7c8a76daad5b059bdff6f859071"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c80a927eb6c67b19974ded86bca1daca1e2ad6d41e6e0a5c56b8f2e409b89730"
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
