class ZabbixCli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for interacting with Zabbix monitoring system"
  homepage "https://github.com/unioslo/zabbix-cli/"
  url "https://github.com/unioslo/zabbix-cli/archive/refs/tags/2.3.2.tar.gz"
  sha256 "e56b6be1c13c42c516c8e8e6b01948fc81591eae83f8babb7bee6d2025299c26"
  license "GPL-3.0-or-later"
  head "https://github.com/unioslo/zabbix-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "615774762025acd0659ecf3daf919e6114eafa54e8a8df120e0dd48b757a7964"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7813942f1e22699abfad5fb7871c4a92f236f5fcf1a44eb704a07e72e60ffde7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28eef75530b6d15d5a47c9055861403925c40537259eeec20e9b9ce36ae8cff1"
    sha256 cellar: :any_skip_relocation, sonoma:         "c4b6555f444442b982eac10a1dbd8d514b7a98bc1a251d7956b4e1aea42de648"
    sha256 cellar: :any_skip_relocation, ventura:        "d3a935de2f2d586566c562f64c7cd0ad57a5716ecf4195b26670a718c6e9e11a"
    sha256 cellar: :any_skip_relocation, monterey:       "eebfe753011a00db105682b46558372654fc2c19b63784096f3b7d4e1b0e3b71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4cae7790742cc2b5fb0f92a180ce26e52d0099fb55a4f7973fc3774ef3c92dc1"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  def install
    # script tries to install config into /usr/local/bin (macOS) or /usr/share (Linux)
    inreplace %w[setup.py etc/zabbix-cli.conf zabbix_cli/config.py], %r{(["' ])/usr/share/}, "\\1#{share}/"
    inreplace "setup.py", "/usr/local/bin", share

    virtualenv_install_with_resources
  end

  test do
    system bin/"zabbix-cli-init", "-z", "https://homebrew-test.example.com/"
    config = testpath/".zabbix-cli/zabbix-cli.conf"
    assert_predicate config, :exist?
    assert_match "homebrew-test.example.com", config.read
  end
end
