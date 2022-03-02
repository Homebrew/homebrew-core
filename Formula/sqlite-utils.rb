class SqliteUtils < Formula
  include Language::Python::Virtualenv
  desc "CLI utility for manipulating SQLite databases"
  homepage "https://sqlite-utils.datasette.io/"
  url "https://files.pythonhosted.org/packages/e8/a7/303f09589b916e0ad96906aea5f85311d520514212d364ea1fad0db3de60/sqlite-utils-3.25.tar.gz"
  sha256 "38a970b97c17194d9605ab84df749802e1f3bcf06135dc180779d0a39576b142"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "179eb92a600e18104c93bd36c22d3febc28f676a0fa8acb94d51383b6c1fe8bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae1da8bfcf8c55ffad298aa601664f4b998f86172a17e84e635832f1710ad3b7"
    sha256 cellar: :any_skip_relocation, monterey:       "19395b017a6138868fc1d0810e70ffa5214f4da2e81a6712babd4f79f6f8e54b"
    sha256 cellar: :any_skip_relocation, big_sur:        "a43578ebc00b40941ea94ade6704dd346df5a1477579f37cccf933ac9deb6722"
    sha256 cellar: :any_skip_relocation, catalina:       "793191feb407cff741aee9b1fceda90902b44dabe3418e33950950183b1eee3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b342ca8c00bfd4b0584b23aedf0622561af2b055e3bf9135eee2f82da58f0dec"
  end

  depends_on "python-tabulate"
  depends_on "python@3.9"
  depends_on "six"

  resource "click" do
    url "https://files.pythonhosted.org/packages/dd/cf/706c1ad49ab26abed0b77a2f867984c1341ed7387b8030a6aa914e2942a0/click-8.0.4.tar.gz"
    sha256 "8458d7b1287c5fb128c90e23381cf99dcde74beaf6c7ff6384ce84d6fe090adb"
  end

  resource "click-default-group" do
    url "https://files.pythonhosted.org/packages/22/3a/e9feb3435bd4b002d183fcb9ee08fb369a7e570831ab1407bc73f079948f/click-default-group-1.2.2.tar.gz"
    sha256 "d9560e8e8dfa44b3562fbc9425042a0fd6d21956fcc2db0077f63f34253ab904"
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
