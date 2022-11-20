class VpnSlice < Formula
  include Language::Python::Virtualenv

  desc "Vpnc-script replacement for easy and secure split-tunnel VPN setup"
  homepage "https://github.com/dlenski/vpn-slice"
  url "https://files.pythonhosted.org/packages/74/fd/6c9472e8ed83695abace098d83ba0df4ea48e29e7b2f6c77ced73b9f7dce/vpn-slice-0.16.1.tar.gz"
  sha256 "28d02dd1b41210b270470350f28967320b3a34321d57cc9736f53d6121e9ceaa"
  license "GPL-3.0-or-later"
  head "https://github.com/dlenski/vpn-slice.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7798a26686d124c506967ff63713b888fc36cadbee332330a5260ea925837b28"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03c28ff89eec7cc5e56ef7daf5ac634527b5cdc5c7203fa2a55aad4c13eeef05"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "891ccb3aa60a9a987136f616f5037c1cb8b58835042b96f7d71bc66b29ae9c38"
    sha256 cellar: :any_skip_relocation, ventura:        "ad37647e9afbd689a2dbba1beabe018dc5c4cd26476d2dab30fbbd60554bf9da"
    sha256 cellar: :any_skip_relocation, monterey:       "0fed89c47a9cd556d276233a55b54d7ef21ac683e7d8054827f51bf3adb699ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "63f4dec62b148f81d1de93cd938363ef9f51f542974f172b3ada0e317c391875"
    sha256 cellar: :any_skip_relocation, catalina:       "37659888aa845fa2726e77c5973109b9b2552d4bea491f3b84e3d7c1d6eaa9ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6e0387688208ea25eb4f1a3ebbe358ebb9b00d530714c1dcd6b01b4152493a8"
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
