class SqliteUtils < Formula
  include Language::Python::Virtualenv
  desc "CLI utility for manipulating SQLite databases"
  homepage "https://sqlite-utils.datasette.io/"
  url "https://files.pythonhosted.org/packages/88/ca/721f4b48498b3b7af2127ab07be0b7ab662de1ba24121c4c32292b0a847d/sqlite-utils-3.23.tar.gz"
  sha256 "04d94e3ff8160c4461e11ced879ce37a0847afba33c8019e449c68784e9b6966"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9987eb8de61d4e5686fd2ce0d4e632079d35ee455cef3bc3b808e413f7658734"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe53c25173b95dbd355b574b11ae5cebca976fbfddabf83aba32cde0c928fa77"
    sha256 cellar: :any_skip_relocation, monterey:       "8633a0f9df6d4be308296389784e110e1b14469c45cd231bc6ff4e8512eda336"
    sha256 cellar: :any_skip_relocation, big_sur:        "19ec840f5a729ea0e66b1ce039893d38257cbafc6d92ef50b2ab349413b132de"
    sha256 cellar: :any_skip_relocation, catalina:       "ac335399c681fb7bba3c2b00bcf4f33f9b3898b1a1090c2ef34f5ceedd2373cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "518b901f89586ce3662a2278ebd51c867b94a076367a5d93e347f4d870d3541b"
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
