class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.com/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20180918.tar.xz"
  sha256 "c0d931bdfce139a3678592ada463042c24f12dd01ba75badd3eeb0aee2211302"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "139d5f79eddd4d3b6bb1991052d02de9185ef304795b1f191b7ec55cd9a67444" => :mojave
    sha256 "bf5dd37d766022bbfde48bdc595f30caefe0fcbdd8f5ef52d21d4be8d2eaf734" => :high_sierra
    sha256 "92f303642cb2a7f5c1f24b8f96102059076a9ab785b14ef156e4d4424eba98ac" => :sierra
    sha256 "9eb97cdb98b35227b3b7ee117ad6314a8e51b848b7b48784f538c52ff806f318" => :el_capitan
  end

  depends_on "bash"
  depends_on "wireguard-go"

  def install
    system "make", "BASHCOMPDIR=#{bash_completion}", "WITH_BASHCOMPLETION=yes", "WITH_WGQUICK=yes",
                   "WITH_SYSTEMDUNITS=no", "PREFIX=#{prefix}", "SYSCONFDIR=#{prefix}/etc",
                   "-C", "src/tools", "install"
  end

  test do
    system "#{bin}/wg", "help"
  end
end
