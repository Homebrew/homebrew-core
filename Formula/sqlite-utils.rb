class SqliteUtils < Formula
  include Language::Python::Virtualenv
  desc "CLI utility for manipulating SQLite databases"
  homepage "https://sqlite-utils.datasette.io/"
  url "https://files.pythonhosted.org/packages/25/74/8b01977bdb32a8296584943ee23495b1f0154257b50c3b094f76be17ed41/sqlite-utils-3.17.tar.gz"
  sha256 "77acd202aa568a1f6888c5d8879f306bb3f8acedc82df0df98eb615caa491abb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e41a7a9ea04dc5ae11597f29874d0a98ded3055de10ceb3322534da1048a9907"
    sha256 cellar: :any_skip_relocation, big_sur:       "a11f9a5a5da4a1f52c65a0782d0a6a67170c281cfa80e7bbf1005eead2143c11"
    sha256 cellar: :any_skip_relocation, catalina:      "638298385470b6313b963fb3fcc4ae1e4e12c4ceaa13cfb44b5e6800f0911736"
    sha256 cellar: :any_skip_relocation, mojave:        "1c537fe06650a51b528fad3993a3452fea2647141a15b4fdc1e763997db51452"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e211973d28732feda17a5f2fbf97a5f73b350e437fd24f281df4c62f9d1318c1"
  end

  depends_on "python-tabulate"
  depends_on "python@3.9"
  depends_on "six"

  resource "click" do
    url "https://files.pythonhosted.org/packages/21/83/308a74ca1104fe1e3197d31693a7a2db67c2d4e668f20f43a2fca491f9f7/click-8.0.1.tar.gz"
    sha256 "8c04c11192119b1ef78ea049e0a6f0463e4c48ef00a30160c704337586f3ad7a"
  end

  resource "click-default-group" do
    url "https://files.pythonhosted.org/packages/22/3a/e9feb3435bd4b002d183fcb9ee08fb369a7e570831ab1407bc73f079948f/click-default-group-1.2.2.tar.gz"
    sha256 "d9560e8e8dfa44b3562fbc9425042a0fd6d21956fcc2db0077f63f34253ab904"
  end

  resource "dateutils" do
    url "https://files.pythonhosted.org/packages/70/2e/a2d1337ac0ebb32b3b4ad921d9621f8b2f6bb20de0da47ec5d3734f08ce2/dateutils-0.6.12.tar.gz"
    sha256 "03dd90bcb21541bd4eb4b013637e4f1b5f944881c46cc6e4b67a6059e370e3f1"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/b0/61/eddc6eb2c682ea6fd97a7e1018a6294be80dba08fa28e7a3570148b4612d/pytz-2021.1.tar.gz"
    sha256 "83a4a90894bf38e243cf052c8b58f381bfe9a7a483f6a9cab140bc7f702ac4da"
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
