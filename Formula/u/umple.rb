class Umple < Formula
  desc "Modeling tool/programming language that enables Model-Oriented Programming"
  homepage "https://www.umple.org"
  url "https://github.com/umple/umple/releases/download/v1.34.0/umple-1.34.0.7242.6b8819789.jar"
  version "1.34.0"
  sha256 "817891ba9299f12bc3753c5902d9d61dc15a80096322aceea5c9996922ace0b5"
  license "MIT"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "73215534a29d049a8b64e101afe675fc1862196658972d90ec2dfc80d86c4db2"
  end

  depends_on "openjdk"

  def install
    filename = File.basename(stable.url)

    libexec.install filename
    bin.write_jar_script libexec/filename, "umple"
  end

  test do
    (testpath/"test.ump").write("class X{ a; }")
    system bin/"umple", "test.ump", "-c", "-"
    assert_predicate testpath/"X.java", :exist?
    assert_predicate testpath/"X.class", :exist?
  end
end
