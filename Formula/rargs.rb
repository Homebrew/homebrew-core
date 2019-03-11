class Rargs < Formula
  desc "Util like xargs + awk with pattern matching support"
  homepage "https://github.com/lotabout/rargs"
  url "https://github.com/lotabout/rargs/archive/v0.2.2.tar.gz"
  sha256 "ac6cf3a31ff5b55f86487fa3d3266edf8f562cc6b548d6e636daf373534388ad"

  bottle do
    sha256 "a0dbb61d5792ecd452df10508bd5f77deaa3d4f9657323410e93bd8a51b869bd" => :mojave
    sha256 "bb71f94543dbd9859c33cc5e83cbec86894ca8239dd44339774e2efd0f121268" => :high_sierra
    sha256 "c935e7e27e93f058e1bfe01f199bce5329670e33a4771e06b0fa059144a07f3b" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    assert_equal "abc", shell_output("echo abc,def | #{bin}/rargs -d, echo {1}").chomp
  end
end
