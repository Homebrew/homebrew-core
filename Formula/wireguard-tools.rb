class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.io/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20170115.tar.xz"
  sha256 "7e5f9f4699a2d4ace90d0df5d81bf0f67205ee08c45b95e0acc379bedef5ffe8"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "204ae202dfad21a06d1fcdc9dad505f06dc6113b790ca091bc0b86a46963c768" => :sierra
    sha256 "d2edc2cfd4b5ea60510c285f413a142898890e6eb012b60a3087509902d6fd6d" => :el_capitan
    sha256 "17b3ee77cb8f32e371a68bf64e85a7208dd2e9a8fad0d47c9f4c94b2cbf0ef45" => :yosemite
  end

  def install
    system "make", "BASHCOMPDIR=#{bash_completion}", "WITH_BASHCOMPLETION=yes", "WITH_WGQUICK=no", "WITH_SYSTEMDUNITS=no", "PREFIX=#{prefix}", "-C", "src/tools", "install"
  end

  test do
    system "#{bin}/wg", "help"
  end
end
