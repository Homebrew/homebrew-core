class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.com/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20190227.tar.xz"
  sha256 "fcdb26fd2692d9e1dee54d14418603c38fbb973a06ce89d08fbe45292ff37f79"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "35051285fb1892d858478fc6a29ea37f979d69c6b08b194b93ea4808b9e019a1" => :mojave
    sha256 "388e11e18dde5f2ee20e9d0a41535238d1d3301007f34093bb79abc5a66ca9aa" => :high_sierra
    sha256 "a4b989fe7b8a47bae53c4a10fe52311b39f1271742b79a043fe964b1464aa9be" => :sierra
  end

  depends_on "bash"
  depends_on "wireguard-go"

  def install
    system "make", "BASHCOMPDIR=#{bash_completion}", "WITH_BASHCOMPLETION=yes", "WITH_WGQUICK=yes",
                   "WITH_SYSTEMDUNITS=no", "PREFIX=#{prefix}", "SYSCONFDIR=#{prefix}/etc",
                   "-C", "src/tools", "install"
  end

  test do
    system "#{bin}/wg", "help"
  end
end
