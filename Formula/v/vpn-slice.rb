class VpnSlice < Formula
  include Language::Python::Virtualenv

  desc "Vpnc-script replacement for easy and secure split-tunnel VPN setup"
  homepage "https://github.com/dlenski/vpn-slice"
  url "https://files.pythonhosted.org/packages/74/fd/6c9472e8ed83695abace098d83ba0df4ea48e29e7b2f6c77ced73b9f7dce/vpn-slice-0.16.1.tar.gz"
  sha256 "28d02dd1b41210b270470350f28967320b3a34321d57cc9736f53d6121e9ceaa"
  license "GPL-3.0-or-later"
  head "https://github.com/dlenski/vpn-slice.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "06be0346ac3f5bc81d9c48f65272f98a0077aa8451ca390d011e3461066f697f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "285e4532b8bac6eb5a40c0a4b00160ce14762e51fe649eb72571fafaeb55e551"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1340a190aa89d25abb928c276f0d916afc0858f17d2cea7470e0c770352074e"
    sha256 cellar: :any_skip_relocation, sonoma:         "c8552b9edb0b222a44cd398e1e67ee932a62f9f3068a05d6e8f6a784f123b2a6"
    sha256 cellar: :any_skip_relocation, ventura:        "8134ff7619c007c0285093f8c5bb5d4faa58380614612df94ac800148bf62a0c"
    sha256 cellar: :any_skip_relocation, monterey:       "8dbc0128fb07e6682fe5e472354ba6bbe839ca8c987e4758232422c56167c1fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f264427a1600d282f31182e68af0a6e8cc84ef392aab087c60d1f15ed0e4b05f"
  end

  depends_on "python@3.12"

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/65/51/fbffab4071afa789e515421e5749146beff65b3d371ff30d861e85587306/dnspython-2.5.0.tar.gz"
    sha256 "a0034815a59ba9ae888946be7ccca8f7c157b286f8455b379c692efb51022a15"
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
