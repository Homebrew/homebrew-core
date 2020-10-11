class VpnSlice < Formula
  include Language::Python::Virtualenv

  desc "Vpnc-script replacement for easy and secure split-tunnel VPN setup"
  homepage "https://github.com/dlenski/vpn-slice"
  url "https://files.pythonhosted.org/packages/22/a2/55d1f41fdc1708c0a005f5fc678b85acaa3ed5ba470a3a0410898b3a61ff/vpn-slice-0.15.tar.gz"
  sha256 "7d5133aecbed9d5696d59dcb799c3d8d30a89a08f6d36fac335f6b8357786353"
  license "GPL-3.0-or-later"
  head "https://github.com/dlenski/vpn-slice.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "913cade2832a94bdd301ec1607bb9536abebcab70ec89fbb07d8226d580b93bd" => :catalina
    sha256 "25853a55dbd7b31f1724297c5d1a249fc4e40e9da268052e01fcda985346f5bd" => :mojave
    sha256 "e306dcb3032b7e14abd6f0d22392e365248816b4a345b14b020d7fd608a52fb3" => :high_sierra
  end

  depends_on "python@3.9"

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
