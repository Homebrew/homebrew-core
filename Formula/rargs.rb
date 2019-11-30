class Rargs < Formula
  desc "Util like xargs + awk with pattern matching support"
  homepage "https://github.com/lotabout/rargs"
  url "https://github.com/lotabout/rargs/archive/v0.2.3.tar.gz"
  sha256 "b33205cab0d410cd7f25e3bcb4efbfec48de76a8ad9c01ee4c286e407552f982"

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
