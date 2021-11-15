class VpnSlice < Formula
  include Language::Python::Virtualenv

  desc "Vpnc-script replacement for easy and secure split-tunnel VPN setup"
  homepage "https://github.com/dlenski/vpn-slice"
  url "https://files.pythonhosted.org/packages/22/a2/55d1f41fdc1708c0a005f5fc678b85acaa3ed5ba470a3a0410898b3a61ff/vpn-slice-0.15.tar.gz"
  sha256 "7d5133aecbed9d5696d59dcb799c3d8d30a89a08f6d36fac335f6b8357786353"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/dlenski/vpn-slice.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7e8122a3a4c573ce3f56a4ea590d8dd624e3d9a77a6ef5c6cc7920264a8c470"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d573308656014686896eb8f1089b34c80681dcd9f9f236830cc4047fc7b2a95"
    sha256 cellar: :any_skip_relocation, monterey:       "fd8425b424c9a0ab4f20d520a5161ea6fd4df98dd2abae8167fce85a037f8650"
    sha256 cellar: :any_skip_relocation, big_sur:        "1c88c94f36629761206f33c6c15fedf999abb119e7cec586c01f1d2fe188ae70"
    sha256 cellar: :any_skip_relocation, catalina:       "d163cd9ca3fe156de8cdc2b77a36e357cdff7317a145115157b545f0703520c4"
    sha256 cellar: :any_skip_relocation, mojave:         "4d16aa1912e1c56a359242288d82c5bf0246c7e9cb0d507d1c267b35f176eee4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c1e691a28af9d74ef1453b1b4b2e782cd5c8271ea1a991694daf3fab7c4dc3a"
  end

  depends_on "python@3.10"

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/67/d0/639a9b5273103a18c5c68a7a9fc02b01cffa3403e72d553acec444f85d5b/dnspython-2.0.0.zip"
    sha256 "044af09374469c3a39eeea1a146e8cac27daec951f1f1f157b1962fc7cb9d1b7"
  end

  resource "setproctitle" do
    url "https://files.pythonhosted.org/packages/5a/0d/dc0d2234aacba6cf1a729964383e3452c52096dc695581248b548786f2b3/setproctitle-1.1.10.tar.gz"
    sha256 "6283b7a58477dd8478fbb9e76defb37968ee4ba47b05ec1c053cb39638bd7398"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # vpn-slice needs root/sudo credentials
    output = `#{bin}/vpn-slice 192.168.0.0/24 2>&1`
    assert_match "Cannot read\/write \/etc\/hosts", output
    assert_equal 1, $CHILD_STATUS.exitstatus
  end
end
