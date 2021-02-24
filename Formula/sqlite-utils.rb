class SqliteUtils < Formula
  include Language::Python::Virtualenv
  desc "CLI utility for manipulating SQLite databases"
  homepage "https://sqlite-utils.datasette.io/"
  url "https://files.pythonhosted.org/packages/0d/7e/111bde53d3f4c4f03152963086a28aa11ea5536c6980f64b48eff43d7c7d/sqlite-utils-3.6.tar.gz"
  sha256 "582a9bcf4b6cb32ee2efa4a0d8f79ec630e8965ca93c69ceaaa7d424e1c01560"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9e37e4cee6496ffc04f0baa54e9cd053be627329cbae5a1c3e9cfb31bd8a2b25"
    sha256 cellar: :any_skip_relocation, big_sur:       "f44bcf9d53ce1f616563ecebaa46a56fd5c5b67496980c20bdc957b11b10f01e"
    sha256 cellar: :any_skip_relocation, catalina:      "19086ce7bce1db596f95a2c9c56b256a4a4a455daaf40a2050803cafba883fc2"
    sha256 cellar: :any_skip_relocation, mojave:        "e2ab94b6a41c963426c3bd51107625871ce931d788674d1c32791ff20a9ce0db"
  end

  depends_on "python@3.9"

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "click-default-group" do
    url "https://files.pythonhosted.org/packages/22/3a/e9feb3435bd4b002d183fcb9ee08fb369a7e570831ab1407bc73f079948f/click-default-group-1.2.2.tar.gz"
    sha256 "d9560e8e8dfa44b3562fbc9425042a0fd6d21956fcc2db0077f63f34253ab904"
  end

  resource "sqlite-fts4" do
    url "https://files.pythonhosted.org/packages/62/30/63e64b7b8fa69aabf97b14cbc204cb9525eb2132545f82231c04a6d40d5c/sqlite-fts4-1.0.1.tar.gz"
    sha256 "b2d4f536a28181dc4ced293b602282dd982cc04f506cf3fc491d18b824c2f613"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/69/44/6c7326b95268c16cf8dc1376ed1a4f404fa9fd04c1371c0917d3f2806832/tabulate-0.8.8.tar.gz"
    sha256 "26f2589d80d332fefd2371d396863dedeb806f51b54bdb4b264579270b621e92"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "15", shell_output("#{bin}/sqlite-utils :memory: 'select 3 * 5'")
  end
end
