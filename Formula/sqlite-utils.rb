class SqliteUtils < Formula
  include Language::Python::Virtualenv
  desc "CLI utility for manipulating SQLite databases"
  homepage "https://sqlite-utils.datasette.io/"
  url "https://files.pythonhosted.org/packages/49/24/3554aae898744ae33f49d1ab2e4ebf088e0b64515c8d03e7e549d503e585/sqlite-utils-3.2.tar.gz"
  sha256 "83d60e0f0de5e4a367e2ad414dc008c0602e2af35325b09e41c7b2c69808dcc1"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "c5e6133bf042dfb7815d60d5324f2da5606e7c9d0bfc2c33fe686a270c4c790d" => :big_sur
    sha256 "7fe7867144786e7247766c49f2d6eebe47999334c0a9b7cdd43998aa11b19a22" => :arm64_big_sur
    sha256 "ac9e128b60984b0472bfff94959c53ad89aa1eb9a65528e3f89dc18e51f130c7" => :catalina
    sha256 "3ad33fee7781cbb2a44b0864546770364fe3cdf6ba34aac258acc06f22ba77e1" => :mojave
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
    url "https://files.pythonhosted.org/packages/57/6f/213d075ad03c84991d44e63b6516dd7d185091df5e1d02a660874f8f7e1e/tabulate-0.8.7.tar.gz"
    sha256 "db2723a20d04bcda8522165c73eea7c300eda74e0ce852d9022e0159d7895007"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "15", shell_output("#{bin}/sqlite-utils :memory: 'select 3 * 5'")
  end
end
