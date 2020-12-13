class SqliteUtils < Formula
  include Language::Python::Virtualenv
  desc "CLI utility for manipulating SQLite databases"
  homepage "https://sqlite-utils.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/16/d3/a40f7d2dac4ea6a3c35826c82b8dfed915ee169d3a110c1626c0bea9cf22/sqlite-utils-3.1.tar.gz"
  sha256 "53950eb89f77066d6caf553c52ec01701a8bebbaffa9e0a627df3f229ca8720f"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "7ae26ca6f2d2256916f34cd5163dd4ec57443ae9b2bf94cf996db96eaaf586cd" => :big_sur
    sha256 "06248b4b20d6788b7ebe24056c792b49e03cf44eb69c4e9a45801ea9d411f67a" => :catalina
    sha256 "7572dcf7b3c8abdca33c75cec021bb2f2097131474cda47161b08fac8f297d97" => :mojave
    sha256 "979e53278c94017c24d2f41fe245a6a49249e58ea5239b3638ff21a1ff573e8a" => :high_sierra
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
