class Umple < Formula
  desc "Modeling tool/programming language that enables Model-Oriented Programming"
  homepage "https://www.umple.org"
  url "https://github.com/umple/umple/releases/download/v1.31.1/umple-1.31.1.5860.78bb27cc6.jar"
  version "1.31.1"
  sha256 "686beb3c8aa3c0546f4a218dad353f4efce05aed056c59ccf3d5394747c0e13d"
  license "MIT"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c9ff4ae3bd259bc877ea8cd121f52f1f33679ec3ad406bab86df6350aaf0ea42"
  end

  depends_on "openjdk"

  def install
    filename = File.basename(stable.url)

    libexec.install filename
    bin.write_jar_script libexec/filename, "umple"
  end

  test do
    (testpath/"test.ump").write("class X{ a; }")
    system "#{bin}/umple", "test.ump", "-c", "-"
    assert_predicate testpath/"X.java", :exist?
    assert_predicate testpath/"X.class", :exist?
  end
end
