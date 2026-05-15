class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  homepage "https://xon.sh"
  url "https://files.pythonhosted.org/packages/d6/a5/931a92b7cb37eaf26e52a9f2cc7497927378317a2fc9e780f8ac164d8839/xonsh-0.23.6.tar.gz"
  sha256 "e84df87043bed150eeb591b55dd4fbc239aefa149cf4cf854892ec74ef8fd6a3"
  license "BSD-2-Clause-Views"
  head "https://github.com/xonsh/xonsh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c68cb00421719f522064f7ef662f93c1932b23912f9bade8aa8aa93574fc6b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e24df0f5e944db63557c76d842adaea0611a2db4f11995e6015b5833a7e5c413"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08b2aa292f3d184f80641ea113377560bf4deb53d57917d47d465c8d83d31ee0"
    sha256 cellar: :any_skip_relocation, sonoma:        "528e71003008249ffe5a223a19d907a1bb5824b3ac79b4259207ec5a383a10c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4090ec34db1f2adf0551130c9525d711ac946f4ae7ed32ff2b141a7b995a2e34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50809d746d764e3bc7fe3954940d346ed4ae8f9edaada74fc27dc046d19a7fa0"
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
    url "https://files.pythonhosted.org/packages/2c/ee/afaf0f85a9a18fe47a67f1e4422ed6cf1fe642f0ae0a2f81166231303c52/wcwidth-0.7.0.tar.gz"
    sha256 "90e3a7ea092341c44b99562e75d09e4d5160fe7a3974c6fb842a101a95e7eed0"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
