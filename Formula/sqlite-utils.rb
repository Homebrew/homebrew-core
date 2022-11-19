class SqliteUtils < Formula
  include Language::Python::Virtualenv
  desc "CLI utility for manipulating SQLite databases"
  homepage "https://sqlite-utils.datasette.io/"
  url "https://files.pythonhosted.org/packages/ba/8d/9660dc531135779a1980e670d78d1402506e02fc1aaa10556da6ecf9960c/sqlite-utils-3.30.tar.gz"
  sha256 "30005c12d5f13445659f791766beb6a9900c25f442bea1f980f21d38b75f6e33"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5495bc587ebc8b58a3793bdd669d4a4455ec1b4b982b00ceae11c3bbeaeac4de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b15dd4b77ad67b00182ab624937d605dbb69384cf56cbb33dd7a6678025d1e32"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8cd2aef4430857b9098fd71655481e63de0e210936c543385bc51e3171ae565d"
    sha256 cellar: :any_skip_relocation, ventura:        "50f12af12483241309138eac5d3f9aaa41ffa8fbf945a3edd71706b621778f27"
    sha256 cellar: :any_skip_relocation, monterey:       "ea5cb1cccd49f94a6ea02760f94b7165da0f7c2270935425dfe4795ba66cca95"
    sha256 cellar: :any_skip_relocation, big_sur:        "46814e30f25e588a9d88be1e414dc8df08850a08678f067b311048c052ebe51c"
    sha256 cellar: :any_skip_relocation, catalina:       "41b7f5849c66845a8216434fd4b6b0dd4a112e111138db7597ecc8db530c68d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe8b5518af041b66e3ece458fcf37134a1f3a9c270a52bb9bbec81f307dd7c38"
  end

  depends_on "libpython-tabulate"
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
