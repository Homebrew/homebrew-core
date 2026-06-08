class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  homepage "https://xon.sh"
  url "https://files.pythonhosted.org/packages/8b/77/0c4c39ad866d4ea1ef553f325d16e804d1bf1eeecc591f0e81b057aa37db/xonsh-0.23.8.tar.gz"
  sha256 "541bb976c93a81571792644403bae8737145023da5f48d4c493909ab5c04ba0f"
  license "BSD-2-Clause-Views"
  head "https://github.com/xonsh/xonsh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "117a34339e2145346e8cfc02e12138636d5aac72bb952b6737a4ef88b0c53cb2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ca2894ab2b6a7b5f875981b3a3a6deef15a92aff0c01a951d369ba56076abf0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ffd902e996296d574513eaaf7be705c42dd93793bca071d4570f341e583b16ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "73ef1a7996f23e9d30d23fa46994ada10f2ad3d4e76ea9c81c42a25703a5fa84"
    sha256 cellar: :any,                 arm64_linux:   "0aec392a1a35bba4df55b466e77d6cd2b80af52e1dd1a72558603731f2add008"
    sha256 cellar: :any,                 x86_64_linux:  "427aa6e900de4b3cd461fb95795f5abcab902972687c3b41bd4f28ab079c5183"
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
