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
    sha256 "1c3a27328cbd163193ef758bf36a183dc9f875313a3f6f7e379904a86629c623" => :high_sierra
    sha256 "c4da9e5ca1f95a80e2e1407724aec819ff30b062830b35129c32aae72318c04b" => :sierra
    sha256 "fcbe265b676c3d36b0c56c0f1c4e7d65dce10118e247d183c549685ac7b48dc1" => :el_capitan
  end

  def install
    system "make", "BASHCOMPDIR=#{bash_completion}", "WITH_BASHCOMPLETION=yes", "WITH_WGQUICK=no", "WITH_SYSTEMDUNITS=no", "PREFIX=#{prefix}", "-C", "src/tools", "install"
  end

  test do
    system "#{bin}/wg", "help"
  end
end
