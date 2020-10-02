class SqliteUtils < Formula
  include Language::Python::Virtualenv
  desc "CLI utility for manipulating SQLite databases"
  homepage "https://sqlite-utils.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/6a/9d/42871b729018c48ecdf9f14f14e5f6fc99416a088b6040b32ce494528ddb/sqlite-utils-2.21.tar.gz"
  sha256 "fdb3ac8a2ce7da4253a04d9e57b7a1bbb4c2d756416fd9ae5c4459002453edc7"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "f41efb81c02883b63c804d67cbafec2bc45eb60f8d0cbc3751f7a3cfb2bb5638" => :catalina
    sha256 "f9d6609ffa25698b5e5882f9357645ea2076afd57acf78e557dd7657ad5884ce" => :mojave
    sha256 "5019a149c12d41c1aeab5fe48bca17f0121fdfc6113141cc99fd75a4230145eb" => :high_sierra
  end

  depends_on "python@3.8"

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "click-default-group" do
    url "https://files.pythonhosted.org/packages/22/3a/e9feb3435bd4b002d183fcb9ee08fb369a7e570831ab1407bc73f079948f/click-default-group-1.2.2.tar.gz"
    sha256 "d9560e8e8dfa44b3562fbc9425042a0fd6d21956fcc2db0077f63f34253ab904"
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
