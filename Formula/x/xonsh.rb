class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  homepage "https://xon.sh"
  url "https://files.pythonhosted.org/packages/1e/82/a70fcbd8e542a55b990c61707c4f26fd42071badd3c08193931706a10323/xonsh-0.24.0.tar.gz"
  sha256 "14cbf5bcac12bdbedd8ddb7bd2221ca869903eb039e97158ee86aa639152fff6"
  license "BSD-2-Clause-Views"
  head "https://github.com/xonsh/xonsh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76d3dcdd6a8a138dd9dc41afd760d0a877cf0941eeb7f0b355648286cfb0a61d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6306ad965e473b324fc54f35ba90c5854c9d288d99505dbad5a0c2bfb842978"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22d676e80a0a5e042af00e13cd4e1e7849b6d337ad1cb74cc413e04b0e88dda8"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb13442b42943d4b0b65f8df881d4a78007809d7f5948cac7bb55dd17be31369"
    sha256 cellar: :any,                 arm64_linux:   "e2632af36cfdc8d579bfc0e6ccc1459d1cc5c5219a73ad1bcdc45d2b9360d9dd"
    sha256 cellar: :any,                 x86_64_linux:  "b6d4112f707db58710641c3f84f69a4794be021356e7db6951f8adf91dd86aba"
  end

  depends_on "python@3.14"

  pypi_packages package_name: "xonsh[ptk,pygments,proctitle]"

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/a1/96/06e01a7b38dce6fe1db213e061a4602dd6032a8a97ef6c1a862537732421/prompt_toolkit-3.0.52.tar.gz"
    sha256 "28cde192929c8e7321de85de1ddbe736f1375148b02f2e17edd840042b1be855"
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
