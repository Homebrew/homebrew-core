class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.io/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20170223.tar.xz"
  sha256 "6d2c8cd29c4f9fb404546a4749ec050739a26b4a49b5864f1dec531377c3c50d"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "8de1c9caf3d39edeb291d979d69ebe13fe64bbf74aa3fa902c7fcf81185f8e89" => :sierra
    sha256 "9c2a80ddb9c6b5ef9200ad93cae9e61dbb9247b0233b772fa62ece46faeaea74" => :el_capitan
    sha256 "d2d9ce539f32e6baab66c2030106142c4e412e75911cc3551096d5f9d0b62e9d" => :yosemite
  end

  def install
    system "make", "BASHCOMPDIR=#{bash_completion}", "WITH_BASHCOMPLETION=yes", "WITH_WGQUICK=no", "WITH_SYSTEMDUNITS=no", "PREFIX=#{prefix}", "-C", "src/tools", "install"
  end

  test do
    system "#{bin}/wg", "help"
  end
end
