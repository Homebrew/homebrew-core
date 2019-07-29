class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.com/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20190702.tar.xz"
  sha256 "1a1311bc71abd47a72c47d918be3bacc486b3de90734661858af75cc990dbaac"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "ef92b9f817cdab70d3f0b209c10371047091032c0d3122ae233c55b0d2d80b71" => :mojave
    sha256 "8b37ba466e40b8ec98c3f78aa45cf30ba4c134c2e498dac770c874cf2a68789c" => :high_sierra
    sha256 "a9eeba2af14e948074df17f0d0878835efe3bdf4dc1555243556333e1de583d0" => :sierra
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
