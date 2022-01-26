class SqliteUtils < Formula
  include Language::Python::Virtualenv
  desc "CLI utility for manipulating SQLite databases"
  homepage "https://sqlite-utils.datasette.io/"
  url "https://files.pythonhosted.org/packages/15/87/f6d42d599826037c7aef82e7a23d8f657d4f5cf657b0001d73ed25bc1c98/sqlite-utils-3.22.1.tar.gz"
  sha256 "35ebb4f7e2b09f1818b36e7da6dc62f1ca57e2c0d99a9cbc8151e634d75a7906"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab3059e8f1184537593882a3d9e1aeb19c90c5b2d4d61c369744d4530df4354f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c63c60c5a2f4ff53e54ebaff7aef49fb7c47f96593785388d938bf77e11b6ae"
    sha256 cellar: :any_skip_relocation, monterey:       "83b5ba1a18ab1e8f8242f5a88a979470c10755c9c808318c707f234c9472e582"
    sha256 cellar: :any_skip_relocation, big_sur:        "4466642f6a788055b32b5be046cf912cc406205df6628cf57197c87e6f3f89bd"
    sha256 cellar: :any_skip_relocation, catalina:       "2e86f1ee6abc0b89e3ebbfc2024d159172f94a0d166df4c9b21ec94edf3c437e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a3a0ab59707c654a5d604ba90d0b835fd5342fe533deef8f9c70899ecf862e0"
  end

  depends_on "python-tabulate"
  depends_on "python@3.9"
  depends_on "six"

  resource "click" do
    url "https://files.pythonhosted.org/packages/f4/09/ad003f1e3428017d1c3da4ccc9547591703ffea548626f47ec74509c5824/click-8.0.3.tar.gz"
    sha256 "410e932b050f5eed773c4cda94de75971c89cdb3155a72a0831139a79e5ecb5b"
  end

  resource "click-default-group" do
    url "https://files.pythonhosted.org/packages/22/3a/e9feb3435bd4b002d183fcb9ee08fb369a7e570831ab1407bc73f079948f/click-default-group-1.2.2.tar.gz"
    sha256 "d9560e8e8dfa44b3562fbc9425042a0fd6d21956fcc2db0077f63f34253ab904"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
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
