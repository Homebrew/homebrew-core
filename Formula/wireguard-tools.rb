class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.com/"
  url "https://git.zx2c4.com/wireguard-tools/snapshot/wireguard-tools-1.0.20200827.tar.xz"
  sha256 "51bc85e33a5b3cf353786ae64b0f1216d7a871447f058b6137f793eb0f53b7fd"
  license "GPL-2.0"
  head "https://git.zx2c4.com/wireguard-tools", using: :git

  livecheck do
    url "https://github.com/WireGuard/wireguard-tools"
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "ebfaa9ce7fb682918d20ed728ab58aef7f18ca6e8109acf8643c7553a4c8f80e" => :catalina
    sha256 "79078300c5573d894011800bccd4b0fc315f3f5ae6b1c76de508ce7d34a8bad8" => :mojave
    sha256 "980d6cf99451f09be4b54abeb873c8f4958e7127f357d08f457c010a5f8b6089" => :high_sierra
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
