class SqliteUtils < Formula
  include Language::Python::Virtualenv
  desc "CLI utility for manipulating SQLite databases"
  homepage "https://sqlite-utils.datasette.io/"
  url "https://files.pythonhosted.org/packages/86/ac/3ed8f334d61e7984bc5ce05f47fb96467de0b256ca2815a8bdde909d777a/sqlite-utils-3.15.1.tar.gz"
  sha256 "029d90209cd2f1bd5b3eae61b90f149edc27e89ee1efc3b826538e1ee762534b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "76b82b0b5359b9e14b65f0307481a667b7e4c431c1010b6eff32490ae7c6efd3"
    sha256 cellar: :any_skip_relocation, big_sur:       "317e677e823975e0e17ce6fe215c70da659e7e2afc9a52ba89764ae9f27c8889"
    sha256 cellar: :any_skip_relocation, catalina:      "daac49cd99806609bfd557ce50d8443c0926353f7b976c22ae47121b992838ea"
    sha256 cellar: :any_skip_relocation, mojave:        "385c9c20ef520a5bf52999e0af91d748a7ba4a94610db6704c0b729e7d34b227"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f61048a72df139dd6cb5eb444799f7f11a620ac40e3ef7ed900e36dc9db52a8"
  end

  depends_on "python-tabulate"
  depends_on "python@3.9"

  resource "click" do
    url "https://files.pythonhosted.org/packages/21/83/308a74ca1104fe1e3197d31693a7a2db67c2d4e668f20f43a2fca491f9f7/click-8.0.1.tar.gz"
    sha256 "8c04c11192119b1ef78ea049e0a6f0463e4c48ef00a30160c704337586f3ad7a"
  end

  resource "click-default-group" do
    url "https://files.pythonhosted.org/packages/22/3a/e9feb3435bd4b002d183fcb9ee08fb369a7e570831ab1407bc73f079948f/click-default-group-1.2.2.tar.gz"
    sha256 "d9560e8e8dfa44b3562fbc9425042a0fd6d21956fcc2db0077f63f34253ab904"
  end

  resource "dateutils" do
    url "https://files.pythonhosted.org/packages/70/2e/a2d1337ac0ebb32b3b4ad921d9621f8b2f6bb20de0da47ec5d3734f08ce2/dateutils-0.6.12.tar.gz"
    sha256 "03dd90bcb21541bd4eb4b013637e4f1b5f944881c46cc6e4b67a6059e370e3f1"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/b0/61/eddc6eb2c682ea6fd97a7e1018a6294be80dba08fa28e7a3570148b4612d/pytz-2021.1.tar.gz"
    sha256 "83a4a90894bf38e243cf052c8b58f381bfe9a7a483f6a9cab140bc7f702ac4da"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
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
