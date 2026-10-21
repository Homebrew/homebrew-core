class Tun2proxy < Formula
  desc "Tunnel (TUN) interface for SOCKS and HTTP proxies"
  homepage "https://github.com/tun2proxy/tun2proxy"
  url "https://github.com/tun2proxy/tun2proxy/archive/refs/tags/v0.8.6.tar.gz"
  sha256 "5c5e905b7bee8431bb7d452bdfea3ce02a1998c0dcaf0c375295ecd9bb097e23"
  license "MIT"
  head "https://github.com/tun2proxy/tun2proxy.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9e4c2a7d8108999d53142a1cf4ec025cdc49e8f4fc19f82a3276ae8e171728b7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3c737594bfc8ce7cf4105d59936b5fd7c224b2601a23fc842d948e0f4b047151"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6daf7c203658d4ffb0abfb780ae758e0ef89212c06f7d6da3ccab30f2cceea38"
    sha256 cellar: :any,                 arm64_linux:       "09fe8f9782208c886ba6c665e7829b41117e0d452c7f3252b0bf964227e7a7b6"
    sha256 cellar: :any,                 x86_64_linux:      "d7062b3900e456d3315ab30a1544b45d25891218db73eebf0fa1567e74c0498e"
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
