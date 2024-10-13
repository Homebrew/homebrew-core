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
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b3cc085b5898b8e1b5a12ca32495d641af5cbe2085d64348d669a3277c0edf7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "afec9bdf1a24e98a53e4568fb82cce22ca05ac4607f48a84e67fb9e5ed6a9df4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "00c5b2ed459e7beae63c31d85c5be506b43dc2936439c5139bb92482a5df9b37"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25c8ed67136dcaa8d5292aae40793fd68fe6b803d57fc698a9bc7712bfc1c37f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b73274d92eb5cc895635e2f8baf8f3483dc373e6b6591cd101e2a3bc6ddbae8e"
    sha256 cellar: :any_skip_relocation, sonoma:         "369edbf097e3ac528853e5c696502fc41cb1fce55f4cb654ad5611ea4511edd7"
    sha256 cellar: :any_skip_relocation, ventura:        "ccfe3d35f1cdcb6df435e96fed4cff835274a9a34530c270e71660b65c667ff7"
    sha256 cellar: :any_skip_relocation, monterey:       "61ae65bc95ae1ff7497a7d3f6128054f21fc0daafc089553c3f44a8f7b5b34b0"
    sha256 cellar: :any_skip_relocation, big_sur:        "7998a72195a995ee53e1360a42532bcb6fa42fda1002f16674c695ef5cea101e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b742a6fbc6894b5da2865387e48a7481d894ba90bc37eb5fd38081b2f3af1817"
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
