class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  homepage "https://xon.sh/"
  url "https://files.pythonhosted.org/packages/56/af/7e2ba3885da44cbe03c7ff46f90ea917ba10d91dc74d68604001ea28055f/xonsh-0.20.0.tar.gz"
  sha256 "d44a50ee9f288ff96bd0456f0a38988ef6d4985637140ea793beeef5ec5d2d38"
  license "BSD-2-Clause-Views"
  head "https://github.com/xonsh/xonsh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8fefd4167875eb1284e125596a3930f4e48a806be11016a589cc0b240526ec12"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1ed9807b5523e04e1c74fdfa9cc0e133a02e56669f3442fc8ec4fbf30006797"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57d4cffd239ff3709fa079c1b48b3be85618612474d135f693b1b443ea589ebf"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ec1d67528796c19398fdd722ee2057c3da75836c09456748b42bab6e2382f6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1df623c4ffaf03ede799d4e82349b02188d3fe9e359fc009de52435e18f3df3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef3c0baf74b28f17ded231596eb1914a1dcfe154b8d2d3f0ac52f45d7ca17ea2"
  end

  depends_on "python@3.14"

  pypi_packages package_name: "xonsh[ptk,pygments,proctitle]"

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/a1/96/06e01a7b38dce6fe1db213e061a4602dd6032a8a97ef6c1a862537732421/prompt_toolkit-3.0.52.tar.gz"
    sha256 "28cde192929c8e7321de85de1ddbe736f1375148b02f2e17edd840042b1be855"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
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
    url "https://files.pythonhosted.org/packages/24/30/6b0809f4510673dc723187aeaf24c7f5459922d01e2f794277a3dfb90345/wcwidth-0.2.14.tar.gz"
    sha256 "4d478375d31bc5395a3c55c40ccdf3354688364cd61c4f6adacaa9215d0b3605"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
