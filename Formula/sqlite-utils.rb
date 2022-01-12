class SqliteUtils < Formula
  include Language::Python::Virtualenv
  desc "CLI utility for manipulating SQLite databases"
  homepage "https://sqlite-utils.datasette.io/"
  url "https://files.pythonhosted.org/packages/d1/23/58949f93716d19490f2a0810fca2cbd8eadea1564688f8a3a413df8ac7a7/sqlite-utils-3.22.tar.gz"
  sha256 "24803ea4d63e2123d2040db2da43fea95fabada80e1af1fe1da69643ae376689"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "342edb8d18b51454a69be821af6a787b699f4f923f4f2f47659ccac206dee358"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "db8db1a504c12ae52198c47b8b9ff7801d6d0812de0dfa514141251ff7e6cfae"
    sha256 cellar: :any_skip_relocation, monterey:       "92c173ba672b8b950fd93cf3459bb77f1190fbc522226f38b74463fc05e7f223"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a166a4c5afa5aa6120ed9a53e87e4bc84a207fb0fab06f112b1964af25d9fed"
    sha256 cellar: :any_skip_relocation, catalina:       "10f4018df4f5ecd9b02bb14da7a8e2d6a89c98bac790d2bca17e842cd1165ad2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e03127c3f5095a914e1145f4089d9e4d92174b63ebdfd54afaf172ed2fe56409"
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
