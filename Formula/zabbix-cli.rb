class ZabbixCli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for interacting with Zabbix monitoring system"
  homepage "https://github.com/unioslo/zabbix-cli/"
  url "https://github.com/unioslo/zabbix-cli/archive/2.3.0.tar.gz"
  sha256 "76a5abb5bad02b2305f6f92dff6251d1290a8efe383a17af54cf7c0aa71ba88e"
  license "GPL-3.0-or-later"
  head "https://github.com/unioslo/zabbix-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "082eb7d6258f879a8a1efc37bce9bfe1af127796a11c2183b00b3af6029458bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "082eb7d6258f879a8a1efc37bce9bfe1af127796a11c2183b00b3af6029458bd"
    sha256 cellar: :any_skip_relocation, monterey:       "c6a723a414a06752ff87be0f895a4629da612399d9274f4c34cb5e4bd9b2f955"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6a723a414a06752ff87be0f895a4629da612399d9274f4c34cb5e4bd9b2f955"
    sha256 cellar: :any_skip_relocation, catalina:       "c6a723a414a06752ff87be0f895a4629da612399d9274f4c34cb5e4bd9b2f955"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3aa46984e858b73d557301d0b209daa516d747eda0d10bc1d6ba62221efc02c1"
  end

  depends_on "python@3.10"

  ## direct dependencies

  resource "requests" do
    url "https://files.pythonhosted.org/packages/60/f3/26ff3767f099b73e0efa138a9998da67890793bfa475d8278f84a30fec77/requests-2.27.1.tar.gz"
    sha256 "68d7c56fd5a8999887728ef304a6d12edc7be74f1cfa47714fc8b414525c9a61"
  end

  ## indirect dependencies

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/07/10/75277f313d13a2b74fc56e29239d5c840c2bf09f17bf25c02b35558812c6/certifi-2022.5.18.1.tar.gz"
    sha256 "9c5705e395cd70084351dd8ad5c41e65655e08ce46f2ec9cf6c2c08390f71eb7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/56/31/7bcaf657fafb3c6db8c787a865434290b726653c912085fbd371e9b92e1c/charset-normalizer-2.0.12.tar.gz"
    sha256 "2857e29ff0d34db842cd7ca3230549d1a697f96ee6d3fb071cfa6c7393832597"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/1b/a5/4eab74853625505725cefdf168f48661b2cd04e7843ab836f3f63abf81da/urllib3-1.26.9.tar.gz"
    sha256 "aabaf16477806a5e1dd19aa41f8c2b7950dd3c746362d7e3223dbe6de6ac448e"
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
