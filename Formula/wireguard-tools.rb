class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.io/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20171111.tar.xz"
  sha256 "d9347786a9406ac276d86321ca64aadb1f0639cb0582c6e0519c634cf6e81157"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "19ca45f64a706e64d8d91d74079ee7f6667cd9dc83b5e71448036da776266887" => :high_sierra
    sha256 "3109f093e5462ac59f70841aae13e4bccf53297a981e8ffb039377e8a2675e98" => :sierra
    sha256 "cd58a0c4594ed3221ffcee00b74aeaf09b8b9f2b2e329578ca194b6d2d290750" => :el_capitan
  end

  def install
    system "make", "BASHCOMPDIR=#{bash_completion}", "WITH_BASHCOMPLETION=yes", "WITH_WGQUICK=no", "WITH_SYSTEMDUNITS=no", "PREFIX=#{prefix}", "-C", "src/tools", "install"
  end

  test do
    system "#{bin}/wg", "help"
  end
end
