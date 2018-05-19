class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.com/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20180519.tar.xz"
  sha256 "8846b3006c3f7e079bb38a4c985ccc2981e259f56c927b4cf47cbc1420e1c462"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "985336435e54b7a4d046a0105fa81ae0fd9766d7d6c6adb21e2e67d6c408a14f" => :high_sierra
    sha256 "ed61e4c78284dbdd23750afe0b0ebf1bfccdc4b8195826b40b5b8547b35a3939" => :sierra
    sha256 "2f671072a26f83d1a6b9191ddc3466c76e0752f456c9369fcbf7f564c5351a94" => :el_capitan
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
