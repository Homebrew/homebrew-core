class SqliteUtils < Formula
  include Language::Python::Virtualenv
  desc "CLI utility for manipulating SQLite databases"
  homepage "https://sqlite-utils.datasette.io/"
  url "https://files.pythonhosted.org/packages/e8/da/6f34fd782e805f275ac17ecaba247db6c53eeaf340907c0e536366b6de1b/sqlite-utils-3.31.tar.gz"
  sha256 "54989f3d09ed121f9df97831d041738ae48771d3ca85008946f1bc1884109a8a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a1442e1c3e1fca47d1287ee31e6c9508c16a761c10d84af8d2a4a261078f401c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "453edd03df3f5122f2b28c7d215caf71e070be649928c5ae1e0a5ed3f3a77783"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e94d6015d27f873e14eb68c6d140499e77823a6de20615d362a8632a466ac69"
    sha256 cellar: :any_skip_relocation, ventura:        "d5cc1db8b0de304bb2a3b79145a5ecde3fff4f96def435264d25311b6b1ad29b"
    sha256 cellar: :any_skip_relocation, monterey:       "322aa7aaf96a26a8899ef7d3d38da29b50579266798cb7fc0ebec561b1d42dcc"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c9119cfd437a533d7e5183bfa11978dd10d6a597394702a7791c89e835d26f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "633d254e48761699750fe67de18fadd0b3c54886389f347711b98c33ef0db781"
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
