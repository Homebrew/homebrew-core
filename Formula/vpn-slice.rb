class VpnSlice < Formula
  include Language::Python::Virtualenv

  desc "Vpnc-script replacement for easy and secure split-tunnel VPN setup"
  homepage "https://github.com/dlenski/vpn-slice"
  url "https://files.pythonhosted.org/packages/74/fd/6c9472e8ed83695abace098d83ba0df4ea48e29e7b2f6c77ced73b9f7dce/vpn-slice-0.16.1.tar.gz"
  sha256 "28d02dd1b41210b270470350f28967320b3a34321d57cc9736f53d6121e9ceaa"
  license "GPL-3.0-or-later"
  head "https://github.com/dlenski/vpn-slice.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbfa2a3a8b8e9152ca48632a00516150c7394df15c4c4d63d92d3237a65b73ac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "226754aebd7b8bc50e97530258eb5323e6582cafd7c30c6d49d47df3cd516ea1"
    sha256 cellar: :any_skip_relocation, monterey:       "d7d0824434ded8b59f8d94826750a76982149b717514c45c45c937f7c84e3bf0"
    sha256 cellar: :any_skip_relocation, big_sur:        "d16cdb0c574a5b2908eca30715ad395d130d5abaa63d36dc1e81f1c0fc8c3e93"
    sha256 cellar: :any_skip_relocation, catalina:       "3ab5f17a948e66f4f387798ad7a92db39901264f183c621e5b316c73a182420a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef189ff3f708aa43e8574c9b1d6781e099f73acb880a53fdbfb6ead0d1d322d6"
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
