class SqliteUtils < Formula
  include Language::Python::Virtualenv
  desc "CLI utility for manipulating SQLite databases"
  homepage "https://sqlite-utils.datasette.io/"
  url "https://files.pythonhosted.org/packages/84/39/4ce5c5ac7ac6a485349f8636a920cd2568bf8f11298519d552b0c57351db/sqlite-utils-3.35.1.tar.gz"
  sha256 "e0f03e6976b05bdb7a5c56454971a0e980fc16dbfd3512bbd3bdcac4f0e4370e"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e1822b55f47005af43f5b55b8b97e8e6d661a6a9a357155653001f6db5b5650a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2249970d2711d8ea776982d2c26e02a7c519e6c7531063605326a592c5264cb2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30de8a78f62cea2852bdfde9ea1b2854fcee30f69e7931fe50dbe79231120c1c"
    sha256 cellar: :any_skip_relocation, sonoma:         "e191f44a2eea51972e609d8f1a215cf7cd9d3ebfd118ed27eee96dc5c2b355d4"
    sha256 cellar: :any_skip_relocation, ventura:        "a9149d6f792f04e2484b75a8020f7cd4093051b99788506be49e96b90d0a2d8f"
    sha256 cellar: :any_skip_relocation, monterey:       "f6444387bf656f64535eb8af3e5611052bd35cc6ec11e7488d14eb0703974b10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b8dde21b71257d408aefe7e4d2623971b669d8680b680d4d95c4b1ea57f9f7c"
  end

  depends_on "python-tabulate"
  depends_on "python@3.12"
  depends_on "six"

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "click-default-group" do
    url "https://files.pythonhosted.org/packages/1d/ce/edb087fb53de63dad3b36408ca30368f438738098e668b78c87f93cd41df/click_default_group-1.2.4.tar.gz"
    sha256 "eb3f3c99ec0d456ca6cd2a7f08f7d4e91771bef51b01bdd9580cc6450fe1251e"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/36/51/04defc761583568cae5fd533abda3d40164cbdcf22dee5b7126ffef68a40/pluggy-1.3.0.tar.gz"
    sha256 "cf61ae8f126ac6f7c451172cf30e3e43d3ca77615509771b3a984a0730651e12"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "sqlite-fts4" do
    url "https://files.pythonhosted.org/packages/c2/6d/9dad6c3b433ab8912ace969c66abd595f8e0a2ccccdb73602b1291dbda29/sqlite-fts4-1.0.3.tar.gz"
    sha256 "78b05eeaf6680e9dbed8986bde011e9c086a06cb0c931b3cf7da94c214e8930c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "15", shell_output("#{bin}/sqlite-utils :memory: 'select 3 * 5'")
  end
end
