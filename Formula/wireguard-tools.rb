class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.io/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20171011.tar.xz"
  sha256 "e2e44ff658743507bca0f6b443c2f85aacc48d507ba2dcd4812717145df10b96"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "bd5b3a2e68acd34d19181dbe31f20540ace69d218acec84a94e2dc7b5fbc681f" => :high_sierra
    sha256 "f208df84725eb76d128fadd75b32197353ef5908df4ebe4e0cef735fb1d5d26a" => :sierra
    sha256 "19e03d07b2a5919e4091fca8fd6b4a9aedcf96ea3bf1ce27a121a7c4be2ae068" => :el_capitan
  end

  def install
    system "make", "BASHCOMPDIR=#{bash_completion}", "WITH_BASHCOMPLETION=yes", "WITH_WGQUICK=no", "WITH_SYSTEMDUNITS=no", "PREFIX=#{prefix}", "-C", "src/tools", "install"
  end

  test do
    system "#{bin}/wg", "help"
  end
end
