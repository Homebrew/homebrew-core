class SolcSelect < Formula
  include Language::Python::Virtualenv

  desc "Manage multiple Solidity compiler versions"
  homepage "https://github.com/crytic/solc-select"
  url "https://files.pythonhosted.org/packages/e0/55/55b19b5f6625e7f1a8398e9f19e61843e4c651164cac10673edd412c0678/solc_select-1.1.0.tar.gz"
  sha256 "94fb6f976ab50ffccc5757d5beaf76417b27cbe15436cfe2b30cdb838f5c7516"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/solc-select.git", branch: "dev"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "caf2f6be75f5d5796e2c42581153686e3a4b72d7b87a96e1a0eb5ca50b9baeee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10d842a9ebe4e794cf8ccbee0682247f5e2da73a020c36299ddab1dc7a8a7747"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "104b8f03d5680d6b544698d3bab2bbfeed2770ff47f72ae3a5452da3c1c47cb7"
    sha256 cellar: :any_skip_relocation, sonoma:        "b901cd7ab4d132307657a069e2ae276d2fb2e3b47b061e60efc10568eccfdcc1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3848794703a208f7af56f96d4028ac3e208cf8dcf4cf7d6312dfa64c6ea19a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "303414ce44b6df5584610fbf09cdb1033f87fd48ad43ff2b0cf324e6a1531c4a"
  end

  depends_on "python@3.14"

  conflicts_with "solidity", because: "both install `solc` binaries"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/8e/a6/8452177684d5e906854776276ddd34eca30d1b1e15aa1ee9cefc289a33f5/pycryptodome-3.23.0.tar.gz"
    sha256 "447700a657182d60338bab09fdb27518f8856aecd80ae4c6bdddb67ff5da44ef"
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
