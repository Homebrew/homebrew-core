class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  homepage "https://xon.sh"
  url "https://files.pythonhosted.org/packages/5e/ee/7c739d08fee6824ea525dd95678596752177e56b8655ed1468ed656b1339/xonsh-0.24.1.tar.gz"
  sha256 "506d05d994e66da20547b760e5c70935a32b8f6b29cbbb5442df59cbe22823db"
  license "BSD-2-Clause-Views"
  head "https://github.com/xonsh/xonsh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f9ba0a4436cab65aaf18553c13bc5578d8f46f88e7a64bcfc54c71b4313f125a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34778b7b80ba6bba63d471db683b9ba4287582ab6a6e5a8b744919e1561c6e91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ee7b3e0a91fc9940c672f45f9e0033b58cacca098690b30e3ff60b32d917635"
    sha256 cellar: :any_skip_relocation, sonoma:        "74c5eb495312c3a9b09ce3670656cb1c715f7a1dd8ca2d3d6db146253cdd5751"
    sha256 cellar: :any,                 arm64_linux:   "c982b407d17cde3b1681145610806720176840aef7bbe4e9c22420ab20df63a1"
    sha256 cellar: :any,                 x86_64_linux:  "523a8f91cec39935236ba820bd0728cff957dedb8295606ec8eba04b12a776dc"
  end

  depends_on "python@3.14"

  pypi_packages package_name: "xonsh[ptk,pygments,proctitle]"

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/7d/ea/39b988c938f75cb75d7045b5c69f8bfed47ee2152c8837fb403de29d6fb8/prompt_toolkit-3.0.53.tar.gz"
    sha256 "9ec8a0ad96d5c56148b3f914aa79c1564c3fde5d2e6b876e7bc327e353cf8fa6"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
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
