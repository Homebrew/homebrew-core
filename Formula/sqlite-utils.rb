class SqliteUtils < Formula
  include Language::Python::Virtualenv
  desc "CLI utility for manipulating SQLite databases"
  homepage "https://sqlite-utils.datasette.io/"
  url "https://files.pythonhosted.org/packages/50/a2/f9f712bb552f34321f16c9ce3154dfd7d13d0f51af7b9ddf95632f806f3a/sqlite-utils-3.1.1.tar.gz"
  sha256 "54df73364662ff3c763da3b42b9d27b1771ebfb3361caa255e44e1bf1544015b"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "a7fdd09cb66940853088e9f5a43e410df663aff6d8653350136d32153fbcd7a0" => :big_sur
    sha256 "a37f77001f69be843dc4dd543e207c06eee033cbef45c7890bb67325493de28b" => :arm64_big_sur
    sha256 "64b8043059787d98d4b508c7cb7cfd62a51edba5299337cc96424c123dffc03b" => :catalina
    sha256 "eed7a379658a2ba88c7468541e7bd8d3b2a6efdfbd18f143cb411f415f8ed43a" => :mojave
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
