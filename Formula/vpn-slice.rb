class VpnSlice < Formula
  include Language::Python::Virtualenv

  desc "Vpnc-script replacement for easy and secure split-tunnel VPN setup"
  homepage "https://github.com/dlenski/vpn-slice"
  url "https://files.pythonhosted.org/packages/bc/79/49fc8347a51f70f4c5501f93809f4dc757729def77749cf16af6643074de/vpn-slice-0.16.tar.gz"
  sha256 "6d5c8d972126775181397dcc65332ec60c5b35fe1647b1022ace863589c59a12"
  license "GPL-3.0-or-later"
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

  depends_on "rust" => :build # for cryptography, can remove if dnspython has new release
  depends_on "python@3.10"

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/13/27/5277de856f605f3429d752a39af3588e29d10181a3aa2e2ee471d817485a/dnspython-2.1.0.zip"
    sha256 "e4a87f0b573201a0f3727fa18a516b055fd1107e0e5477cded4a2de497df1dd4"
  end

  resource "setproctitle" do
    url "https://files.pythonhosted.org/packages/a1/7f/a1d4f4c7b66f0fc02f35dc5c85f45a8b4e4a7988357a29e61c14e725ef86/setproctitle-1.2.2.tar.gz"
    sha256 "7dfb472c8852403d34007e01d6e3c68c57eb66433fb8a5c77b13b89a160d97df"
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
