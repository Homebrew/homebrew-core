class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.com/"
  url "https://git.zx2c4.com/wireguard-tools/snapshot/wireguard-tools-1.0.20200319.tar.xz"
  sha256 "757ed31d4d48d5fd7853bfd9bfa6a3a1b53c24a94fe617439948784a2c0ed987"
  head "https://git.zx2c4.com/wireguard-tools", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "565223fb10e6be2b166784cb0155d5ace2a31652f944f662590dec2f48de7c15" => :catalina
    sha256 "769af42e54ba3ada0f56aab998ccf9376fa0132483c5d2b6dc8cbb30db578bfe" => :mojave
    sha256 "c24816c97f1e10eefd06df7910fd916d3a6c2ce12a9474e613346903ae522d27" => :high_sierra
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
