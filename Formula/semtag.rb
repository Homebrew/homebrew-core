class Semtag < Formula
  desc "Semantic tagging script for git"
  homepage "https://github.com/pnikosis/semtag"
  url "https://github.com/pnikosis/semtag/archive/v0.1.1.tar.gz"
  sha256 "c7becf71c7c14cdef26d3980c3116cce8dad6cd9eb61abcc4d2ff04e2c0f8645"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4d61d959bcec95146dc409dd098ed0dadaf578b7fec0df2d0f031838bad2f85b"
  end

  def install
    bin.install "semtag"
  end

  test do
    touch "file.txt"
    system "git", "init"
    system "git", "add", "file.txt"
    system "git", "commit", "-m'test'"
    system bin/"semtag", "final"
    output = shell_output("git tag --list")
    assert_match "v0.0.1", output
  end
end
