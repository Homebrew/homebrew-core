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
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d0661908ba920dc4a4de4ea3eb27914ec0405b8adaf35cfa77bde266a1575f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94b9be9265dbfc2de30db81960d6940539f91820f3367776174221b86d4cc682"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "509c18ea54308f169f3ddb2d0bdba7d6442dc7283502f727ef5711dec262d95d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6d96ebed3035abd3c66142cbba68a650370d3db324c1d931841f268733fa7aa"
    sha256 cellar: :any_skip_relocation, ventura:       "7367e876b2ee383d66a91d944aca60b4882d23e835cdc16c9f7d748f14c28717"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "138ad09ef8f2a22eb9b254ae878cad4f3bbd7132dea5b1f1be418365d9ac8390"
  end

  depends_on "python@3.13"

  conflicts_with "solidity", because: "both install `solc` binaries"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/13/52/13b9db4a913eee948152a079fe58d035bd3d1a519584155da8e786f767e6/pycryptodome-3.21.0.tar.gz"
    sha256 "f7787e0d469bdae763b876174cf2e6c0f7be79808af26b1da96f1a64bcf47297"
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
