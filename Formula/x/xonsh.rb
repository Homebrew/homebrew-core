class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  homepage "https://xon.sh/"
  url "https://files.pythonhosted.org/packages/ea/eb/8f544caca583c5f9f0ae7d852769fdb8ed5f63b67646a3c66a2d19357d56/xonsh-0.19.9.tar.gz"
  sha256 "4cab4c4d7a98aab7477a296f12bc008beccf3d090c6944f0b3375d80a574c37d"
  license "BSD-2-Clause-Views"
  head "https://github.com/xonsh/xonsh.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb4d66b56fd882428f592e56d9d6078a44448fb7083bcc54197794dbb88580b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2a308a8f33cac144dac27e389a8845601cccdc083362ee01bc15a793336023e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a910846d425f9eb8c6dc3822d12889689a63e31d517d2da79e828b9f2e2248c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "107df7f91e3045034b010e6a61fa77892adefa2c619df58d8b7adcd55995a778"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41e18f6c2baf3d3a7bc9fc6ff7ee26e92493adc83fbee7a57bfc2b4c803ca8e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68d93dc0ff21fd4dbe5b48cabd8709d340f45ac2710b8b1c09a6e0f4c98603e7"
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
