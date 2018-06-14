class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.com/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20180613.tar.xz"
  sha256 "c120cdedc3967dcb4ad5c1c7eadd2a1b04ef5dbf2fe60cc8e7c0db337bcda7dc"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "6833a823639a97aa3732ea5b599a37efdedcebbf5f4453fbeabac2b1cc206526" => :high_sierra
    sha256 "2ecc83d47c155bfdfb1a317ec9b290e24f08899cafa6eea237628e194cafab7f" => :sierra
    sha256 "1ba90711dbbb560910f8cda58c4a7751a141741d2da843060d17ff1d3f12204c" => :el_capitan
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
