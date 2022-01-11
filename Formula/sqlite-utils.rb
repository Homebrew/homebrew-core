class SqliteUtils < Formula
  include Language::Python::Virtualenv
  desc "CLI utility for manipulating SQLite databases"
  homepage "https://sqlite-utils.datasette.io/"
  url "https://files.pythonhosted.org/packages/a2/dc/7fc77ea5ed8789a67af69c11542350f8b85c149a0156ca5769019ae79d15/sqlite-utils-3.21.tar.gz"
  sha256 "0546476a9dca7e983f73e898347445c5c93ba745137b48a2670490b650c1612f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9cab7a564800ad2b6b06883e6162add83b38aace7bb31102312983b038f32c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "00ed40ea34cdee623e374d1af69f36390ea3119d6a496d7567a73ec2f8dae031"
    sha256 cellar: :any_skip_relocation, monterey:       "07357e84423cfe7bd6fbbdb25d434c9f41070c2eddaff6e848a796f8466914d5"
    sha256 cellar: :any_skip_relocation, big_sur:        "81f79e5a7418038a7b9bcc4b68c2e74b8c866d7ac0b0be1284e1b36a398f3221"
    sha256 cellar: :any_skip_relocation, catalina:       "25c14157652400a58c9c1223b84971fdb1aa73bf746a91f1f9568ef892657898"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7bde3509aeaecf497be028f70433c2c9800b66f9a5a4434cc810ec531865003"
  end

  depends_on "python-tabulate"
  depends_on "python@3.9"
  depends_on "six"

  resource "click" do
    url "https://files.pythonhosted.org/packages/f4/09/ad003f1e3428017d1c3da4ccc9547591703ffea548626f47ec74509c5824/click-8.0.3.tar.gz"
    sha256 "410e932b050f5eed773c4cda94de75971c89cdb3155a72a0831139a79e5ecb5b"
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
