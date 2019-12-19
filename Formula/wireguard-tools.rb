class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.com/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20191219.tar.xz"
  sha256 "5aba6f0c38e97faa0b155623ba594bb0e4bd5e29deacd8d5ed8bda8d8283b0e7"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "6dbb639977b26c2309fc61f86d4e360692a73e06d5895dec1e781ee840eedc2a" => :catalina
    sha256 "b075ec8be947ec46572bd932baa6821c4477f901f0a877db2516556724de846a" => :mojave
    sha256 "d12f513220eceaf0eb279d89ff551d0487d38d5111198addd6627558f894a7fd" => :high_sierra
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
