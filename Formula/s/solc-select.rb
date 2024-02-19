class SolcSelect < Formula
  include Language::Python::Virtualenv

  desc "Manage multiple Solidity compiler versions"
  homepage "https://github.com/crytic/solc-select"
  url "https://files.pythonhosted.org/packages/60/a0/2a2bfbbab1d9bd4e1a24e3604c30b5d6f84219238f3c98f06191faf5d019/solc-select-1.0.4.tar.gz"
  sha256 "db7b9de009af6de3a5416b80bbe5b6d636bf314703c016319b8c1231e248a6c7"
  license "AGPL-3.0-only"
  revision 2
  head "https://github.com/crytic/solc-select.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c761c0fe379780b6e8559f147d19963504e732659a5e22500e5c63c832ddb814"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "224fa6b5867da53f335a6904a4d57d23bd16f319704c46beb70f147c12c83ee9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a6ab901b4cd0b4148bf882ff89df6286d8da54eb4d4a88779ee35a2d5e7a389"
    sha256 cellar: :any_skip_relocation, sonoma:         "a939ce9b804482c9427819a691af871ff76cdf8675c5c3515b1e793d660b216d"
    sha256 cellar: :any_skip_relocation, ventura:        "bbade1d56f170967e3ed0db9bea6b25b5133a8ee0668631a7865985f3455c897"
    sha256 cellar: :any_skip_relocation, monterey:       "1378a57f59656f0009a769840c6f01a86651d4977cea4535bdafa253e0e8ace9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0062de8a36483fdb650228db8b526cbd48d2212c274e960db52c453ac0ad773f"
  end

  depends_on "python-packaging"
  depends_on "python@3.12"

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/b1/38/42a8855ff1bf568c61ca6557e2203f318fb7afeadaf2eb8ecfdbde107151/pycryptodome-3.19.1.tar.gz"
    sha256 "8ae0dd1bcfada451c35f9e29a3e5db385caabc190f98e4a80ad02a61098fb776"
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
