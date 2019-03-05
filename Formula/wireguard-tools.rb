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
    sha256 "559af910ded2bfc2ae413fcfcedb76c8b339f020389746de2e363db3fe393e70" => :mojave
    sha256 "771617588cfdb8235408c9deca72d1a9829e78accfca0730d3ca91d86888b185" => :high_sierra
    sha256 "f348bd02935faba39b92acafa31f7141e850a26e54545e05f185eb3658727064" => :sierra
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
