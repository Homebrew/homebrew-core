class SqliteUtils < Formula
  include Language::Python::Virtualenv

  desc "CLI utility for manipulating SQLite databases"
  homepage "https://sqlite-utils.datasette.io/"
  url "https://files.pythonhosted.org/packages/51/43/ce9183a21911e0b73248c8fb83f8b8038515cb80053912c2a009e9765564/sqlite_utils-3.38.tar.gz"
  sha256 "1ae77b931384052205a15478d429464f6c67a3ac3b4eafd3c674ac900f623aab"
  license "Apache-2.0"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "143905b7ed6a8f14901a426dff00dc50c3595c292bd18308bf09341711749f84"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "143905b7ed6a8f14901a426dff00dc50c3595c292bd18308bf09341711749f84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "143905b7ed6a8f14901a426dff00dc50c3595c292bd18308bf09341711749f84"
    sha256 cellar: :any_skip_relocation, sonoma:        "19ab058d0e946b1c89d13dc42825879c7b711ff74f32acb332f27f8525248c5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19ab058d0e946b1c89d13dc42825879c7b711ff74f32acb332f27f8525248c5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19ab058d0e946b1c89d13dc42825879c7b711ff74f32acb332f27f8525248c5b"
  end

  depends_on "python@3.14"

  resource "click" do
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
  end

  resource "click-default-group" do
    url "https://files.pythonhosted.org/packages/1d/ce/edb087fb53de63dad3b36408ca30368f438738098e668b78c87f93cd41df/click_default_group-1.2.4.tar.gz"
    sha256 "eb3f3c99ec0d456ca6cd2a7f08f7d4e91771bef51b01bdd9580cc6450fe1251e"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
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

    generate_completions_from_executable(bin/"sqlite-utils", shell_parameter_format: :click)
  end

  test do
    assert_match "15", shell_output("#{bin}/sqlite-utils :memory: 'select 3 * 5'")
  end
end
