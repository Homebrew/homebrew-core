class SqliteUtils < Formula
  include Language::Python::Virtualenv
  desc "CLI utility for manipulating SQLite databases"
  homepage "https://sqlite-utils.datasette.io/"
  url "https://files.pythonhosted.org/packages/9e/47/62ee3582da24a2a910e6384fca0966f9783d1514658161fc25e2bf30eec1/sqlite-utils-3.24.tar.gz"
  sha256 "d1b92f8752fe1eac87e7f18a6b0e09f8e3c9ff247cf36260588e2f047eafd253"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77d176c7fb992d88c2395bdf4737af080bd57431cb80ae5ce6a7a6d4cd4a1709"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a5e8d591df00e9a0a40037152cb2a062f7cd754a6b5784a7939d66dd3106a030"
    sha256 cellar: :any_skip_relocation, monterey:       "5a318c629e1121208d3ee398fa033a4e0aad49312421bf69c3b9db2329f452f7"
    sha256 cellar: :any_skip_relocation, big_sur:        "029399fcdcebee2a7d272a88d9212d00ac20d7cf39dac1d55f982cdb3b141b7d"
    sha256 cellar: :any_skip_relocation, catalina:       "51807b5f8532a2d1da94392ab038a1e13a666aaecb63b9733c9b43e16e9baffb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eff0dbb99bd73de9941f4cefec03c095451fe692aee8ed61d6235a800125f914"
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
