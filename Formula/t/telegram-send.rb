class TelegramSend < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool to send Telegram messages"
  homepage "https://pypi.org/project/telegram-send/"
  url "https://files.pythonhosted.org/packages/1c/9d/6c59f78b5761d6fe5a3694d83fb8eff7e6cd190d57d4a61d66ef9e8f4c7f/telegram_send-0.39.2.tar.gz"
  sha256 "bb1570fda809a030dfa188ffb30fd92b97de6cde9f1268d57fed6b28c2f4aff5"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/rahiel/telegram-send.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6fda32be93932ecbf57e174f4305be683fc32973aa37cfc14b11bc020175ca51"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6fda32be93932ecbf57e174f4305be683fc32973aa37cfc14b11bc020175ca51"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6fda32be93932ecbf57e174f4305be683fc32973aa37cfc14b11bc020175ca51"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "784b1fa70d25b36c5536c56b33e7e098023f20ac277ff37d7918e5175774f922"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "784b1fa70d25b36c5536c56b33e7e098023f20ac277ff37d7918e5175774f922"
  end

  depends_on "certifi" => :no_linkage
  depends_on "python@3.15"

  pypi_packages exclude_packages: "certifi"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a9/d2/f4d173e22df740bc37b1db102b386ba719b66e95b0f0d751f556b387e6d2/anyio-4.15.1.tar.gz"
    sha256 "9f28306018cbd6d329e64a36d58256edff76dd996fe423bc957326e578b82a94"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/80/a8/66d45abadff219e36e2a824181b8f6a67e7ed4572934d6252c71c29d5731/platformdirs-4.13.0.tar.gz"
    sha256 "1aa0b0d3f224c1f07c295121e312a5a24a180d6ae5a8425ea1784b3e3863e9c0"
  end

  resource "python-telegram-bot" do
    url "https://files.pythonhosted.org/packages/0b/6b/400f88e5c29a270c1c519a3ca8ad0babc650ec63dbfbd1b73babf625ed54/python_telegram_bot-22.5.tar.gz"
    sha256 "82d4efd891d04132f308f0369f5b5929e0b96957901f58bcef43911c5f6f92f8"
  end

  def install
    venv = virtualenv_install_with_resources
    inreplace venv.site_packages/"telegram_send/telegram_send.py", "/etc/telegram-send.conf", etc/"telegram-send.conf"
  end

  test do
    assert_match "#{etc}/telegram-send.conf", shell_output("#{bin}/telegram-send --help")
    assert_match "Config not found", shell_output("#{bin}/telegram-send 'Hello world'", 1)
  end
end
