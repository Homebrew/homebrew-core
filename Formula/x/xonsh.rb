class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  homepage "https://xon.sh"
  url "https://files.pythonhosted.org/packages/72/98/4b0e0a76fb3588f0cc9fff7a3be803965a55cc82d4434f8c334c47f701f9/xonsh-0.23.5.tar.gz"
  sha256 "37f5f7162b9941f4668c4d5a632030971ec0f5e58a40a57d67091bd7446bc178"
  license "BSD-2-Clause-Views"
  head "https://github.com/xonsh/xonsh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d903a9199123e732420516814f8e332eb3fb28c4aa3a3b3c19191c872de079a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5cbcef18689472a8afc12202ae576cff3959f7cc583eb10f9a08e4ec6e52b908"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6413bd18cca913200f5c42f7e7586c91d0888129fd0e6d4e8fafed3c6b29299d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0c197639566728b2b2c72865ca92446a8b75b44825616f708f6b3530b67513b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89b0a8ad8946330070bc6fe398e7ee72cd87380d766be314ed3a1a8e09cfb28a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "430078ba3317a2ae7f651a98563ea19c8bf9583609c85e9b31522d69e7104f9f"
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
