class SolcSelect < Formula
  include Language::Python::Virtualenv

  desc "Manage multiple Solidity compiler versions"
  homepage "https://github.com/crytic/solc-select"
  url "https://files.pythonhosted.org/packages/62/89/51e614fdbf26f47268c18f8a3b6cf1cb67c9a8b48b7b7231c948cae97814/solc_select-1.2.0.tar.gz"
  sha256 "ad0a7afcae05061ce5e7632950b1fa0193ba9eaf05e4956f86effee024c6fb07"
  license "AGPL-3.0-only"
  revision 4
  head "https://github.com/crytic/solc-select.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a3012899caad3e323736b685fedef4388d1cf407db53821fccffa752052e4221"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15e4b16098de3e78c20393b6fc06443f4278c126025691ed2a3d55ea1f31d63d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f33572626a35fa51561cdf80915c780a253694c80551ce4b04341e048b6e929c"
    sha256 cellar: :any_skip_relocation, sonoma:        "90ffe9a951528630034260b1ff8c4358da905c94cb04e7d593cb895b1be86b20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93afa1abc64233381b204b98bbc7525318ab56195e61dc541f34c8c77a901acd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ada0157323d0b6db6490b1cd02bf3abf5355986d13a31accdf77bfed00468f3"
  end

  depends_on "certifi" => :no_linkage
  depends_on "python@3.14"

  conflicts_with "solidity", because: "both install `solc` binaries"

  pypi_packages exclude_packages: "certifi"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/82/77/7b3966d0b9d1d31a36ddf1746926a11dface89a83409bf1483f0237aa758/idna-3.15.tar.gz"
    sha256 "ca962446ea538f7092a95e057da437618e886f4d349216d2b1e294abfdb65fdc"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/8e/a6/8452177684d5e906854776276ddd34eca30d1b1e15aa1ee9cefc289a33f5/pycryptodome-3.23.0.tar.gz"
    sha256 "447700a657182d60338bab09fdb27518f8856aecd80ae4c6bdddb67ff5da44ef"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/43/b8/7a707d60fea4c49094e40262cc0e2ca6c768cca21587e34d3f705afec47e/requests-2.34.0.tar.gz"
    sha256 "7d62fe92f50eb82c529b0916bb445afa1531a566fc8f35ffdc64446e771b856a"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
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
