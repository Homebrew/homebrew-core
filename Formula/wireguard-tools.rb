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
    sha256 "76d86e67852668ee3afe7df51f1b5a9a71454f6fd7c404397438085245460869" => :high_sierra
    sha256 "a1fa706fb358a53f9c369cafaa7fa0a752b8b013bc9807e96c954b2408747a8f" => :sierra
    sha256 "83529c7404a0f9cbace39a0b9a31c7bcdba513e7154660fc1f808ed0bb0956af" => :el_capitan
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
