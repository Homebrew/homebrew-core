class SqliteUtils < Formula
  include Language::Python::Virtualenv
  desc "CLI utility for manipulating SQLite databases"
  homepage "https://sqlite-utils.datasette.io/"
  url "https://files.pythonhosted.org/packages/a9/0b/65a77f38b10679c49d90c70306d5ec3211b0769494c952406c89b13b5af8/sqlite-utils-3.20.tar.gz"
  sha256 "8b3a5611875d4fb80e67358ca97eae5a29c2384437e9a468f334ed22e5d90387"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97a6e1c9b94df616f4ad41d92e66f97223079afd82ee0592b9e49308e6a3dad9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "683976c1cd5e759b6b2e3c65f23d25d1e5ce7b9836e3808a6d9bfa517e0e1880"
    sha256 cellar: :any_skip_relocation, monterey:       "01a9cc7b3ca3181c11e982610e2e1eef91df057f4405b3bef1d42377e8a73118"
    sha256 cellar: :any_skip_relocation, big_sur:        "13ce859637aad7ed6877776df508ba540974368d6ae8fa5ab04afa094213b68b"
    sha256 cellar: :any_skip_relocation, catalina:       "b74314540648b7cc6ef24ad220c530506805430d4be6c69c3f53c3ef9b82fa16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f9e0b6454c5e12cf303e0f331799147076acd7363481ff86bc26580f464973a"
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
