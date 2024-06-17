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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9f7f409f5fe1c9606d96d9c1dd48a075484d6d080be81ddd6959b219c7fc5ea3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f70962cccac91126411acd26a83dd6537528fee2884ebf613bd6fb4dc59f3ec7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fac93532860e47b154d134bb2c87edf7d9edf4ce6f012a15cc73f1477cfa4d45"
    sha256 cellar: :any_skip_relocation, sonoma:         "7d0bba894ac6e5494ffe65dbe6e2a2557e76d642a574c4c2577b6e27d7559134"
    sha256 cellar: :any_skip_relocation, ventura:        "3fc810b41f701c5abed133591c5d56c72e8694452a2dccc7f9eefb3eaefb8879"
    sha256 cellar: :any_skip_relocation, monterey:       "3c9565d23351cdcca7a62df51f38b9b12e7c7d3527d99e741ff95c0882c63aeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0a8c8843ea74c81520ef487e8db23c29dd1f37eca2995f9e5e8aabf412609ac"
  end

  depends_on "python@3.12"

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/37/7d/c871f55054e403fdfd6b8f65fd6d1c4e147ed100d3e9f9ba1fe695403939/dnspython-2.6.1.tar.gz"
    sha256 "e8f0f9c23a7b7cb99ded64e6c3a6f3e701d78f50c55e002b839dea7225cff7cc"
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
