class SqliteUtils < Formula
  include Language::Python::Virtualenv
  desc "CLI utility for manipulating SQLite databases"
  homepage "https://sqlite-utils.datasette.io/"
  url "https://files.pythonhosted.org/packages/11/4f/ac11bc7771496d2bc139ec38086a329054d69e79e9d14d62aa369f5556f1/sqlite-utils-3.3.tar.gz"
  sha256 "5bca5c52f6f53f126e2ac2b91f6f8458181b111ed04c60011feb05f587a236d2"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "e1a7ef18ecacdabdbaccc3227de597f4557281525d30e967897dac29f6f5e895" => :big_sur
    sha256 "57f828d5a2391178c24aa47103970823d4a59c0f00c616d78803c9a1674827ad" => :arm64_big_sur
    sha256 "3233212129cebb61ba0d9a161ef0175068e4704df429c0534e309009baaa37c4" => :catalina
    sha256 "e11ed90992d7cd31f1239a470c61f34ed484faa9de61b01b81d824175ddebf58" => :mojave
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
