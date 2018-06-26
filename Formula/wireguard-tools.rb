class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.com/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20180625.tar.xz"
  sha256 "d9bedeb22b1f83d48581608a6521fea1d429fbeb8809419d08703ef2ec570020"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "e8c0c04d5c698776e6ac54192ff96da8b311dd17393666b60a2698e07978a9f9" => :high_sierra
    sha256 "3022d5c4ebbcb41b837a1ba7bfb10f4655e0cf4194ab724eb1805aac95e78650" => :sierra
    sha256 "493ebd04e0fdd2c9903542cd046382aba3ee5790f9b4b66634b5249d2fe8ede1" => :el_capitan
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
