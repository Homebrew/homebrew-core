class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  homepage "https://xon.sh"
  url "https://files.pythonhosted.org/packages/8c/79/55efae582e9662c03e50a358b4850b1df82eab1f92a8e84e61b196f48b85/xonsh-0.23.1.tar.gz"
  sha256 "40f5531ce4c1d9df1ee5300c1849db22ad24c5d075279f07cebb6b75bbbb98a2"
  license "BSD-2-Clause-Views"
  head "https://github.com/xonsh/xonsh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f70ffb7e3c38c7cfb1af965e44f328872c977107c83d9b90be9f8a6ac9a7502b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98d5435e3b6ed8ce14d27df026592f7fcf9347a3de04e32a202716dbc8859e52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b399abc51d1e7ab81ac24cb3c21093f47bfca7705806227e8409df79f45b65d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ff2e38cc86a08091301c68ad36b0d3db92fc0ac9ae757f1820022ac2da93098"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fcc7541c345f70bdf09c41e8eab13fe227f9c7b2c49cd4026988b20c5a492c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "642d0b941bee083f5c88727d5e5eb71b391351a70b64a076340ac9cd730b5af7"
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
