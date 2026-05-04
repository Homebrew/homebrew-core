class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  homepage "https://xon.sh"
  url "https://files.pythonhosted.org/packages/ef/cd/35dc97e5b500d40bbe1345b74782ad10d43ffa0610035679e35ce78def55/xonsh-0.23.4.tar.gz"
  sha256 "05e60bbc9f2234f6482a96bfa8d936deb45c915e3f3fcfdc3056bfe32aa8d1cf"
  license "BSD-2-Clause-Views"
  head "https://github.com/xonsh/xonsh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "282cf71d0d03795bc341b963059531c2efa915f60a76c8a223453d0be2f9314a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97d072ceeb627892fe961909ba5da460660df0d1feaa4ebc6119daaa342b5b80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a217f1e6d089ae1e6ffd562c516dd53a60daf9a29c48068d994afeeab15ea0e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "71cf96758f6c90c29a1a8ea741e016c379e52c4d81b950af00431dee25f9e6e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33bf20ea7c1c7634bd1670448a1ddf489caf3935dc1839e085eb55bbb75473cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "768b140804cbc2afb30c0bd113fafc5fea395e674551f22160e15897dd2b58e9"
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
