class ZabbixCli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for interacting with Zabbix monitoring system"
  homepage "https://github.com/unioslo/zabbix-cli/"
  url "https://github.com/unioslo/zabbix-cli/archive/2.2.1.tar.gz"
  sha256 "884ecd2a4a4c7f68a080bb7e0936dd208c813284ec3ed60b948ce90a1be7c828"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/unioslo/zabbix-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60b0cdb24333cf77e677f4a4c67e528a27138cdf0b24ea77b5474ab57ee18f73"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "60b0cdb24333cf77e677f4a4c67e528a27138cdf0b24ea77b5474ab57ee18f73"
    sha256 cellar: :any_skip_relocation, monterey:       "76e5471117d67eb54bd07a336bbdd6a5781fe7330d3952af4464275d96b2467a"
    sha256 cellar: :any_skip_relocation, big_sur:        "76e5471117d67eb54bd07a336bbdd6a5781fe7330d3952af4464275d96b2467a"
    sha256 cellar: :any_skip_relocation, catalina:       "76e5471117d67eb54bd07a336bbdd6a5781fe7330d3952af4464275d96b2467a"
    sha256 cellar: :any_skip_relocation, mojave:         "76e5471117d67eb54bd07a336bbdd6a5781fe7330d3952af4464275d96b2467a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "724826e93d6e144ba29f7a406b6cf312337dbbf412f550918c2c4174c1b583e3"
  end

  depends_on "python@3.10"

  ## direct dependencies

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/93/22/953e071b589b0b1fee420ab06a0d15e5aa0c7470eb9966d60393ce58ad61/docutils-0.15.2.tar.gz"
    sha256 "a2aeea129088da402665e92e0b25b04b073c04b2dce4ab65caaa38b7ce2e1a99"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/f5/4f/280162d4bd4d8aad241a21aecff7a6e46891b905a4341e7ab549ebaf7915/requests-2.23.0.tar.gz"
    sha256 "b3f43d496c6daba4493e7c431722aeb7dbc6288f52a6e04e7b6023b0247817e6"
  end

  ## indirect dependencies

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/41/bf/9d214a5af07debc6acf7f3f257265618f1db242a3f8e49a9b516f24523a6/certifi-2019.11.28.tar.gz"
    sha256 "25b64c7da4cd7479594d035c08c2d809eb4aab3a26e5a990ea98cc450c320f1f"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cb/19/57503b5de719ee45e83472f339f617b0c01ad75cba44aba1e4c97c2b0abd/idna-2.9.tar.gz"
    sha256 "7588d1c14ae4c77d74036e8c22ff447b26d0fde8f007354fd48a7814db15b7cb"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/09/06/3bc5b100fe7e878d3dee8f807a4febff1a40c213d2783e3246edde1f3419/urllib3-1.25.8.tar.gz"
    sha256 "87716c2d2a7121198ebcb7ce7cccf6ce5e9ba539041cfbaeecfb641dc0bf6acc"
  end

  # Support python@3.10, remove with next release
  patch do
    url "https://github.com/unioslo/zabbix-cli/commit/656fdbbd6c4415b52f7ad42a29124b15387458de.patch?full_index=1"
    sha256 "21d574e0d2500d140591c494e513d81552d5f7e259cc0084cc9fa0488532a55c"
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
    assert_match "homebrew-test.example.com", File.read(config)
  end
end
