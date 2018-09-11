class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.com/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20180910.tar.xz"
  sha256 "43481ac82d4889491e1ae761d4ef10688410975cc861db5d2ac1845ac62eae39"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "49cd583a448b205559cab5cfbd6bdf95607d20bb387f12a6f167257987593172" => :mojave
    sha256 "e240f7a5d8413f345cde924acbfddb7b12add2397c45933be00fdc6df070a8c3" => :high_sierra
    sha256 "82e7b390f5e93eecf6ffe073f815447a896796ff10bcf44096b5a5bcdd992799" => :sierra
    sha256 "bf7118378e59bfe73574cd824c137907c47973f995b60b71388ff55e4fc03e69" => :el_capitan
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
