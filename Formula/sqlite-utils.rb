class SqliteUtils < Formula
  include Language::Python::Virtualenv
  desc "CLI utility for manipulating SQLite databases"
  homepage "https://sqlite-utils.datasette.io/"
  url "https://files.pythonhosted.org/packages/99/48/b974a270fd710e62c5ab863dc216cf3ffe26b5108ffb5d64ddeba1786bce/sqlite-utils-3.33.tar.gz"
  sha256 "be779936dadb9decef511a46f280bd94683d385625f69a65730fb6e00e5f2656"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "21ff4b5101f921a5735ed0516462c4120b120229455cd5eefecc03a2dd6c9fef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4393f8a01234dcfef7fee114a693428054b8628945ee477863213d7b42798743"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0a8f42fd50ee8b66086cc0e84e650ca7dd52a8e64715db8f47d618eca8cb475a"
    sha256 cellar: :any_skip_relocation, ventura:        "3bc45523a85114375706c0a274877cc96cd3ea7fd28f647f2240b641edcaa95f"
    sha256 cellar: :any_skip_relocation, monterey:       "13350d47ba6fa260505c7132ff78088895d8f0827d807d3c74431581c70497f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "188afa872873fb735b4f74c431a0f0bcebbabfaabe77f6382b33a59aa5bcf23c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e6b848eb0ad4ed0e457771cdf0dbda2513df10cad8b3a6fc821b542207521fb"
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
