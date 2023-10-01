class SqliteUtils < Formula
  include Language::Python::Virtualenv
  desc "CLI utility for manipulating SQLite databases"
  homepage "https://sqlite-utils.datasette.io/"
  url "https://files.pythonhosted.org/packages/84/39/4ce5c5ac7ac6a485349f8636a920cd2568bf8f11298519d552b0c57351db/sqlite-utils-3.35.1.tar.gz"
  sha256 "e0f03e6976b05bdb7a5c56454971a0e980fc16dbfd3512bbd3bdcac4f0e4370e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "61155b5a96cdb76a53dd4c7b11842bea3443e895ca876441e10615cdce07f134"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4501e0f44c130555e875d81274f8d2f882afd3a2d3859cffc877d7717459b96"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "983fc50b67ab331e4e184434a8a528ba7fbb0cd29ed927f027e7861b3847c991"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f052dce4c47c4604bcc92171eeb20c2960c203fff90f4a66d3ba5b6de33a8f33"
    sha256 cellar: :any_skip_relocation, sonoma:         "8275d59490ec0102e1c48e660fd0cc036f42bf964b214269c6fd88d0989a14a4"
    sha256 cellar: :any_skip_relocation, ventura:        "89163cc2b6aefd3815308b6d64010abed94223b8ab833e1df3807f048f4e03c2"
    sha256 cellar: :any_skip_relocation, monterey:       "831094f6350c01995e8e9c9c09cf0fb9b42640d72dc4bb8024633b0e520036d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "a5d8f56c6c94be13003cfc2de30bd2095224c1eb2cf08f552d57c6e51ed1ad3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "884268fc4fad933c8fe4b1bc55f8604e11c106cef25fa73675637bc527270cb6"
  end

  depends_on "python-tabulate"
  depends_on "python@3.11"
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
