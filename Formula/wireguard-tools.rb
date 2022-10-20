class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.com/"
  url "https://git.zx2c4.com/wireguard-tools/snapshot/wireguard-tools-1.0.20210914.tar.xz"
  sha256 "97ff31489217bb265b7ae850d3d0f335ab07d2652ba1feec88b734bc96bd05ac"
  license "GPL-2.0-only"
  head "https://git.zx2c4.com/wireguard-tools.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dab3c446484b6fce766584a472894f32e476d0599df1c65b8115ca0c8abce262"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "92e86c34ca2a747177fdc78ed6dfe44970f4943a6d929ca1c3c04698c05b5631"
    sha256 cellar: :any_skip_relocation, monterey:       "ef2ec79723d6ad586e54148c0fc23775528fcea79ba3ef052e7000c1029e3d86"
    sha256 cellar: :any_skip_relocation, big_sur:        "fddbe8d3d5d10d9f4f5cb34fb1235367a93f127decda021842d58f92d53fc686"
    sha256 cellar: :any_skip_relocation, catalina:       "f24424c4b4c8aeaccc23f61c8b01f7296e8622d4be0436ac26b9de664a99d6bd"
    sha256 cellar: :any_skip_relocation, mojave:         "79939305daed2313e0be3aa2e9420eb0c576e25c557d22a36b9dae6591ba8710"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6870c3e5fad02dbdfd95280a09b089b667351547ee0e47f80c9285e9078b8bc"
  end

  depends_on "bash"
  depends_on "wireguard-go"

  def install
    system "make", "BASHCOMPDIR=#{bash_completion}", "WITH_BASHCOMPLETION=yes", "WITH_WGQUICK=yes",
                   "WITH_SYSTEMDUNITS=no", "PREFIX=#{prefix}", "SYSCONFDIR=#{prefix}/etc",
                   "-C", "src", "install"
  end

  test do
    system "#{bin}/wg", "help"
  end
end
