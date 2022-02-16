class SqliteUtils < Formula
  include Language::Python::Virtualenv
  desc "CLI utility for manipulating SQLite databases"
  homepage "https://sqlite-utils.datasette.io/"
  url "https://files.pythonhosted.org/packages/9e/47/62ee3582da24a2a910e6384fca0966f9783d1514658161fc25e2bf30eec1/sqlite-utils-3.24.tar.gz"
  sha256 "d1b92f8752fe1eac87e7f18a6b0e09f8e3c9ff247cf36260588e2f047eafd253"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "476e66b4b1c6ff6a0b70bb818e4094fe61bd2009585f6ec3eb912577af907f9b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af76423a5e4e7b50fdd49a1c830a00b1b323cb3071b806e184dc66bff016245e"
    sha256 cellar: :any_skip_relocation, monterey:       "ddc42ce00775715b81108d592e784804ed287872445c18bbd9fe03ef18184c30"
    sha256 cellar: :any_skip_relocation, big_sur:        "6878d09298b15a3940c08a49b93dcef717c89e293224ff34b12e4c8c44012f63"
    sha256 cellar: :any_skip_relocation, catalina:       "3c0477a452e9b3ca87826dbd7dc039b9defd12fb0935a1c7e1e11c52d3f4c35c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0524e4fd125e14467f41a9bcdfa52e1f0aaa3a8f6a9c8c562933dddb0527659a"
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
