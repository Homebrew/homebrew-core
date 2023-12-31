class SqliteUtils < Formula
  include Language::Python::Virtualenv
  desc "CLI utility for manipulating SQLite databases"
  homepage "https://sqlite-utils.datasette.io/"
  url "https://files.pythonhosted.org/packages/ae/70/dc7c74592f30ac20be23eaeeb2a84ee6e2c12c21beb07a3eb53ead77de1f/sqlite-utils-3.36.tar.gz"
  sha256 "dcc311394fe86dc16f65037b0075e238efcfd2e12e65d53ed196954502996f3c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "505882c2325a7428c10b1583211d7d9e761545afededc735da0a3f4c30d245ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4de24c2bd1e2072b44cb9072b93112edce9a7df78820e230180c809d3006e345"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a708cbde79c6d25969852829e02e0d75301cd8b5a63c65dfffe9327d4b7460f7"
    sha256 cellar: :any_skip_relocation, sonoma:         "7577e9af3df5b4968cc8e465f19282f343114a74b1746ad1125997258395fcca"
    sha256 cellar: :any_skip_relocation, ventura:        "2c8bb3a7e2bf8bfa6fd8eaa52bd52ed62fab6fc92be9457c20429a3a3a22d4b9"
    sha256 cellar: :any_skip_relocation, monterey:       "d6695b14c1dc0210bf5bfd0cb9b0468d53133e68b520e012b8dd524f4135a0d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9295389b9b1fb1408859ffb12aa9a905a533eb291c7a270680b6e03eb81c7de9"
  end

  depends_on "python-click"
  depends_on "python-dateutil"
  depends_on "python-pluggy"
  depends_on "python-tabulate"
  depends_on "python@3.12"
  depends_on "six"

  resource "click-default-group" do
    url "https://files.pythonhosted.org/packages/1d/ce/edb087fb53de63dad3b36408ca30368f438738098e668b78c87f93cd41df/click_default_group-1.2.4.tar.gz"
    sha256 "eb3f3c99ec0d456ca6cd2a7f08f7d4e91771bef51b01bdd9580cc6450fe1251e"
  end

  resource "sqlite-fts4" do
    url "https://files.pythonhosted.org/packages/c2/6d/9dad6c3b433ab8912ace969c66abd595f8e0a2ccccdb73602b1291dbda29/sqlite-fts4-1.0.3.tar.gz"
    sha256 "78b05eeaf6680e9dbed8986bde011e9c086a06cb0c931b3cf7da94c214e8930c"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"sqlite-utils", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match "15", shell_output("#{bin}/sqlite-utils :memory: 'select 3 * 5'")
  end
end
