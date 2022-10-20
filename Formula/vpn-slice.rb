class VpnSlice < Formula
  include Language::Python::Virtualenv

  desc "Vpnc-script replacement for easy and secure split-tunnel VPN setup"
  homepage "https://github.com/dlenski/vpn-slice"
  url "https://files.pythonhosted.org/packages/74/fd/6c9472e8ed83695abace098d83ba0df4ea48e29e7b2f6c77ced73b9f7dce/vpn-slice-0.16.1.tar.gz"
  sha256 "28d02dd1b41210b270470350f28967320b3a34321d57cc9736f53d6121e9ceaa"
  license "GPL-3.0-or-later"
  head "https://github.com/dlenski/vpn-slice.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aae94aed3962341c977427f891a4ccddd31c0b1407eff0c1c12a6606d14e2f19"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7de4b4741ae6d747906f85e981e0162e2cc5f46592460d9ecd3c79175a22f04c"
    sha256 cellar: :any_skip_relocation, monterey:       "163bb051600b95199aa4678a820c76e8d1051f2095417a0bba81514b771cb99f"
    sha256 cellar: :any_skip_relocation, big_sur:        "936ca7b20b1f2bcd20459851659634af28afabfcaf5cfa372f90b72f18306db7"
    sha256 cellar: :any_skip_relocation, catalina:       "69eb21d92d73b5f03a9f01daefb72875a4ed73d96bce2f571b6a515bb46771f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd3cc586853e2afcfc1618dd333520882f9c9248c7d7ae8c7cd7ce99068ab0ca"
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
