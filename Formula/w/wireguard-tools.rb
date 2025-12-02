class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.com/"
  url "https://git.zx2c4.com/wireguard-tools/snapshot/wireguard-tools-1.0.20250521.tar.xz"
  sha256 "b6f2628b85b1b23cc06517ec9c74f82d52c4cdbd020f3dd2f00c972a1782950e"
  license "GPL-2.0-only"
  head "https://git.zx2c4.com/wireguard-tools.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4e3d904340a19633b44d7bf599d7c9080bc2a529a91538ad39125c2d5559ee0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00b25ef39b29bdf6cbe554ca3bab3b4945f0a70f857c698e6cc3a8434a8dc820"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d351a25ffcbfca3d2ad403515f98a8deee82e97b0e60825c425e6dda9854b9f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e638f445c242aede06a5384dc14d9aa78905068564938e79a62d5684df991ded"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c929b929c9ad42228c7c63c091f96e2746150614c36c80003084831b836c996"
    sha256 cellar: :any_skip_relocation, ventura:       "8a326265f11c815949dcfd4405dd0521be943b65177f48d9e0ff59edd52ada6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8acd137b889d5ff4a545cc4b1d5a8aec5f4fad7335ef5c399cf2cf9cbb9d852d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3fedbb5c19ec7126a3bc9e47c3f73e39fc790c38cda09d65dd4aca8d7632aea"
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
