class SqliteUtils < Formula
  include Language::Python::Virtualenv
  desc "CLI utility for manipulating SQLite databases"
  homepage "https://sqlite-utils.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/fc/ca/00582702fd8178c4cab7aa2a511b39c1aafe1495e8e988b46a67d64cfa50/sqlite-utils-2.18.tar.gz"
  sha256 "1832b586e11a12fef3c56d993d294c9b6ad2e5db60fa016b126d5c562881561d"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "99d627c0876b5450ffb2233fecc51ecea343be704c1b7e03b9a989ae5fcae078" => :catalina
    sha256 "a5506c4011875fbee7fba5b41e0b66fb838f1f8aa895677538c12f30bb76b6c2" => :mojave
    sha256 "18a9a7ddd8e5dd244ee53f55080b2effc6fb91a59836edaebb5d12d9bec33f3c" => :high_sierra
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
