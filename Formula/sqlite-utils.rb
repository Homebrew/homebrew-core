class SqliteUtils < Formula
  include Language::Python::Virtualenv
  desc "CLI utility for manipulating SQLite databases"
  homepage "https://sqlite-utils.datasette.io/"
  url "https://files.pythonhosted.org/packages/98/c4/6a7eb6087cc77ff9c44f341967f97ec36a2181fe1796bb4f2cd61608f255/sqlite-utils-3.17.1.tar.gz"
  sha256 "0cfde0c46a2d4c09d6df8609fe53642bc3ab443bcef3106d8f1eabeb3fccbe3d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "80ca20fc8e828fe2a303d934a706e55f42ea18692f12d5f378fb88895b3d3fb3"
    sha256 cellar: :any_skip_relocation, big_sur:       "89adb3623815c841261f89d741efb244a12e4b48d155b5fb8b8dd2dd7d4ed01a"
    sha256 cellar: :any_skip_relocation, catalina:      "ab74fd5336ddf14a00ee6203d465e284d2bda2917bf7fad3f2bb502a94387bf1"
    sha256 cellar: :any_skip_relocation, mojave:        "fbbde2ddbf4f2cc628f518ec29f3a879168b93e0f1587936cc6e1623e5078011"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "338292c0c7ce10e33afa5b310a419834a1d95c9e508adbe91d91074a6184702a"
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
