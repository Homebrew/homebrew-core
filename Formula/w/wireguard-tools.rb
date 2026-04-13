class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.com/"
  url "https://git.zx2c4.com/wireguard-tools/snapshot/wireguard-tools-1.0.20260223.tar.xz"
  sha256 "af459827b80bfd31b83b08077f4b5843acb7d18ad9a33a2ef532d3090f291fbf"
  license "GPL-2.0-only"
  head "https://git.zx2c4.com/wireguard-tools.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0dacbfadaa9a5ed82a409138304c28b34cd13509f10ae25b788d1e72f7250281"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00e71a7b3c0c144730bfcdd4e87001fefd9960ce6a9f842bc85794f4138e62d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8103231bca48f4d0db2257a2429f1f3ec18203cc654c48b24736552b3623128"
    sha256 cellar: :any_skip_relocation, sonoma:        "82e2046eb5642fd202ed22a2012cc1ef2c62b0c95499865bb040801ee37f525a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc1772493a5cf8e05ef603563d6fee4bad183deacf21a0db46e9f7e3fe716d0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0af7756dee0ec6ea3053e5b055259b66b45a6a67a80862a8d280028be5c6aa54"
  end

  depends_on "bash"
  depends_on "wireguard-go"

  def install
    if HOMEBREW_PREFIX.to_s != HOMEBREW_DEFAULT_PREFIX
      inreplace ["src/completion/wg-quick.bash-completion", "src/wg-quick/darwin.bash"],
                " /usr/local/etc/wireguard", "\\0 #{etc}/wireguard"
    end

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
