class SqliteUtils < Formula
  include Language::Python::Virtualenv
  desc "CLI utility for manipulating SQLite databases"
  homepage "https://sqlite-utils.datasette.io/"
  url "https://files.pythonhosted.org/packages/73/4f/a652fe1b36ac71f7f7bd85219f233d3619f327efcfe0a1c235b262a5ab53/sqlite-utils-3.35.tar.gz"
  sha256 "8f6fe7f8d12772cd5cf4594703a98dcd0c37c0fd6820dd20541ba74b9fca363a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34725ae562ed519bc6e326f12f1f306fa9ad922b00cc7037376e666bd3c73665"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dffabc5c395cf06f4b041bd34b13e7d216abc801c7399e668d8a9661d6558744"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5827bb2ab93ba6b17b8e68383683adb8f4c96cee9ba431781c301f7942f8db58"
    sha256 cellar: :any_skip_relocation, ventura:        "681ca901ebf5e4f5754f3f8f610e09026e75c5b5930395496fc82ee39fc0b5df"
    sha256 cellar: :any_skip_relocation, monterey:       "0febc2b516e39c75d3abcb93db2c6d685ab98188ff080c787b449b01d3d3f450"
    sha256 cellar: :any_skip_relocation, big_sur:        "d056df231fd8f5e61ae3f0998fd636f71fb8df04e5d6b41e2b8714164f62b9f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc4925dba76d62ac537f0facac529f4c4989d125f02ba705420acc17996d0815"
  end

  depends_on "python-tabulate"
  depends_on "python@3.11"
  depends_on "six"

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "click-default-group-wheel" do
    url "https://files.pythonhosted.org/packages/3d/da/f3bbf30f7e71d881585d598f67f4424b2cc4c68f39849542e81183218017/click-default-group-wheel-1.2.2.tar.gz"
    sha256 "e90da42d92c03e88a12ed0c0b69c8a29afb5d36e3dc8d29c423ba4219e6d7747"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/8a/42/8f2833655a29c4e9cb52ee8a2be04ceac61bcff4a680fb338cbd3d1e322d/pluggy-1.2.0.tar.gz"
    sha256 "d12f0c4b579b15f5e054301bb226ee85eeeba08ffec228092f8defbaa3a4c4b3"
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
