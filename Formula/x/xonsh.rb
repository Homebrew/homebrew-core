class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  homepage "https://xon.sh"
  url "https://files.pythonhosted.org/packages/c1/28/974f44afd5c05bcfb012d52a91b514e629706048c85d669a29eab2f0369a/xonsh-0.24.2.tar.gz"
  sha256 "461244cf1de8ed28d0c07cc548342b9e7969d46e17ef8d71b5d3064307930a25"
  license "BSD-2-Clause-Views"
  head "https://github.com/xonsh/xonsh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "61ffadbc86c2eeb6b7e1c11abe1a753a0260202b0bb95c74e3dec99c26e4e479"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bd6f5febe88a740e4c4dca1374fa5ce1fbe6e4c85bdf75f6c39179ee8aff0f7b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "be2d52d63d46ccffb6313cc3dba49be635c6609242acebcd9121e272857017b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "8fb8bb34f74abfe7fd2a64d08e26149a4cd69072b6bd29944040eff0b0513c84"
    sha256 cellar: :any_skip_relocation, sonoma:            "205915b9bce44c8a08b6222e91a4dc5e65ada04fc1a965c408cc368c7245482d"
    sha256 cellar: :any,                 arm64_linux:       "68cb88360903556f2320da899c5891e39cd7ceef4846a36820ea92e7e56c58b2"
    sha256 cellar: :any,                 x86_64_linux:      "9f2fa3eef2c63c50f0b8fbb99c630bb7490b567d4bf653dbab02cbd9ebd3d8fb"
  end

  depends_on "python@3.14"

  pypi_packages package_name: "xonsh[ptk,pygments,proctitle]"

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/7d/ea/39b988c938f75cb75d7045b5c69f8bfed47ee2152c8837fb403de29d6fb8/prompt_toolkit-3.0.53.tar.gz"
    sha256 "9ec8a0ad96d5c56148b3f914aa79c1564c3fde5d2e6b876e7bc327e353cf8fa6"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/e8/52/d87eba7cb129b81563019d1679026e7a112ef76855d6159d24754dbd2a51/pyperclip-1.11.0.tar.gz"
    sha256 "244035963e4428530d9e3a6101a1ef97209c6825edab1567beac148ccc1db1b6"
  end

  resource "setproctitle" do
    url "https://files.pythonhosted.org/packages/8d/48/49393a96a2eef1ab418b17475fb92b8fcfad83d099e678751b05472e69de/setproctitle-1.3.7.tar.gz"
    sha256 "bc2bc917691c1537d5b9bca1468437176809c7e11e5694ca79a9ca12345dcb9e"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/34/74/c6428f875774288bec1396f5bfcbc2d925700a4dad61727fd5f2b12f249d/wcwidth-0.8.2.tar.gz"
    sha256 "91fbef97204b96a3d4d421609b80340b760cf33e26da123ff243d76b1fda8dda"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
