class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.com/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20180304.tar.xz"
  sha256 "efb1652f0da67fb2731040439b6abb820a5e2f1bc177aa15c5dce68ea3327787"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "b6fabc84616764f546b4afdc84eee42098f4b3e1e65d29cef33d9b802abaa159" => :high_sierra
    sha256 "4805b0809f67ed9bcc6e1520a605f08e4e69373ab8bf1aec6fdb55411eefaacf" => :sierra
    sha256 "2835a5207caa080b46e4adff74350f8e516b551b290ab0c989997941d5025961" => :el_capitan
  end

  def install
    system "make", "BASHCOMPDIR=#{bash_completion}", "WITH_BASHCOMPLETION=yes", "WITH_WGQUICK=no", "WITH_SYSTEMDUNITS=no", "PREFIX=#{prefix}", "-C", "src/tools", "install"
  end

  test do
    system "#{bin}/wg", "help"
  end
end
