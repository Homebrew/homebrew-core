class Umple < Formula
  desc "Modeling tool/programming language that enables Model-Oriented Programming"
  homepage "https://cruise.umple.org/umple/"
  url "https://github.com/umple/umple/releases/download/v1.38.0/umple-1.38.0.8918.bda708970.jar"
  sha256 "64a4c87bf83c8a977f7e84511a400673590d9b648b4e08567e1a86f0f944598e"
  license "MIT"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    manifest_sha256 "2860345f3bedf5f78d78a6cb25cfb1f1ad2051e6bf19ba124608dfb96c1c9c30"
    sha256 cellar: :any_skip_relocation, all: "2125eee7a8f7d8a4c805d1acf2a2f0049c701c6af73b1a23f9bb7eba7278ef07"
  end

  depends_on "openjdk"

  deny_network_access!

  def install
    filename = File.basename(stable.url)

    libexec.install filename
    bin.write_jar_script libexec/filename, "umple"
  end

  test do
    (testpath/"test.ump").write("class X{ a; }")
    system bin/"umple", "test.ump", "-c", "-"
    assert_path_exists testpath/"X.java"
    assert_path_exists testpath/"X.class"
  end
end
