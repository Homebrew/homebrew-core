class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.com/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20180925.tar.xz"
  sha256 "4a0488a07e40ec17e798f3e40a85cedf55f0560b1c3a8fd95806c7d4266cb0e8"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "7fe7977db39f2e23ca06f810df095be1aafe7d9ae8036f63461ec875d32fff17" => :mojave
    sha256 "1ca58502042ab38dc6b6a2bffefcb81057c69c74e25b6126b66853e6eb0236da" => :high_sierra
    sha256 "62578b64982b3496331ea9d9ba518819044e463e624c405c74c586f4b7445bdb" => :sierra
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
