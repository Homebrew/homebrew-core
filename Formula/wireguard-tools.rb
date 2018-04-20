class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.com/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20180420.tar.xz"
  sha256 "b58cd2acf9e8d3fe9044c06c0056bd74da1f5673a456f011d36eee3f6fb1da16"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "bec39c19923a7c5c34d57fa8ab1c9117ef0cf431dfe2a360162dec29e3e3d0f8" => :high_sierra
    sha256 "ed83648cfaff1e6deb929950c552bfe6e462ba8c527a180d544a02b11895e330" => :sierra
    sha256 "b4d3e071843e1e68e70a34a3e77170cd7e4722c902f9c01007544072c20d94a0" => :el_capitan
  end

  def install
    system "make", "BASHCOMPDIR=#{bash_completion}", "WITH_BASHCOMPLETION=yes", "WITH_WGQUICK=no", "WITH_SYSTEMDUNITS=no", "PREFIX=#{prefix}", "-C", "src/tools", "install"
  end

  test do
    system "#{bin}/wg", "help"
  end
end
