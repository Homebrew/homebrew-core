class TelegramSend < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool to send Telegram messages"
  homepage "https://pypi.org/project/telegram-send/"
  url "https://files.pythonhosted.org/packages/1c/9d/6c59f78b5761d6fe5a3694d83fb8eff7e6cd190d57d4a61d66ef9e8f4c7f/telegram_send-0.39.2.tar.gz"
  sha256 "bb1570fda809a030dfa188ffb30fd92b97de6cde9f1268d57fed6b28c2f4aff5"
  license "GPL-3.0-or-later"
  head "https://github.com/rahiel/telegram-send.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dfa065f3430f0290cbd1699488b25e97d67e592f7ce6d1d844771a8c00f6d5bf"
  end

  depends_on "certifi" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/19/14/2c5dd9f512b66549ae92767a9c7b330ae88e1932ca57876909410251fe13/anyio-4.13.0.tar.gz"
    sha256 "334b70e641fd2221c1505b3890c69882fe4a2df910cba14d97019b90b24439dc"
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
    url "https://files.pythonhosted.org/packages/b9/28/99c51f664567218d824af024c0251650fb27e4ca066df188dab0769c5b91/idna-3.17.tar.gz"
    sha256 "5eb0cb53bc467c12eadcf6de83163ad8527cec9416f44b9b61b19caedad2b87f"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d7/47/e4501f49c178ae1d9f4a75073fda4204f52647993f075a9db4d14930e0c5/platformdirs-4.10.0.tar.gz"
    sha256 "31e761a6a0ca04faf7353ea759bdba55652be214725111e5aac52dfa29d4bef7"
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
