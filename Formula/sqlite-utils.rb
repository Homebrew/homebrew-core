class SqliteUtils < Formula
  include Language::Python::Virtualenv
  desc "CLI utility for manipulating SQLite databases"
  homepage "https://sqlite-utils.datasette.io/"
  url "https://files.pythonhosted.org/packages/ad/2c/8ad058a9d5597681d87cd55c31290162c23a36cc6274c337ff4abc7775ea/sqlite-utils-3.12.tar.gz"
  sha256 "78ee06317b9b83ae96538f778a1e89f31c95cced446b5c5648462e2214539efe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7e43d36183224241c126cf3b3e71814d7ba7346174d3d2bb7ef3ffdc0de11b55"
    sha256 cellar: :any_skip_relocation, big_sur:       "bd9357102ff7fcf07974de494e7d783e1eb4aa4839f2c7ca10a3921baba4b6b2"
    sha256 cellar: :any_skip_relocation, catalina:      "bd9357102ff7fcf07974de494e7d783e1eb4aa4839f2c7ca10a3921baba4b6b2"
    sha256 cellar: :any_skip_relocation, mojave:        "bd9357102ff7fcf07974de494e7d783e1eb4aa4839f2c7ca10a3921baba4b6b2"
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
