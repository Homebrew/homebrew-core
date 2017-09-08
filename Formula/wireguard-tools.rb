class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.io/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20170907.tar.xz"
  sha256 "a1ee12d60662607e4c5a19f84b5115e56f083e2600053882e161537f12d963fd"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "c62f704503eeb0ffee55971430ed8ae51c32fc7b35dba150d71b3616dc546482" => :sierra
    sha256 "ea59a55403e6ea5b1fef5e8c252977e787660f6fbc51ab48f14addf14a024431" => :el_capitan
    sha256 "3be5b13e5b783628793d4970e393ca99dc3cd50fed5ecf2a49bd0250dbe0cbf9" => :yosemite
  end

  def install
    system "make", "BASHCOMPDIR=#{bash_completion}", "WITH_BASHCOMPLETION=yes", "WITH_WGQUICK=no", "WITH_SYSTEMDUNITS=no", "PREFIX=#{prefix}", "-C", "src/tools", "install"
  end

  test do
    system "#{bin}/wg", "help"
  end
end
