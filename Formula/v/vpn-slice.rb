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
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ce45fcd3f9bed8b11fd2780ecf0ec7379c9ba89d8f79e692b0c71bb31dfde26"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd141a705bff3a74746ba42047e6636530cd379ee7dbc3aab25977cd51a10e17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "414c174578e03c9f89b096e4cac861119b9e29fcb9e68b44d02ebd9e1d911be9"
    sha256 cellar: :any_skip_relocation, sonoma:        "78fbe63be8429f0ab38427d75dd2ed511a578f89f5019d5a775a7acb4cc2784a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8778f4daae86d96a51e7aed7efd2de7b556cc1dd1e41246855278da5622056d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e11db2b6fae77e64c63f5f9c3151a64d81a79db650bf5389e99dbeb406954734"
  end

  depends_on "python@3.14"

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/8c/8b/57666417c0f90f08bcafa776861060426765fdb422eb10212086fb811d26/dnspython-2.8.0.tar.gz"
    sha256 "181d3c6996452cb1189c4046c61599b84a5a86e099562ffde77d26984ff26d0f"
  end

  resource "setproctitle" do
    url "https://files.pythonhosted.org/packages/8d/48/49393a96a2eef1ab418b17475fb92b8fcfad83d099e678751b05472e69de/setproctitle-1.3.7.tar.gz"
    sha256 "bc2bc917691c1537d5b9bca1468437176809c7e11e5694ca79a9ca12345dcb9e"
  end

  # Drop setuptools dep
  # https://github.com/dlenski/vpn-slice/pull/149
  patch do
    url "https://github.com/dlenski/vpn-slice/commit/5d0c48230854ffed5042192d921d8d97fbe427be.patch?full_index=1"
    sha256 "0ae3a54d14f1be373478820de2c774861dd97f9ae156fef21d27c76cee157951"
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
