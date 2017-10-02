class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.io/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  head "https://git.zx2c4.com/WireGuard", :using => :git

  stable do
    url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20171001.tar.xz"
    sha256 "ecff9a184685b7dd2d81576eba5bd96bb59031c9e9b5eeee05d6dc298f30998e"

    # Remove for > 0.0.20171001
    # Fix "error: use of undeclared identifier 'MNL_SOCKET_BUFFER_SIZE'"
    # Upstream commit from 2 Oct 2017 "tools: compile on non-Linux"
    patch do
      url "https://git.zx2c4.com/WireGuard/patch/?id=eb578ac0cbfa0e9b6fd5f8f56ccdc407ca860e96"
      sha256 "2c73ee2bedad3c1ac6803dbaef0867cb4f6cd9ec42c56fa1a1ba9831b9901f33"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "4126072919bbba83864deadbe2c3fab5ae02c7af73b7dc3771db54d98900547a" => :high_sierra
    sha256 "b8293b2fa77eb22bd3c1c452b16c5526ee994814f4dbe1c47ae69162a5283709" => :sierra
    sha256 "7b349e77994b70e10ee48f3da41bfd490708a14b13f44988cd798adb261dedd9" => :el_capitan
  end

  def install
    system "make", "BASHCOMPDIR=#{bash_completion}", "WITH_BASHCOMPLETION=yes", "WITH_WGQUICK=no", "WITH_SYSTEMDUNITS=no", "PREFIX=#{prefix}", "-C", "src/tools", "install"
  end

  test do
    system "#{bin}/wg", "help"
  end
end
