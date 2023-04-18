class SolcSelect < Formula
  include Language::Python::Virtualenv

  desc "Manage multiple Solidity compiler versions"
  homepage "https://github.com/crytic/solc-select"
  url "https://files.pythonhosted.org/packages/47/75/9355ad75576d94b59383b62d70e403868512639c3fe3290594cdf0a53dab/solc-select-1.0.3.tar.gz"
  sha256 "f39d08035355bd0e0a887e4a1088ea10a15dd64e4408cc7fcd72d913b46fc799"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/solc-select.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "20feef6767426974c7df2833b9490c51c2466ae918ae6d7dc50b9e31b2388f70"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e03cbce68b09330067837d9d10c4ff73bfb26ef450d98c08c8aa30be8459fb88"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5792ae00a342be21cccee47d416f6b491b51136724fa9f4982989d093e51ac60"
    sha256 cellar: :any_skip_relocation, ventura:        "fc801e674d1a651b5410248bb80451bd51f589ead811fb5defcdc73def05f535"
    sha256 cellar: :any_skip_relocation, monterey:       "05b87705edaad6bee3fd30d88ef085dfab843b4bcd0994b60eb1e979a97bfc8b"
    sha256 cellar: :any_skip_relocation, big_sur:        "0ec8669cedeb0f26fcaff7cc49bc1a87f5e6f1a79b3e426660ec5f9e6e21f888"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d818396e0ef942ea69441301b0c42b4d5e33c9954bbf79068f22c4c3a5625c5"
  end

  depends_on "python@3.11"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/47/d5/aca8ff6f49aa5565df1c826e7bf5e85a6df852ee063600c1efa5b932968c/packaging-23.0.tar.gz"
    sha256 "b6ad297f8907de0fa2fe1ccbd26fdaf387f5f47c7275fedf8cce89f99446cf97"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/b8/2e/cf9cfd1ae6429381d3d9c14c8df79d91ae163929972f245a76058ea9d37d/pycryptodome-3.17.tar.gz"
    sha256 "bce2e2d8e82fcf972005652371a3e8731956a0c1fbb719cc897943b3695ad91b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"solc-select", "install", "0.5.7"
    system bin/"solc-select", "install", "0.8.0"
    system bin/"solc-select", "use", "0.5.7"

    assert_match(/0\.5\.7.*current/, shell_output("#{bin}/solc-select versions"))

    # running solc itself requires an Intel system or Rosetta
    return if Hardware::CPU.arm?

    assert_match("0.5.7", shell_output("#{bin}/solc --version"))
    with_env(SOLC_VERSION: "0.8.0") do
      assert_match("0.8.0", shell_output("#{bin}/solc --version"))
    end
  end
end
