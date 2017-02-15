class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.io/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20170213.tar.xz"
  sha256 "256a7d41cf228f2a88e1b03b3911746dc827fe7be5b982c60080e7f81998cc6d"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "4c20127d31741567b3ba4dc6114189a8f1c9bd1fed3fef0913a3ae213688ba7b" => :sierra
    sha256 "477ad383bcfd9417df06d84903f84875ade9ea780769f3634a75214893dad5cc" => :el_capitan
    sha256 "81908e68bed128b7e402a5439705e06a912ceee4cfe84268fe2959eb178769ae" => :yosemite
  end

  def install
    system "make", "BASHCOMPDIR=#{bash_completion}", "WITH_BASHCOMPLETION=yes", "WITH_WGQUICK=no", "WITH_SYSTEMDUNITS=no", "PREFIX=#{prefix}", "-C", "src/tools", "install"
  end

  test do
    system "#{bin}/wg", "help"
  end
end
