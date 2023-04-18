class SqliteUtils < Formula
  include Language::Python::Virtualenv
  desc "CLI utility for manipulating SQLite databases"
  homepage "https://sqlite-utils.datasette.io/"
  url "https://files.pythonhosted.org/packages/ba/8d/9660dc531135779a1980e670d78d1402506e02fc1aaa10556da6ecf9960c/sqlite-utils-3.30.tar.gz"
  sha256 "30005c12d5f13445659f791766beb6a9900c25f442bea1f980f21d38b75f6e33"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "55850547f3febd675a4e44a91af5727c940c88f47e4fb67067328ed7e6627437"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64d444fd747d0040308c1e104a80776e95b1021701f64c02eae476218ff1d522"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa24e30b8347de7847c9781280854d22dd158e4085a7af140b0a8836e714e916"
    sha256 cellar: :any_skip_relocation, ventura:        "2c75997b14d75724dfea196e5753ce4189e3385dbc8165debd9f982c8603940c"
    sha256 cellar: :any_skip_relocation, monterey:       "0b38cb7ec0e555c0f98e8d54cfb9a8976dc54b262af356cbfad8035798bf1de3"
    sha256 cellar: :any_skip_relocation, big_sur:        "df113a755159beb5af5c77baefd06f8753c3c92a5d909bd77dcfc7d8f7fe6acf"
    sha256 cellar: :any_skip_relocation, catalina:       "0e5134f6bc6e4a6ebb273ec8185061091ea77bdec7e259c93c1f09ede4a81681"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bb704e7f9a703bd9d8b2eb00d095d063ff9be13c5af7a15cb90cc1e0fcc73db"
  end

  depends_on "python-tabulate"
  depends_on "python@3.11"
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
    url "https://files.pythonhosted.org/packages/c2/6d/9dad6c3b433ab8912ace969c66abd595f8e0a2ccccdb73602b1291dbda29/sqlite-fts4-1.0.3.tar.gz"
    sha256 "78b05eeaf6680e9dbed8986bde011e9c086a06cb0c931b3cf7da94c214e8930c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "15", shell_output("#{bin}/sqlite-utils :memory: 'select 3 * 5'")
  end
end
