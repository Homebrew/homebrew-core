class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.com/"
  url "https://git.zx2c4.com/wireguard-tools/snapshot/wireguard-tools-1.0.20200121.tar.xz"
  sha256 "15bfdbdbecbd3870ced9a7e68286c871bfcb2071d165f113808081f2e428faa3"
  head "https://git.zx2c4.com/wireguard-tools", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "a69292138a796558061f6cfd3442532656d7dd159ce9485a06680121d4c5d126" => :catalina
    sha256 "df561610e2019f71aab38b14c2cb10a207e420caae270e480d6e6f6e43dfee88" => :mojave
    sha256 "841caaad9af8f1825cde416f05bacf34f5d011e1c9c5516022f986d61974f5ec" => :high_sierra
  end

  depends_on "bash"
  depends_on "wireguard-go"

  def install
    system "make", "BASHCOMPDIR=#{bash_completion}", "WITH_BASHCOMPLETION=yes", "WITH_WGQUICK=yes",
                   "WITH_SYSTEMDUNITS=no", "PREFIX=#{prefix}", "SYSCONFDIR=#{prefix}/etc",
                   "-C", "src", "install"
  end

  test do
    system "#{bin}/wg", "help"
  end
end
