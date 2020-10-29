class SqliteUtils < Formula
  include Language::Python::Virtualenv
  desc "CLI utility for manipulating SQLite databases"
  homepage "https://sqlite-utils.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/22/cf/04734609f4a291831b81179170b551cf368bde7f421ed8548cc343ffcac9/sqlite-utils-2.23.tar.gz"
  sha256 "1b67e19bbb52013796c98ed9f91f5002555c6be66ebb092dfd6a8924ec82ff48"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "e1eb73968991227f8b45b18e8f75ce56a49d3edb89fd3b7945587a67cf4bbdc8" => :catalina
    sha256 "c48acb5a8d088181a4014cda724035957c3156febcfc117fa7a928538dd352e7" => :mojave
    sha256 "d7f0312ccee836951b58c473976d64e9492184bd46002b44f05f3049fcbb7df3" => :high_sierra
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
