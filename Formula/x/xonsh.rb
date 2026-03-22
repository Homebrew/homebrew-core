class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  homepage "https://xon.sh"
  url "https://files.pythonhosted.org/packages/99/d7/269a167722c8cea95204add643664a7dcb445ef50f5810a924ca7fd3e3f2/xonsh-0.22.8.tar.gz"
  sha256 "5eedf7822f1655eb4f29a7c3916b0dcc7b8fe548b4b83001afe79f3bd39be28c"
  license "BSD-2-Clause-Views"
  head "https://github.com/xonsh/xonsh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6589d19e7da196fc49f38ea0261dc9e7e997c29ed1592b1c085e9f23f3de982f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0de65006ee16728beb3991b16aa87ae4d21192a4d046dd9ad28e88b42e397363"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8685a9f533a8d8f84b37cbd0e66940cd29fc08bb0df5e2d415974854a671c15b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec9e398a6880d4c91fbdf99f90c4180bef61c86fe396f93aafde43dcf9ba6363"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f60b50b1026dce1323637707396960de0f487567fdb208ad27445d5357fdb5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3debccb3e970683d842357ed49690e6a50a0e37e7cff171ad90cdb25e4ee33c"
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
