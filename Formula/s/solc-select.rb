class SolcSelect < Formula
  include Language::Python::Virtualenv

  desc "Manage multiple Solidity compiler versions"
  homepage "https://github.com/crytic/solc-select"
  url "https://files.pythonhosted.org/packages/60/a0/2a2bfbbab1d9bd4e1a24e3604c30b5d6f84219238f3c98f06191faf5d019/solc-select-1.0.4.tar.gz"
  sha256 "db7b9de009af6de3a5416b80bbe5b6d636bf314703c016319b8c1231e248a6c7"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/solc-select.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33c9c5baba1102e62d30fe93d47e0ae3c88e1264880a365afd794000281c9191"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e81a047baa31cc208e54317b5a6dfa3a9259b306a4f71c2fc7db6bba12636782"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b4ddd9ff9c92f38908bfd92bc6cba18788afb24c8514c859a917806c5877147e"
    sha256 cellar: :any_skip_relocation, ventura:        "aff06bba18ec3b7294a317c1bf8b282ee421cf70f8ac361d6c08044346bcc36a"
    sha256 cellar: :any_skip_relocation, monterey:       "89637261e8e0a45d698008c28b2937fbc5050410450ae1320caadee01515d56f"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce63982a9ba547fe60daba1adf434e1decfa7f463c0795bbb75464ac27650d53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b78982e23ddd3d162e641bc3a0071fccc6291716ac2833e5215a17df892a102e"
  end

  depends_on "python@3.11"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

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
