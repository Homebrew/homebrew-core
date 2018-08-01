class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.com/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20180731.tar.xz"
  sha256 "09212974f2a92b304147151f2ca5cb7230e09e969d9584bdf8338bc82e614b8a"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "0390e446dcbf97fc50fe4eb4068109197cc2a4740d55b1e04496ba11f5c4abef" => :high_sierra
    sha256 "f39c9725dfc1ae2d7866bca43a869007d33c9ded8e79dee5029fda5e64d43d72" => :sierra
    sha256 "6a0ca97059e2e4e45565f485f44ac2ec87265eccce73dd470030281c53c7bafa" => :el_capitan
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
