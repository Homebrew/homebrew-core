class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  homepage "https://xon.sh"
  url "https://files.pythonhosted.org/packages/99/d7/269a167722c8cea95204add643664a7dcb445ef50f5810a924ca7fd3e3f2/xonsh-0.22.8.tar.gz"
  sha256 "5eedf7822f1655eb4f29a7c3916b0dcc7b8fe548b4b83001afe79f3bd39be28c"
  license "BSD-2-Clause-Views"
  revision 1
  head "https://github.com/xonsh/xonsh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dcccf913ccad7b3bc26c8714207c4fcfc966a34ebaee8174fc8b01fa1b50ef5e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86a57ef41000ced4a0ddf09505bac4897db5b62c91cd6026cb127192cc0a1b55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c658c36c57e131cbe0f091858e12181c4a1519a8499494256e961cfb196621d"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f882ea5a2daf7f832933896501f7f58e4502179481e291aa4cbe96a4fcce83e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad4533c9c8f2ad62a381d925289ddc2c3507c8783cb687d697e36a9f8a928764"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00513aa360a4966604881aab7caba0b69b8aab2fcd13c9582628fe7400f99f12"
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
    url "https://files.pythonhosted.org/packages/35/a2/8e3becb46433538a38726c948d3399905a4c7cabd0df578ede5dc51f0ec2/wcwidth-0.6.0.tar.gz"
    sha256 "cdc4e4262d6ef9a1a57e018384cbeb1208d8abbc64176027e2c2455c81313159"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
