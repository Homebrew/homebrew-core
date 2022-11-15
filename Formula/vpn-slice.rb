class VpnSlice < Formula
  include Language::Python::Virtualenv

  desc "Vpnc-script replacement for easy and secure split-tunnel VPN setup"
  homepage "https://github.com/dlenski/vpn-slice"
  url "https://files.pythonhosted.org/packages/74/fd/6c9472e8ed83695abace098d83ba0df4ea48e29e7b2f6c77ced73b9f7dce/vpn-slice-0.16.1.tar.gz"
  sha256 "28d02dd1b41210b270470350f28967320b3a34321d57cc9736f53d6121e9ceaa"
  license "GPL-3.0-or-later"
  head "https://github.com/dlenski/vpn-slice.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97627aab099f580c1dd8fb05b116218cdcc2128028ff1d35a1aed3288467d412"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aae94aed3962341c977427f891a4ccddd31c0b1407eff0c1c12a6606d14e2f19"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7de4b4741ae6d747906f85e981e0162e2cc5f46592460d9ecd3c79175a22f04c"
    sha256 cellar: :any_skip_relocation, monterey:       "163bb051600b95199aa4678a820c76e8d1051f2095417a0bba81514b771cb99f"
    sha256 cellar: :any_skip_relocation, big_sur:        "936ca7b20b1f2bcd20459851659634af28afabfcaf5cfa372f90b72f18306db7"
    sha256 cellar: :any_skip_relocation, catalina:       "69eb21d92d73b5f03a9f01daefb72875a4ed73d96bce2f571b6a515bb46771f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd3cc586853e2afcfc1618dd333520882f9c9248c7d7ae8c7cd7ce99068ab0ca"
  end

  depends_on "python@3.11"

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/99/fb/e7cd35bba24295ad41abfdff30f6b4c271fd6ac70d20132fa503c3e768e0/dnspython-2.2.1.tar.gz"
    sha256 "0f7569a4a6ff151958b64304071d370daa3243d15941a7beedf0c9fe5105603e"
  end

  resource "setproctitle" do
    url "https://files.pythonhosted.org/packages/b5/47/ac709629ddb9779fee29b7d10ae9580f60a4b37e49bce72360ddf9a79cdc/setproctitle-1.3.2.tar.gz"
    sha256 "b9fb97907c830d260fa0658ed58afd48a86b2b88aac521135c352ff7fd3477fd"
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
