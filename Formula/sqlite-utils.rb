class SqliteUtils < Formula
  include Language::Python::Virtualenv
  desc "CLI utility for manipulating SQLite databases"
  homepage "https://sqlite-utils.datasette.io/"
  url "https://files.pythonhosted.org/packages/0f/1d/552a8c712e9c1bf30fbd2a16889202b65c44726176975e6cef6664308912/sqlite-utils-3.26.1.tar.gz"
  sha256 "18aff4dface28ce4a2f4859948589f5eb7b163c772a3a71fc16c9a174eb1f367"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f220eee4c216d1cf09592cf660034d800fa0c906de70cb96c329139870a5d54b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "636effae9dee601919cc13419dcd601f931b985d4cecb60499ec3a596db5ff79"
    sha256 cellar: :any_skip_relocation, monterey:       "3be42b978c28185805287f801da810220b69b1bd0b320c46dff088f490b15730"
    sha256 cellar: :any_skip_relocation, big_sur:        "08528c95e3502998e88c3dd3b091061d908f6bd588eb24bfc0db3960b83508d0"
    sha256 cellar: :any_skip_relocation, catalina:       "6b5ed53931280d55678e127c99272155a27c27b8b1d68f59966c9a1c06f4dc66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "164ae6e4625d60d0ef294e4cba1a63faf90ed463564fbea95ecc4b59c313ef6c"
  end

  depends_on "python-tabulate"
  depends_on "python@3.9"
  depends_on "six"

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "click-default-group-wheel" do
    url "https://files.pythonhosted.org/packages/3d/da/f3bbf30f7e71d881585d598f67f4424b2cc4c68f39849542e81183218017/click-default-group-wheel-1.2.2.tar.gz"
    sha256 "e90da42d92c03e88a12ed0c0b69c8a29afb5d36e3dc8d29c423ba4219e6d7747"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "sqlite-fts4" do
    url "https://files.pythonhosted.org/packages/62/30/63e64b7b8fa69aabf97b14cbc204cb9525eb2132545f82231c04a6d40d5c/sqlite-fts4-1.0.1.tar.gz"
    sha256 "b2d4f536a28181dc4ced293b602282dd982cc04f506cf3fc491d18b824c2f613"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "15", shell_output("#{bin}/sqlite-utils :memory: 'select 3 * 5'")
  end
end
