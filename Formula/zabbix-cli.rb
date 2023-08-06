class ZabbixCli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for interacting with Zabbix monitoring system"
  homepage "https://github.com/unioslo/zabbix-cli/"
  url "https://github.com/unioslo/zabbix-cli/archive/2.3.1.tar.gz"
  sha256 "1d6de0486a5cd6b4fdd53c35810bd14e423ed039ed7ad0865ea08f6082309564"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/unioslo/zabbix-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7362041147245c4f2979b03c097bdf1ae24b4055110f03e0ffb4a05f48b63f06"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2b12a2329f7a7d4f134dd4f430a9ea2cb7dd74b99ded6ae98a1a09096418d4c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b83f51d3994cfcda468beff1996b1a4c794c915cd2abe41b98f079f37e3ad0c"
    sha256 cellar: :any_skip_relocation, ventura:        "d327579f4c13be3bb08a67f7167008f12e35756e7fc9307852e28477e73473cb"
    sha256 cellar: :any_skip_relocation, monterey:       "43580c8d4181825b8cd698d59255e64b1c5d24a8e421bdded49969218b90e3ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "9dfe5ab7e7902c2d11f5110927c47c101d11711f69fb736393975dc6a5217a6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abf66abceb86a3ef50f56c9938ccd328b6e7ace0b1f089da993f61f8d6f0c29a"
  end

  depends_on "python-certifi"
  depends_on "python@3.11"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/31/ab/46bec149bbd71a4467a3063ac22f4486ecd2ceb70ae8c70d5d8e4c2a7946/urllib3-2.0.4.tar.gz"
    sha256 "8d22f86aae8ef5e410d4f539fde9ce6b2113a001bb4d189e0aed70642d602b11"
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
