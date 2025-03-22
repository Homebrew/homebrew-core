class VpnSlice < Formula
  include Language::Python::Virtualenv

  desc "Vpnc-script replacement for easy and secure split-tunnel VPN setup"
  homepage "https://github.com/dlenski/vpn-slice"
  url "https://files.pythonhosted.org/packages/74/fd/6c9472e8ed83695abace098d83ba0df4ea48e29e7b2f6c77ced73b9f7dce/vpn-slice-0.16.1.tar.gz"
  sha256 "28d02dd1b41210b270470350f28967320b3a34321d57cc9736f53d6121e9ceaa"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/dlenski/vpn-slice.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "030d0284ec3bee7237e6be61d77f11226daf5055d5f850274e2bce4c465948fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f53f8aebf613d157c42822443d6ec89e324fb5a6bc199ed958fb2a9398fcd20c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cc5792e45ec19a84b271d7a64c67b563c5d47de935573999fe393ce8d6b0e57b"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ba7166b31584166d94509199258de76bed44198e7cf5ad9e81a2aaa12534dcc"
    sha256 cellar: :any_skip_relocation, ventura:       "be287f30e018f5ce7cefa4ed424b71ee9267d8ecc4436e17cc3a06935cd73b64"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00d745fe50d1635ac36c9ca32e320c5924537b4da2109385c452b349b5246b1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e85e74c3c382b4f67cc29d48cab021c3dd9a64a71fc06f9f9de5d9a22bfe1402"
  end

  depends_on "python@3.13"

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/b5/4a/263763cb2ba3816dd94b08ad3a33d5fdae34ecb856678773cc40a3605829/dnspython-2.7.0.tar.gz"
    sha256 "ce9c432eda0dc91cf618a5cedf1a4e142651196bbcd2c80e89ed5a907e5cfaf1"
  end

  resource "setproctitle" do
    url "https://files.pythonhosted.org/packages/ff/e1/b16b16a1aa12174349d15b73fd4b87e641a8ae3fb1163e80938dbbf6ae98/setproctitle-1.3.3.tar.gz"
    sha256 "c913e151e7ea01567837ff037a23ca8740192880198b7fbb90b16d181607caae"
  end

  # Drop setuptools dep
  # https://github.com/dlenski/vpn-slice/pull/149
  patch do
    url "https://github.com/dlenski/vpn-slice/commit/5d0c48230854ffed5042192d921d8d97fbe427be.patch?full_index=1"
    sha256 "0ae3a54d14f1be373478820de2c774861dd97f9ae156fef21d27c76cee157951"
  end

  def install
    ENV["PIP_USE_PEP517"] = "1"
    virtualenv_install_with_resources
  end

  test do
    # vpn-slice needs root/sudo credentials
    output = shell_output("#{bin}/vpn-slice 192.168.0.0/24 2>&1", 1)
    assert_match "Cannot read/write /etc/hosts", output
  end
end
