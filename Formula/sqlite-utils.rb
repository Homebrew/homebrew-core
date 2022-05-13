class SqliteUtils < Formula
  include Language::Python::Virtualenv
  desc "CLI utility for manipulating SQLite databases"
  homepage "https://sqlite-utils.datasette.io/"
  url "https://files.pythonhosted.org/packages/0f/1d/552a8c712e9c1bf30fbd2a16889202b65c44726176975e6cef6664308912/sqlite-utils-3.26.1.tar.gz"
  sha256 "18aff4dface28ce4a2f4859948589f5eb7b163c772a3a71fc16c9a174eb1f367"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "beac92df77327ed97ac976e23e656b64e71886d6304f5fe99a84fdc055e7399f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc3a7801dec69eb25c2570400933a1892ff98e12c93a8eb4d86b21021a34456d"
    sha256 cellar: :any_skip_relocation, monterey:       "13f12ac5373a09d2575b037eef8431a14dbcf107fae14194a282d827bfbad376"
    sha256 cellar: :any_skip_relocation, big_sur:        "11152041a795d1c13c04e94ddb3ec70a676604a23dfc5dcdca61b119520f508e"
    sha256 cellar: :any_skip_relocation, catalina:       "7f9c82ccd6df0065427b0d6b17c78ecf378b57aa9b189e706b2f3fc154cefffb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab1b8552e1075ddba5fee7ac1254efa358858dc19b63ba866b81406e52df7ec4"
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
