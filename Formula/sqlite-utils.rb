class SqliteUtils < Formula
  include Language::Python::Virtualenv
  desc "CLI utility for manipulating SQLite databases"
  homepage "https://sqlite-utils.datasette.io/"
  url "https://files.pythonhosted.org/packages/e2/0a/05a5b66f2ee7d521a4c6da78c8d07b1570299cc0fce03a1f6b5c34ffa278/sqlite-utils-3.18.tar.gz"
  sha256 "3e86d8dd5f633c4bcf78c4e1a3aa5b0f02852a602cea8134b700229598109ff6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e94feef0e5009d8711f2351f5c4c76b7cb4930b571c9c8281facf80b8aa5d28c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "80ca20fc8e828fe2a303d934a706e55f42ea18692f12d5f378fb88895b3d3fb3"
    sha256 cellar: :any_skip_relocation, monterey:       "a9cd04b68cb385f52a1b440c26474972cdf4eb965aa6e24a209706815b8c35eb"
    sha256 cellar: :any_skip_relocation, big_sur:        "89adb3623815c841261f89d741efb244a12e4b48d155b5fb8b8dd2dd7d4ed01a"
    sha256 cellar: :any_skip_relocation, catalina:       "ab74fd5336ddf14a00ee6203d465e284d2bda2917bf7fad3f2bb502a94387bf1"
    sha256 cellar: :any_skip_relocation, mojave:         "fbbde2ddbf4f2cc628f518ec29f3a879168b93e0f1587936cc6e1623e5078011"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "338292c0c7ce10e33afa5b310a419834a1d95c9e508adbe91d91074a6184702a"
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
