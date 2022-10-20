class SolcSelect < Formula
  include Language::Python::Virtualenv

  desc "Manage multiple Solidity compiler versions"
  homepage "https://github.com/crytic/solc-select"
  url "https://files.pythonhosted.org/packages/2f/ac/9b4eab45a899a558d186c1d6830997d35392d15477b083b71c26612e02d7/solc-select-1.0.1.tar.gz"
  sha256 "46c4e727f4fd5e24cd94972a8082282aff19f300ca6be5b074a1d98453ccd508"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/solc-select.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58332fbddcae9d646bc115b473701b63c2930c01c7fbe4528fa39e5bb6e222ab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1cb65ca6617915b7b9b7df8478e678caaba95264d843ffaef70a318376e0e514"
    sha256 cellar: :any_skip_relocation, monterey:       "c59e863b4b0490857d03983ee539ed698028fbb28c424512bd7e7523d1716bea"
    sha256 cellar: :any_skip_relocation, big_sur:        "0696f323f0ca3df4489447ddc65656a24b197392ea2e3a5ff73d942f5bbabfef"
    sha256 cellar: :any_skip_relocation, catalina:       "051012ef46fea07febd1cffac98349c962c5fa30ee8e69e9b34d89f5a5d53cfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b57babab8950784ea0e3a165dacced2df2cb8c84c020b5262e7c37adcde3043"
  end

  depends_on "python@3.10"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "pysha3" do
    url "https://files.pythonhosted.org/packages/73/bf/978d424ac6c9076d73b8fdc8ab8ad46f98af0c34669d736b1d83c758afee/pysha3-1.0.2.tar.gz"
    sha256 "fe988e73f2ce6d947220624f04d467faf05f1bbdbc64b0a201296bb3af92739e"
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
