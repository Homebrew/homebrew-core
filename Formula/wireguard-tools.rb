class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.com/"
  url "https://git.zx2c4.com/wireguard-tools/snapshot/wireguard-tools-1.0.20200513.tar.xz"
  sha256 "e73409a9fb8c90506db241d1e1a4e7372a60dbfa400e37f4ab2fd70a92ba495f"
  license "GPL-2.0"
  head "https://git.zx2c4.com/wireguard-tools", using: :git

  bottle do
    cellar :any_skip_relocation
    sha256 "d8f18c2d3f4e08b616a8621367adfc30881d5bf5a5de19daca1b7828a59c5e96" => :catalina
    sha256 "b00ca10dd4dc519a8dae57cff6df2cb224f52018334ed8464810329c28677520" => :mojave
    sha256 "71ebb1ada0ede665499754dc5b2af1dc524714c0eb35e631e3dd7aca18a71d02" => :high_sierra
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
