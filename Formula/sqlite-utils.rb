class SqliteUtils < Formula
  include Language::Python::Virtualenv
  desc "CLI utility for manipulating SQLite databases"
  homepage "https://sqlite-utils.datasette.io/"
  url "https://files.pythonhosted.org/packages/1a/95/b6fe852980c9494bf8a5e99d017cc6b864f9807a3e082c7837c267302217/sqlite-utils-3.32.1.tar.gz"
  sha256 "6c28fe32fcebd658a1691dedfa4d111499ad302cc0139c5a5893a590d461848a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f405006eb021d8903c9a654accaef05494dc83a9610c7f0354a9e8aa01fa2b30"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e8a8796dadb0b11020fa5c905944af70e6d1eadd794f043d3019e585910488f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41aaf30e5c0598f526add6cf897bfa829d57d90233e82645ad614dbba0ca16de"
    sha256 cellar: :any_skip_relocation, ventura:        "f5dd279f6a6066ff1048d0d35e14e20b9866315c5b5ea532dba5029d13344904"
    sha256 cellar: :any_skip_relocation, monterey:       "208ae33f4a96bee6f41bb0205150c69f6226b33d007b665815a9deb77a7325f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "df0a6295a2592ef67619e4f7328d2957ea4e44175181c7ea7adb6795cf177637"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31fe70e61cf0532acf34ab704e07cbe334eeca3d9dfc7f784d8704ca1e88b889"
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
