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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dcf2eda0e30f6361041ed6d3a9cf058c0621ac9b3aaf32953c6cb5f3bb321378"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3a72a574989a15328910c3339eb1840aba5b7a84375859ca0bd6835d96b16b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c7d8c394a4831a52da179c98fc476386433dcd18205314b0f9bd21b63600609"
    sha256 cellar: :any_skip_relocation, sonoma:         "0af1d0beb9c4c438b2c2983bc6e8598997417da0e7e4971a2f2d706d1c5fcb92"
    sha256 cellar: :any_skip_relocation, ventura:        "b699007b5b946854167d61d4973d658277ec09da13efc8d7888813faec4295d2"
    sha256 cellar: :any_skip_relocation, monterey:       "34f1dc7cffa7cb317316d6a00e0d44dc8e34b9395974062e7be8abf26575a7f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01ef9d77fd4f6823091b8a867632c9c5b935c0d0458bd104824eb28deb49e9cd"
  end

  depends_on "python@3.12"

  conflicts_with "solidity", because: "both install `solc` binaries"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

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
