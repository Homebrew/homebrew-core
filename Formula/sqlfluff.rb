class Sqlfluff < Formula
  include Language::Python::Virtualenv

  desc "SQL linter and auto-formatter for Humans"
  homepage "https://docs.sqlfluff.com/"
  url "https://files.pythonhosted.org/packages/95/30/f64ffedd4627b9c25b15698fae6be02519ef3c14c86f9706fbadd30bd564/sqlfluff-0.9.4.tar.gz"
  sha256 "0e55c7b460d95ea1986852fc43926add391734f04888788aea350a1612b94be2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f07a80469faada0b9a8c7c3a665edcf0c28f730787b016cbe91c019d7f851fd5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be3a2caa85124d8c4b83fded24adf669dbd39f1a19037ecddbc8d9c3def5c8df"
    sha256 cellar: :any_skip_relocation, monterey:       "9d6b7f290cd0f22ea134061457486ee555f62e5aed4227843963fbb24b596570"
    sha256 cellar: :any_skip_relocation, big_sur:        "0704932b61730dfc17a78838622f8b5eaae7da7fac421f26c7c1762e8612fbde"
    sha256 cellar: :any_skip_relocation, catalina:       "5a1edc51031ff59ba524df78fe567f0eddf6e7fd962cadf159828e1aa3f9ff9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e28d1d01f90fa394953d4c39a20982f59bad947b858c355e3624ba3a20841d27"
  end

  depends_on "python@3.10"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/d7/77/ebb15fc26d0f815839ecd897b919ed6d85c050feeb83e100e020df9153d2/attrs-21.4.0.tar.gz"
    sha256 "626ba8234211db98e869df76230a137c4c40a12d72445c45d5f5b716f076e2fd"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/ee/2d/9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/f4/09/ad003f1e3428017d1c3da4ccc9547591703ffea548626f47ec74509c5824/click-8.0.3.tar.gz"
    sha256 "410e932b050f5eed773c4cda94de75971c89cdb3155a72a0831139a79e5ecb5b"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "diff-cover" do
    url "https://files.pythonhosted.org/packages/2f/20/54914c269627d2ab18b0d0bb2276613d6b3313451e173ff28f07e5736959/diff_cover-6.4.4.tar.gz"
    sha256 "b1d782c1ce53ad4b2c5545f8b7aa799eb61a0b12a62b376a18e2313c6f2d77f1"
  end

  resource "iniconfig" do
    url "https://files.pythonhosted.org/packages/23/a2/97899f6bd0e873fed3a7e67ae8d3a08b21799430fb4da15cfedf10d6e2c2/iniconfig-1.1.1.tar.gz"
    sha256 "bc3af051d7d14b2ee5ef9969666def0cd1a000e121eaea580d4a313df4b37f32"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/91/a5/429efc6246119e1e3fbf562c00187d04e83e54619249eb732bb423efa6c6/Jinja2-3.0.3.tar.gz"
    sha256 "611bb273cd68f3b993fabdc4064fc858c5b47a973cb5aa7999ec1ba405c87cd7"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/bf/10/ff66fea6d1788c458663a84d88787bae15d45daa16f6b3ef33322a51fc7e/MarkupSafe-2.0.1.tar.gz"
    sha256 "594c67807fb16238b30c44bdf74f36c02cdf22d1c8cda91ef8a0ed8dabf5620a"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/f6/33/436c5cb94e9f8902e59d1d544eb298b83c84b9ec37b5b769c5a0ad6edb19/pathspec-0.9.0.tar.gz"
    sha256 "e564499435a2673d586f6b2130bb5b95f04a3ba06f81b8f895b651a3c76aabb1"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/a1/16/db2d7de3474b6e37cbb9c008965ee63835bba517e22cdb8c35b5116b5ce1/pluggy-1.0.0.tar.gz"
    sha256 "4224373bacce55f955a878bf9cfa763c1e360858e330072059e10bad68531159"
  end

  resource "py" do
    url "https://files.pythonhosted.org/packages/98/ff/fec109ceb715d2a6b4c4a85a61af3b40c723a961e8828319fbcb15b868dc/py-1.11.0.tar.gz"
    sha256 "51c75c4126074b472f746a24399ad32f6053d1b34b68d2fa41e558e6f4a98719"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/94/9c/cb656d06950268155f46d4f6ce25d7ffc51a0da47eadf1b164bbf23b718b/Pygments-2.11.2.tar.gz"
    sha256 "4e426f72023d88d03b2fa258de560726ce890ff3b630f88c21cbb8b2503b8c6a"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/d6/60/9bed18f43275b34198eb9720d4c1238c68b3755620d20df0afd89424d32b/pyparsing-3.0.7.tar.gz"
    sha256 "18ee9022775d270c55187733956460083db60b37d0d0fb357445f3094eed3eea"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/4b/24/7d1f2d2537de114bdf1e6875115113ca80091520948d370c964b88070af2/pytest-6.2.5.tar.gz"
    sha256 "131b36680866a76e6781d13f101efb86cf674ebb9762eb70d3082b6f29889e89"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/4c/75/b5b60055897d78882da8bc4c94609067cf531a42726df2e44ce69e8ec7a9/regex-2022.1.18.tar.gz"
    sha256 "97f32dc03a8054a4c4a5ab5d761ed4861e828b2c200febd4e46857069a483916"
  end

  resource "tblib" do
    url "https://files.pythonhosted.org/packages/d3/41/901ef2e81d7b1e834b9870d416cb09479e175a2be1c4aa1a9dcd0a555293/tblib-1.7.0.tar.gz"
    sha256 "059bd77306ea7b419d4f76016aef6d7027cc8a0785579b5aad198803435f882c"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/e3/c1/b3e42d5b659ca598508e2a9ef315d5eef0a970f874ef9d3b38d4578765bd/tqdm-4.62.3.tar.gz"
    sha256 "d359de7217506c9851b7869f3708d8ee53ed70a1b8edbba4dbcb47442592920d"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/0d/4a/60ba3706797b878016f16edc5fbaf1e222109e38d0fa4d7d9312cb53f8dd/typing_extensions-4.0.1.tar.gz"
    sha256 "4ca091dea149f945ec56afb48dae714f21e8692ef22a395223bcd328961b6a0e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sqlfluff --version")
    (testpath/"test.sql").write <<~EOS
      SELECT 1;
    EOS
    assert_match "All Finished!", shell_output("#{bin}/sqlfluff lint --nocolor #{testpath}/test.sql")
  end
end
