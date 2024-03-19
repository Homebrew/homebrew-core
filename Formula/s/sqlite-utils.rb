class SqliteUtils < Formula
  include Language::Python::Virtualenv

  desc "CLI utility for manipulating SQLite databases"
  homepage "https://sqlite-utils.datasette.io/"
  url "https://files.pythonhosted.org/packages/ae/70/dc7c74592f30ac20be23eaeeb2a84ee6e2c12c21beb07a3eb53ead77de1f/sqlite-utils-3.36.tar.gz"
  sha256 "dcc311394fe86dc16f65037b0075e238efcfd2e12e65d53ed196954502996f3c"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0b2222312303da2cd82cdf50b9817077b5769ba12b3ddc07269c92a468c0b920"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d088bf9a317954888c5bac071451dde7955596b0906a6b8fa17cd085e50d47a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d84102b4c4264cf8f57eadc6cb14b05b179b18cc44ab626ea614cb47f66f7b19"
    sha256 cellar: :any_skip_relocation, sonoma:         "a4c7e124f8a75623621a1aad0a92caa3b81d4b99b07d0203419057208af14f52"
    sha256 cellar: :any_skip_relocation, ventura:        "48a81fb992280221f90ddf268dec220518e5bcc59b197faef3c28600c34de449"
    sha256 cellar: :any_skip_relocation, monterey:       "27cda1835aeea0af2e43ecedac178223a27334e420d2271c62ed2fd7b59c2443"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1450462a0b43736b8228ec579b6553b46fd9109f40a260936f04ac662cbf4a96"
  end

  depends_on "python@3.12"

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "click-default-group" do
    url "https://files.pythonhosted.org/packages/1d/ce/edb087fb53de63dad3b36408ca30368f438738098e668b78c87f93cd41df/click_default_group-1.2.4.tar.gz"
    sha256 "eb3f3c99ec0d456ca6cd2a7f08f7d4e91771bef51b01bdd9580cc6450fe1251e"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/54/c6/43f9d44d92aed815e781ca25ba8c174257e27253a94630d21be8725a2b59/pluggy-1.4.0.tar.gz"
    sha256 "8c85c2876142a764e5b7548e7d9a0e0ddb46f5185161049a79b7e974454223be"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "sqlite-fts4" do
    url "https://files.pythonhosted.org/packages/c2/6d/9dad6c3b433ab8912ace969c66abd595f8e0a2ccccdb73602b1291dbda29/sqlite-fts4-1.0.3.tar.gz"
    sha256 "78b05eeaf6680e9dbed8986bde011e9c086a06cb0c931b3cf7da94c214e8930c"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"sqlite-utils", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match "15", shell_output("#{bin}/sqlite-utils :memory: 'select 3 * 5'")
  end
end
