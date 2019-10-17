class Rargs < Formula
  desc "Util like xargs + awk with pattern matching support"
  homepage "https://github.com/lotabout/rargs"
  url "https://github.com/lotabout/rargs/archive/v0.2.2.tar.gz"
  sha256 "ac6cf3a31ff5b55f86487fa3d3266edf8f562cc6b548d6e636daf373534388ad"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "61300f0d8d770b58077ef97efdf5f50bf2f5df244cfc1dcd7c75d940948bdb0f" => :catalina
    sha256 "eb92709c9127872b57c807c5a110329bea94cc43a6c6a030ff6fee6fe8240100" => :mojave
    sha256 "7d5d38da14e10453dfac30d784f7bf4f7c75e7f188c7b3df556ebd5f2df8e76c" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    assert_equal "abc", shell_output("echo abc,def | #{bin}/rargs -d, echo {1}").chomp
  end
end
