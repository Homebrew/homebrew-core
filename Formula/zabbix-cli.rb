class ZabbixCli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for interacting with Zabbix monitoring system"
  homepage "https://github.com/unioslo/zabbix-cli/"
  url "https://github.com/unioslo/zabbix-cli/archive/2.3.1.tar.gz"
  sha256 "1d6de0486a5cd6b4fdd53c35810bd14e423ed039ed7ad0865ea08f6082309564"
  license "GPL-3.0-or-later"
  head "https://github.com/unioslo/zabbix-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "43721eecd306e7a65ab883d5567e59eaf57380a02d00f1c9d4c4a9502f4c2a49"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ae0b87404c2c6f6242137ae906afa68afdd66bcc1deb64163ad3f2f3217308d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "79d7ce0ae4767400dc2c7c3219bdd4ba569677e16963e652d3ca7023447154e3"
    sha256 cellar: :any_skip_relocation, monterey:       "ad323071b6f0426221d3a039a5ba792227c4580827b6dc190a25757f70be4eaa"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a91cd80a519730d0f6f88780018e340f255b48d0b75d94848a9bb412e3277ab"
    sha256 cellar: :any_skip_relocation, catalina:       "f57a99ba9ea40c21b9f4087a0bbd40277d826e3b81ea7b71414ab640ace2b16a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c6eb4257b29e2c6dd27a7b7ddebb16082e849ee0a4d8c089ff943376d042b83"
  end

  depends_on "python@3.11"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cb/a4/7de7cd59e429bd0ee6521ba58a75adaec136d32f91a761b28a11d8088d44/certifi-2022.9.24.tar.gz"
    sha256 "0d9c601124e5a6ba9712dbc60d9c53c21e34f5f641fe83002317394311bdce14"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/a1/34/44964211e5410b051e4b8d2869c470ae8a68ae274953b1c7de6d98bbcf94/charset-normalizer-2.1.1.tar.gz"
    sha256 "5a3d016c7c547f69d6f81fb0db9449ce888b418b5b9952cc5e6e66843e9dd845"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
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
