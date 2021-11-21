class SqliteUtils < Formula
  include Language::Python::Virtualenv
  desc "CLI utility for manipulating SQLite databases"
  homepage "https://sqlite-utils.datasette.io/"
  url "https://files.pythonhosted.org/packages/5e/12/901cfe4b227727b5686d3d644707f2e0acd11caeb3fc7faf64236a253910/sqlite-utils-3.19.tar.gz"
  sha256 "509099fce5f25faada6e76b6fb90e8ef5ba0f1715177933a816718be0c8e7244"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7d98787e37ffbbb3161641b41b9ee3a0c027f118745bd20143319540b4c0815"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6a4d0c3e066d3de52c36ffd2e2defbc7eda42ea55ce6837dd72a89e2a19309e6"
    sha256 cellar: :any_skip_relocation, monterey:       "f30a8f3030c5d8cd0cf8967c92e9f3852329d5069079d10c4745aa23b0da9c7c"
    sha256 cellar: :any_skip_relocation, big_sur:        "793944e561f4036d776a556ebb648eabb30a23cfdd6c66612f5e06b4d3da2fd7"
    sha256 cellar: :any_skip_relocation, catalina:       "f8cf4e2572612bedfc5165fc1e2a190f2912d802df6bf1a3b20a9511f414c7d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5520b5710021a2ebab9a19974beccd1f0174ec930eaec67a110a49058d5bc335"
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
