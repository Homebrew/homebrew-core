class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.com/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20180531.tar.xz"
  sha256 "ff653095cc0e4c491ab6cd095ddf5d1db207f48f947fb92873a73220363f423c"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "33eb0b878fde79c388a52357c0c4d14ddbbea10a3f7c0bc366eba21c449b8a97" => :high_sierra
    sha256 "1dd26b112209b7ae5dd33b4151d57750ce12fb622b6c653a49c3e66b4d420173" => :sierra
    sha256 "54d2200d7120369c8d26ed0af27b16aa6b53b579c7cc8ef943dabc5f29b666e8" => :el_capitan
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
