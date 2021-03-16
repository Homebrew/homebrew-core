class SqliteUtils < Formula
  include Language::Python::Virtualenv
  desc "CLI utility for manipulating SQLite databases"
  homepage "https://sqlite-utils.datasette.io/"
  url "https://files.pythonhosted.org/packages/0d/7e/111bde53d3f4c4f03152963086a28aa11ea5536c6980f64b48eff43d7c7d/sqlite-utils-3.6.tar.gz"
  sha256 "582a9bcf4b6cb32ee2efa4a0d8f79ec630e8965ca93c69ceaaa7d424e1c01560"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e90efc9ccf7a756ae54730efb14f292cf560c0b19f7e0e9bd09adbdedd067faf"
    sha256 cellar: :any_skip_relocation, big_sur:       "b31059d3c5919e38195baab3580f5e867030e2f0defde97c9af88b8446d6cde0"
    sha256 cellar: :any_skip_relocation, catalina:      "cdd58ddff8316de85d4b7b024444d13632279312e5fef6bc1121cd47a72a19b3"
    sha256 cellar: :any_skip_relocation, mojave:        "af4e691a4c3fcf2687b1c587469b9e926507a760a8e716cc4712089eceb45a18"
  end

  depends_on "python-tabulate"
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

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "15", shell_output("#{bin}/sqlite-utils :memory: 'select 3 * 5'")
  end
end
