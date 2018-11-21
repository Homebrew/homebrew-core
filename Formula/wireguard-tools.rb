class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.com/"
  # Please only update version when the tools have been modified/updated,
  # since the Linux module aspect isn't of utility for us.
  url "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20181119.tar.xz"
  sha256 "7d47f7996dd291069de4efb3097c42f769f60dc3ac6f850a4d5705f321e4406b"
  head "https://git.zx2c4.com/WireGuard", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "57c36c275640b7b102b0f8689c585dc155bebe1d1f70792a3a6866819a933a2c" => :mojave
    sha256 "fbbea8ef3260cbea2eef68f233a2979545a0912d2eeb54888318c18fd2f6bb1d" => :high_sierra
    sha256 "dbc8eab133aea0ea8ffff28f8becab074be85ec38fb36f48f6d3ad855adf37de" => :sierra
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
