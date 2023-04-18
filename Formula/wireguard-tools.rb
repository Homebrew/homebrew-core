class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.com/"
  url "https://git.zx2c4.com/wireguard-tools/snapshot/wireguard-tools-1.0.20210914.tar.xz"
  sha256 "97ff31489217bb265b7ae850d3d0f335ab07d2652ba1feec88b734bc96bd05ac"
  license "GPL-2.0-only"
  revision 1
  head "https://git.zx2c4.com/wireguard-tools.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "40c449672b0ea3d2282ecf089efc8d538c2a95780501c318daf78505395ca5a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0c9a14a47329f10d703a6610578d4d17c573e6e0129e79dfe4b18796f325ec8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "34b715070b443dc1e42bad4d534d3e6193aed78aae7138d8a6bbc5432412138f"
    sha256 cellar: :any_skip_relocation, ventura:        "4b7c8c2272629b7d089a346a916533123c363f9d25353699c01977deda79b898"
    sha256 cellar: :any_skip_relocation, monterey:       "a0871ff7ca2a9b46b2b1f2d78b2413673765ce32a8e3fdb79bf657cf4fb8b5af"
    sha256 cellar: :any_skip_relocation, big_sur:        "495fd01f14466efe9afe8f6f939a3ae06a86378089a101c85b544e210a96355c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c791ab19ad38560d5f2748a870696a31b8b1aba3249f6fde51e0b26b02d04fb8"
  end

  depends_on "bash"
  depends_on "wireguard-go"

  def install
    inreplace ["src/completion/wg-quick.bash-completion", "src/wg-quick/darwin.bash"],
              " /usr/local/etc/wireguard", " #{etc}/wireguard"

    system "make", "-C", "src",
                         "BASHCOMPDIR=#{bash_completion}",
                         "WITH_BASHCOMPLETION=yes",
                         "WITH_WGQUICK=yes",
                         "WITH_SYSTEMDUNITS=no",
                         "PREFIX=#{prefix}",
                         "SYSCONFDIR=#{etc}",
                         "install"
  end

  test do
    system bin/"wg", "help"
  end
end
