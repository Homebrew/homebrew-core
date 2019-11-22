class Rargs < Formula
  desc "Util like xargs + awk with pattern matching support"
  homepage "https://github.com/lotabout/rargs"
  url "https://github.com/lotabout/rargs/archive/v0.2.2.tar.gz"
  sha256 "ac6cf3a31ff5b55f86487fa3d3266edf8f562cc6b548d6e636daf373534388ad"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "247817d184e94dee19ec60a4455fb706677dac91b0da5ea9f945c00fbd8ef2e0" => :catalina
    sha256 "860dd78cd787ab1552139c71db5ae901851954a1567ecc41449cf26504e6e272" => :mojave
    sha256 "7c420943533b30aa0336ff220611a51efa7eb79657499562ee4a223c079ebc71" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    assert_equal "abc", shell_output("echo abc,def | #{bin}/rargs -d, echo {1}").chomp
  end
end
