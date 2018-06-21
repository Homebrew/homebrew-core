class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.com/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20180620.tar.xz"
  sha256 "b4db98ea751c8e667454f98ea1c15d704a784fe1bc093b03bd64575418a7c242"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "badb757ab64fe6e9401d456e56fe77c81c872b6f0028e0a8877995c70ee1a669" => :high_sierra
    sha256 "5c17882918d28516d4af8727b3599ce238d792ea817e7ab9c444f1d2e231818a" => :sierra
    sha256 "8d136e3ec22bd16d80e5d2031491b2ea198b5b2661f1bd3e20ef5895781d3a2f" => :el_capitan
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
