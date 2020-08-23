class SqliteUtils < Formula
  include Language::Python::Virtualenv
  desc "CLI utility for manipulating SQLite databases"
  homepage "https://sqlite-utils.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/73/16/10bb0d96f873daf596cc0d1058dc2bfe71033d03ac122d59e71f82e8d83a/sqlite-utils-2.16.tar.gz"
  sha256 "8c9878371b76c82d789efc521cc77b15c229a7f281dd6a426da15af0ccccf375"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "fba7ed14f801c4bed1a672b6d124e76b467b156e82b5085fac18a112069447cb" => :catalina
    sha256 "b20643d2f23dbf55b30262983368d9a899625446395888569d6fd1b4309d7e2d" => :mojave
    sha256 "1d44737e57faf7863cd10d51fcf09e30eaf2a140ae754965fe3dd6a81e0ffb2b" => :high_sierra
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
