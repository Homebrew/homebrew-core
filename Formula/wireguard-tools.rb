class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.io/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20171005.tar.xz"
  sha256 "832a3b7cbb510f6986fd0c3a6b2d86bc75fc9f23b6754d8f46bc58ea8e02d608"
  head "https://git.zx2c4.com/WireGuard", :using => :git

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
