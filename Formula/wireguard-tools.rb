class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.com/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  head "https://git.zx2c4.com/WireGuard", :using => :git

  stable do
    url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20180613.tar.xz"
    sha256 "c120cdedc3967dcb4ad5c1c7eadd2a1b04ef5dbf2fe60cc8e7c0db337bcda7dc"

    # Remove for > 0.0.20180613
    # Upstream commit from 14 Jun 2018 "tools: getentropy requires 10.12"
    patch do
      url "https://git.zx2c4.com/WireGuard/patch/?id=5bb62fe22f45b5b5deef4db23ae47c95e1679d1d"
      sha256 "a057926e50f4981857a9c07905d5c0488588e88b9f0a8f20d236a83a39150901"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "badb757ab64fe6e9401d456e56fe77c81c872b6f0028e0a8877995c70ee1a669" => :high_sierra
    sha256 "5c17882918d28516d4af8727b3599ce238d792ea817e7ab9c444f1d2e231818a" => :sierra
    sha256 "8d136e3ec22bd16d80e5d2031491b2ea198b5b2661f1bd3e20ef5895781d3a2f" => :el_capitan
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
