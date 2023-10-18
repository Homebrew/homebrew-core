class SolcSelect < Formula
  include Language::Python::Virtualenv

  desc "Manage multiple Solidity compiler versions"
  homepage "https://github.com/crytic/solc-select"
  url "https://files.pythonhosted.org/packages/60/a0/2a2bfbbab1d9bd4e1a24e3604c30b5d6f84219238f3c98f06191faf5d019/solc-select-1.0.4.tar.gz"
  sha256 "db7b9de009af6de3a5416b80bbe5b6d636bf314703c016319b8c1231e248a6c7"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/solc-select.git", branch: "dev"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9cf59601d61086ab74c165574fe513edbd9e8384cea4da76e805784e81b6e888"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea7c74ba5c8fa0ea57f08b655fce6afc11b10dd3ddf49aec2e5e5457c7e7d578"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "628441d6cf3a5731799d105fcbbd6662a6b031063f973678d6249c81ba905f6b"
    sha256 cellar: :any_skip_relocation, sonoma:         "f21bc3732eaa9a22c42a1bc14c5b88197cc30a6b4e985127a50358cb724d13bb"
    sha256 cellar: :any_skip_relocation, ventura:        "292547b1bcf3f1c0aea3e084971590ac267ed0a9b331e716dd6f415afe8907da"
    sha256 cellar: :any_skip_relocation, monterey:       "6a31497cfc757938cc08c0cd8d0644995c3111adc3c592bcba8ea1f1532f6ded"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb78e6c185f55ca77219476d4c728c40c9c36b36d0e1666980387840fecec4f2"
  end

  depends_on "python-packaging"
  depends_on "python@3.11"

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/b9/05/0e7547c445bbbc96c538d870e6c5c5a69a9fa5df0a9df3e27cb126527196/pycryptodome-3.18.0.tar.gz"
    sha256 "c9adee653fc882d98956e33ca2c1fb582e23a8af7ac82fee75bd6113c55a0413"
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
