class Tun2proxy < Formula
  desc "Tunnel (TUN) interface for SOCKS and HTTP proxies"
  homepage "https://github.com/tun2proxy/tun2proxy"
  url "https://github.com/tun2proxy/tun2proxy/archive/refs/tags/v0.7.15.tar.gz"
  sha256 "b59957261fb68b5d5ddf5e4f91bcace6ebcec3f04226ef5c958c03ed625316d1"
  license "MIT"
  head "https://github.com/tun2proxy/tun2proxy.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a77d0838e901435417b404ed1ba0d7052ff07f72231b159d54fdfeb8d08c11e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39d7c1d768b59fd26bda77d8315542a43bc0fac169ebb3af0b5457905d41190c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de489762cdf4ab0874ac863c59acf15e53e4ef006998f3d3a78c3e1c87b5595e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2c38db4d5a03385e7893ae93e64cad0dfc02fada00cede6fb47d8dc532aec2d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "99fadf6ba132f188777230746f2f1cbb755fab5f096126024756fc78bf09b735"
    sha256 cellar: :any_skip_relocation, ventura:       "56046aa2b3f15420acdbfe7d5fb132647a69c38b52e40f7f20d98530af62acdb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be1a22a8b473283a5037bb47752768a6758fa160e3238d1553c064192b7eaf07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8be5dec5957574946097951b4ee3e97e460c0d62c0ba4b62a1ae9a93ab795ef7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tun2proxy-bin --version")

    expected = if OS.mac?
      "Operation not permitted (os error 1)"
    else
      "No such file or directory (os error 2)"
    end

    assert_match expected, shell_output("#{bin}/tun2proxy-bin --proxy socks5://127.0.0.1:1080 --tun utun4 2>&1", 1)
  end
end
