class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  homepage "https://xon.sh"
  url "https://files.pythonhosted.org/packages/c1/28/974f44afd5c05bcfb012d52a91b514e629706048c85d669a29eab2f0369a/xonsh-0.24.2.tar.gz"
  sha256 "461244cf1de8ed28d0c07cc548342b9e7969d46e17ef8d71b5d3064307930a25"
  license "BSD-2-Clause-Views"
  head "https://github.com/xonsh/xonsh.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "36c7b830e631d3319e0d6a2f7cb6ba023c1ce0db0efb1344d24ffee7bb5bde48"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6e925d9f218e1ecef77d43c965afab8025b36a2f17102eef144466a373302638"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c3503269de8c0e3f67056ca91f22789f01b578337336239b29fc1a4ba7a92461"
    sha256 cellar: :any,                 arm64_linux:       "b515b02b0264355e59ddaaf1cd9c1006df1cde54c26390d384a670062ea7b391"
    sha256 cellar: :any,                 x86_64_linux:      "e73b53b14f2ab5f0cbdbc7fe3c6d3aa0161bd955d16c535f86f8ff835df7fc3d"
  end

  depends_on "python@3.15"

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
    url "https://files.pythonhosted.org/packages/49/b0/6b8a516c5a9e9630bd5293db78314ac012f690305fe93beadea388626efb/setproctitle-1.3.8.tar.gz"
    sha256 "cafe209d064a6efb88cb45a03e97981ff8832802b2b5d009dde0197a3b7b41c8"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/f0/b4/7830542634bb2d3e62aa3b586a72d5b3b6c91c3168929e7000ef3fed041d/wcwidth-0.9.2.tar.gz"
    sha256 "ae0ef90b90f6af38b54f1fe6d58662ec33b3cb4b8391958a62416d654231727b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
