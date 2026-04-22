class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  homepage "https://xon.sh"
  url "https://files.pythonhosted.org/packages/9c/27/a5b41f385deb4d4d3d01698c32c63417a20f7c6035a02fc5bbad73000d09/xonsh-0.23.0.tar.gz"
  sha256 "3212933ab8aee03f2d7689c6f89b578b410f4c3d8426b517f5cfb12a94ea959d"
  license "BSD-2-Clause-Views"
  head "https://github.com/xonsh/xonsh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1b949e28af30fee8c7a11e40069472bb8b8058defcec11df082c8dfa47af3fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23de27557c55d4171215e805f265719bea36da7d224c2d0c275a8e38f835578e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bcda28bafa4393da838ac2ec3bff46475940b8fcc74097a577fd0b79de56806a"
    sha256 cellar: :any_skip_relocation, sonoma:        "85356e4969f2bbbed1741de287c3e189380ebb79b459d58c7c6d32e73b355059"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa8e8e552a4142efaa9ca1ac1aa33761d598f0b4795d7518d39504fc120049e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f1b267eb1d0acc3440905e4c6ac747835ba4723566965d90c6fa3301d8467ac"
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
