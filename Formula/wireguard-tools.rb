class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.com/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20191127.tar.xz"
  sha256 "7d4e80a6f84564d4826dd05da2b59e8d17645072c0345d0fc0d197be176c3d06"
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
