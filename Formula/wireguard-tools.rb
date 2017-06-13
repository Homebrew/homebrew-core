class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.io/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20170613.tar.xz"
  sha256 "88ac77569eeb79c517318d58a0954caa0a4d2a6a1694e74c2a3b1c14438ac941"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "afef1ed3804ec2705d5634e6e6da9bacb5f8248918f7c41f25d2c0c1d983922e" => :sierra
    sha256 "7a9662af5fa1f4d29c97259cdc5ce8be9f1b69ec5919a73838a42f5b570ffb40" => :el_capitan
    sha256 "5cfe6db399c1104a947454a997c910a6c37af7118962696e5f6d2b6a36fbebf8" => :yosemite
  end

  def install
    system "make", "BASHCOMPDIR=#{bash_completion}", "WITH_BASHCOMPLETION=yes", "WITH_WGQUICK=no", "WITH_SYSTEMDUNITS=no", "PREFIX=#{prefix}", "-C", "src/tools", "install"
  end

  test do
    system "#{bin}/wg", "help"
  end
end
