class SqliteUtils < Formula
  include Language::Python::Virtualenv
  desc "CLI utility for manipulating SQLite databases"
  homepage "https://sqlite-utils.datasette.io/"
  url "https://files.pythonhosted.org/packages/37/6a/70e455fb51e5d71095b0f2e494e5ae0d2c27fb29c9f4d081d80cfb6a9a7c/sqlite-utils-3.10.tar.gz"
  sha256 "d6a3bfb15f203d042364479658d050d650c6bf7e2967261098d77a491556504e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d3d41fd0bfc7181c540754bf4914fc78c508f32585254212812b1e8c6672ad44"
    sha256 cellar: :any_skip_relocation, big_sur:       "808f09dbc1b73d9b3aed93fec485ade6f49fe2c37d83650e34a73116b033121d"
    sha256 cellar: :any_skip_relocation, catalina:      "808f09dbc1b73d9b3aed93fec485ade6f49fe2c37d83650e34a73116b033121d"
    sha256 cellar: :any_skip_relocation, mojave:        "808f09dbc1b73d9b3aed93fec485ade6f49fe2c37d83650e34a73116b033121d"
  end

  depends_on "python-tabulate"
  depends_on "python@3.9"

  resource "click" do
    url "https://files.pythonhosted.org/packages/21/83/308a74ca1104fe1e3197d31693a7a2db67c2d4e668f20f43a2fca491f9f7/click-8.0.1.tar.gz"
    sha256 "8c04c11192119b1ef78ea049e0a6f0463e4c48ef00a30160c704337586f3ad7a"
  end

  resource "click-default-group" do
    url "https://files.pythonhosted.org/packages/22/3a/e9feb3435bd4b002d183fcb9ee08fb369a7e570831ab1407bc73f079948f/click-default-group-1.2.2.tar.gz"
    sha256 "d9560e8e8dfa44b3562fbc9425042a0fd6d21956fcc2db0077f63f34253ab904"
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
