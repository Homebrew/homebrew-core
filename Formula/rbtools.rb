class Rbtools < Formula
  include Language::Python::Virtualenv

  desc "CLI and API for working with code and document reviews on Review Board"
  homepage "https://www.reviewboard.org/downloads/rbtools/"
  url "https://files.pythonhosted.org/packages/d2/ce/363101545b7a61dac2ab94f5a718ac9e2120d1dda3b2bc5acb40f8034eef/RBTools-4.0.tar.gz"
  sha256 "67556ba8ce2e9977c4a4a5e14c4785cbe9215be56d04f8167fd703a4ae0f266f"
  license "MIT"
  head "https://github.com/reviewboard/rbtools.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b0c78646c9b3f5bf3901902122d0835e00c8adbeb34886d765888a34c6505960"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "259be5e7eac1be107f3ab7f0cd97e39a48376ab4ebb6f4e08f0e56b6d21a01ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "57bc64193f6c2b156e719f5d60779693a487060279542274b4142ae33251eb1c"
    sha256 cellar: :any_skip_relocation, ventura:        "3e19b6d11c68dce31cac490b0c41c366eb7f2fbe76cd1bae0fcf6fa86a0fc07b"
    sha256 cellar: :any_skip_relocation, monterey:       "2f2aac7ec3b8ee6cb675a780d4d75e758f302948c7ab72a335969d356d5f683c"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ad603c0a25683d3350949e6796beab8f558138bd31521d04617df17ad542203"
    sha256 cellar: :any_skip_relocation, catalina:       "e6616acfb3f1df1b2896644a3c5f9e9bdd9e41e12ce9a8d977a15630861b424a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9a2e1211ddb4c3a444602a0977e6d00cc7b9acad2a0676c5771cbaae8ad89c0"
  end

  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "six"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "pydiffx" do
    url "https://files.pythonhosted.org/packages/d3/76/ad0677d82b7c75deb4da63151d463a9f90e97f3817b83f4e3f74034eb384/pydiffx-1.1.tar.gz"
    sha256 "0986dbb0a87cbf79e244e2f1c0e2b696d8e86b3861ea2955757a61d38e139228"
  end

  resource "texttable" do
    url "https://files.pythonhosted.org/packages/d5/78/dbc2a5eab57a01fedaf975f2c16f04e76f09336dbeadb9994258aa0a2b1a/texttable-1.6.4.tar.gz"
    sha256 "42ee7b9e15f7b225747c3fa08f43c5d6c83bc899f80ff9bae9319334824076e9"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/c1/c2/d8a40e5363fb01806870e444fc1d066282743292ff32a9da54af51ce36a2/tqdm-4.64.1.tar.gz"
    sha256 "5f4f682a004951c1b450bc753c710e9280c5746ce6ffedee253ddbcbf54cf1e4"
  end

  def install
    virtualenv_install_with_resources
    bash_completion.install "rbtools/commands/conf/rbt-bash-completion" => "rbt"
    zsh_completion.install "rbtools/commands/conf/_rbt-zsh-completion" => "_rbt"
  end

  test do
    system "git", "init"
    system "#{bin}/rbt", "setup-repo", "--server", "https://demo.reviewboard.org"
    out = shell_output("#{bin}/rbt clear-cache")
    assert_match "Cleared cache in", out
  end
end
