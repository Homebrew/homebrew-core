class Umple < Formula
  desc "Modeling tool/programming language that enables Model-Oriented Programming"
  homepage "https://www.umple.org"
  url "https://github.com/umple/umple/releases/download/v1.30.2/umple-1.30.2.5248.dba0a5744.jar"
  version "1.30.2.5248.dba0a5744"
  sha256 "11523494f9f4f360cce9226ed7f68641aa733fa13d4009f871060f9fe54c6a52"
  license "MIT"

  depends_on "ant"
  depends_on "ant-contrib"
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
