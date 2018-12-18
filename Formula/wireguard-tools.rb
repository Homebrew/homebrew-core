class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.com/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20181218.tar.xz"
  sha256 "2e9f86acefa49dbfb7fa6f5e10d543f1885a2d5460cd5e102696901107675735"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "5c9ea074d7580408a8845c17a226444415202dfba862ef4f06957f2f6f8084dc" => :mojave
    sha256 "67a8e139153ccf564663df45a89022ef2a31094c004fdf0f86b3a80ed730d159" => :high_sierra
    sha256 "09d0a57161d1ce11c1a5556a2c42b1e6bc68a79e70853d3471701569a8210182" => :sierra
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
