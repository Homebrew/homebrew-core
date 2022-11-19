class SolcSelect < Formula
  include Language::Python::Virtualenv

  desc "Manage multiple Solidity compiler versions"
  homepage "https://github.com/crytic/solc-select"
  url "https://files.pythonhosted.org/packages/b0/be/778216e18bf50cf3d6b4fe77509700677de9ce01480a8a7dcbf3d778b586/solc-select-1.0.2.tar.gz"
  sha256 "ceba561d07680950c66831837fd7d686746c4ded46570aa4d6a96cd4fcaf94bc"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/solc-select.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f060023b1506f1a282d4f0b91e1a691757680a7f2c858a965bb803ad324ee72"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "35e57e18ac37ca3b35f8dc1cc6b87f2c774521dabc2e9eac85362d1184e88dd3"
    sha256 cellar: :any_skip_relocation, ventura:        "078f906ee71cf52cfe50aba5a0404f8d8063259e0072bea1223b63b4d3f92b61"
    sha256 cellar: :any_skip_relocation, monterey:       "fec9c711e24f2aa6fd3ec6cb0c61548da8e1ad2497911a522ce2112548926eca"
    sha256 cellar: :any_skip_relocation, big_sur:        "79cf18b7ac85a4f2685e532ddda52eefa5e28fdb916a87ce1269fcd11ac1c0b6"
    sha256 cellar: :any_skip_relocation, catalina:       "c686f9825271685051660c84c6d48cf25b9b1109f8fe5de1e4d864d9acb2a7ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ae84608d9ae072e478662e7dd672d14ea8ef9b688feb33814b642346dfb774e"
  end

  depends_on "python@3.10"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/11/e4/a8e8056a59c39f8c9ddd11d3bc3e1a67493abe746df727e531f66ecede9e/pycryptodome-3.15.0.tar.gz"
    sha256 "9135dddad504592bcc18b0d2d95ce86c3a5ea87ec6447ef25cfedea12d6018b8"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"solc-select", "install", "0.5.7"
    system bin/"solc-select", "install", "0.8.0"
    system bin/"solc-select", "use", "0.5.7"

    assert_match("0.5.7", shell_output("#{bin}/solc --version"))
    with_env(SOLC_VERSION: "0.8.0") do
      assert_match("0.8.0", shell_output("#{bin}/solc --version"))
    end
  end
end
