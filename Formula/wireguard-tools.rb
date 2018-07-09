class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.com/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20180708.tar.xz"
  sha256 "5e38d554f7d1e3a64e3a5319ca1a3b790c84ed89c896586c490a93ac1f953a91"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "bdddb6361bf1e20d930cd51486f5e003a709558fa86a620c66a48772c2ac2eb4" => :high_sierra
    sha256 "26c4e0bf462e5d9e2bac4e4c4697b32790da711e3a59cab638de654e707273d4" => :sierra
    sha256 "fb1b203341221a1c3170e978a1eb4a20298dcf8889293d0f814d03264245ee9a" => :el_capitan
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
