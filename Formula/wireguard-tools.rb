class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.com/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20180513.tar.xz"
  sha256 "28a15c59f6710851587ebca76a335f1aaaa077aad052732e0959f2bae9ba8d5c"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "f397f2f93f09174506893ba7789cf26cd2d79e596ca0b72532c9638092767e02" => :high_sierra
    sha256 "3a862912e8b5435d55ce1f9c74034df841933ee38ede5bb0748bd3bf34208fa5" => :sierra
    sha256 "0ddb45a70820cf221cd363fc16a7159c2699c75a1a4716612b5b4f2307c062a8" => :el_capitan
  end

  def install
    system "make", "BASHCOMPDIR=#{bash_completion}", "WITH_BASHCOMPLETION=yes", "WITH_WGQUICK=no", "WITH_SYSTEMDUNITS=no", "PREFIX=#{prefix}", "-C", "src/tools", "install"
  end

  test do
    system "#{bin}/wg", "help"
  end
end
