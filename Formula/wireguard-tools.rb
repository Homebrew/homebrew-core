class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.com/"
  url "https://git.zx2c4.com/wireguard-tools/snapshot/wireguard-tools-1.0.20200827.tar.xz"
  sha256 "51bc85e33a5b3cf353786ae64b0f1216d7a871447f058b6137f793eb0f53b7fd"
  license "GPL-2.0"
  head "https://git.zx2c4.com/wireguard-tools.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "007564c0016fce46841d7d28f907fc0c9ffa7480f95c846608a689c7f288600e" => :big_sur
    sha256 "f6ee3e4d2d716d4bd5d3fd704653f33b016ffe6f73dc8734523a0cfbef80487d" => :arm64_big_sur
    sha256 "45e84d6fd3efe601ecb6c959a356169908bd12aa2aaa42122663619c47c02e4e" => :catalina
    sha256 "7c53423bac89aef0a7a521f04707961bf4416925edb3022d0bfc839f345f991b" => :mojave
    sha256 "7041f9c62ee72513ec0eb67ec1b240ce4be95c771aeecb9302fed746c0029dfc" => :high_sierra
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
