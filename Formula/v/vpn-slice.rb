class VpnSlice < Formula
  include Language::Python::Virtualenv

  desc "Vpnc-script replacement for easy and secure split-tunnel VPN setup"
  homepage "https://github.com/dlenski/vpn-slice"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/dlenski/vpn-slice.git", branch: "master"

  stable do
    url "https://files.pythonhosted.org/packages/74/fd/6c9472e8ed83695abace098d83ba0df4ea48e29e7b2f6c77ced73b9f7dce/vpn-slice-0.16.1.tar.gz"
    sha256 "28d02dd1b41210b270470350f28967320b3a34321d57cc9736f53d6121e9ceaa"

    # Backport commit to drop setuptools dep
    patch do
      url "https://github.com/dlenski/vpn-slice/commit/4e26adbfd14de2be5e77933e96d353ea7d200107.patch?full_index=1"
      sha256 "e80b63d2da61f47011d924fbcc48de9a7461c76a6cc977ee08fce99995bb155b"
      type :backport
      resolves "https://github.com/dlenski/vpn-slice/pull/149"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4940f0aa2942c4528d2412daf1044b4efdc62bfe238bf0433a43eb1325d26081"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "14ab313adbf2086856f2012c43e4d2d2ec24e76b2bd0f851fb85579f1aa5a9d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "54e93c64876a671be0d2be9325b660ecc65c7a75433cd065ac32147784f2e95e"
    sha256 cellar: :any,                 arm64_linux:       "7f9213fb3ab5f6ba1b0144b915b866b9eec45d59758a6e8ea871177eca697f7b"
    sha256 cellar: :any,                 x86_64_linux:      "df52ad2c6a38d6241038286051d1cfee4d74d477f942a90a1a531521f1b7c106"
  end

  depends_on "rust" => :build # dnspython > uv_build
  depends_on "python@3.15"

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/76/49/900383b471c645a3c397f47b3211d1fcecb3a540c98f683494cdf86b33de/dnspython-2.9.2.tar.gz"
    sha256 "8d4d39a513e649d634004ce4d39ade2352efcea472a0247535a5c2d18a9d7ba9"
  end

  resource "setproctitle" do
    url "https://files.pythonhosted.org/packages/49/b0/6b8a516c5a9e9630bd5293db78314ac012f690305fe93beadea388626efb/setproctitle-1.3.8.tar.gz"
    sha256 "cafe209d064a6efb88cb45a03e97981ff8832802b2b5d009dde0197a3b7b41c8"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # vpn-slice needs root/sudo credentials
    output = shell_output("#{bin}/vpn-slice 192.168.0.0/24 2>&1", 1)
    assert_match "Cannot read/write /etc/hosts", output
  end
end
