class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  # xon.sh homepage bug report, https://github.com/xonsh/xonsh/issues/5984
  homepage "https://github.com/xonsh/xonsh"
  url "https://files.pythonhosted.org/packages/48/df/1fc9ed62b3d7c14612e1713e9eb7bd41d54f6ad1028a8fbb6b7cddebc345/xonsh-0.22.4.tar.gz"
  sha256 "6be346563fec2db75778ba5d2caee155525e634e99d9cc8cc347626025c0b3fa"
  license "BSD-2-Clause-Views"
  head "https://github.com/xonsh/xonsh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "761862d24180fc0a0b241bf50466af4e30c4a30a1c65df1fa6f4094d968814b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a38c0eb21bf24bf90874ff08e7cd604555ee90ab383bb15999651af07db4273"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bcca28a69a309798c3c8522f3f67787b200dbb7a585bd7b3a76bb4b06d89838d"
    sha256 cellar: :any_skip_relocation, sonoma:        "10ad54804a1853e6545c339770e63986b326e05c00d9bbcfcb58d35be82f221a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e48bcd99471386797ebbf2d4fd763ce6189f282fec2d9ea388ec961d59b1f7da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0199893f9b0ea21ebd1ef890b6fad4731989db141fed0da664de01ec59c8299d"
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
