class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.com/"
  url "https://git.zx2c4.com/wireguard-tools/snapshot/wireguard-tools-1.0.20200206.tar.xz"
  sha256 "f5207248c6a3c3e3bfc9ab30b91c1897b00802ed861e1f9faaed873366078c64"
  head "https://git.zx2c4.com/wireguard-tools", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "51d3f3fabd7633f4d75b7c0780c84ecec91924f5547068b4eaac392ce5613eba" => :catalina
    sha256 "45fc19f4acea5f69c953963d7f66b0219e99605eba5ab824f89f65773e9a7326" => :mojave
    sha256 "d13abc967788549b7a7d336041f901c905a0edc116b703f8f817d0c2b8f9db8c" => :high_sierra
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
