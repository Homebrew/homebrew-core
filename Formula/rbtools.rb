class Rbtools < Formula
  include Language::Python::Virtualenv

  desc "CLI and API for working with code and document reviews on Review Board"
  homepage "https://www.reviewboard.org/downloads/rbtools/"
  url "https://files.pythonhosted.org/packages/f3/12/69737ab2c89eae4e7c7952792148e6d065150a8c5067e3dfa184583bfcf8/RBTools-3.1.1.tar.gz"
  sha256 "1c57725cb2c9a23b8aa947a607b6e71a5075c511379652406ca010f917e70b3e"
  license "MIT"
  head "https://github.com/reviewboard/rbtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55446557bdf534d41de838b34e950be95255098ce2f88c23a2c972ec75d1aa33"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "027739fd21d5a63d7dd44c7e24145135170e61b24ddda9a084869714ba1a608e"
    sha256 cellar: :any_skip_relocation, monterey:       "ffd5c86cfd67e1c631f31304bde25f5bed20f4bc9e3703aa5998b7cc3a8b29b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c065fc32ef9fe77d0370e8efba10124596a3f3ea5141559a2b96736ec0c7e32"
    sha256 cellar: :any_skip_relocation, catalina:       "57de9e02373b0ade740c14739fb42d17afa5108c2d14eda882d14c39234c3e83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81ec8a8ba96b20b9ef10103179359f26cd51ccfee4f624304ba69f8fb9e46a71"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "pydiffx" do
    url "https://files.pythonhosted.org/packages/e0/0c/296d4f8ebb4574214b66fcb491bd5f7aa1990683bef480f762ca1d1da9eb/pydiffx-1.0.1.tar.gz"
    sha256 "853216435008c23a0e2cd2c2a8ed15108bca449d6c31bc59d2e894246aff6bfa"
  end

  resource "texttable" do
    url "https://files.pythonhosted.org/packages/d5/78/dbc2a5eab57a01fedaf975f2c16f04e76f09336dbeadb9994258aa0a2b1a/texttable-1.6.4.tar.gz"
    sha256 "42ee7b9e15f7b225747c3fa08f43c5d6c83bc899f80ff9bae9319334824076e9"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/98/2a/838de32e09bd511cf69fe4ae13ffc748ac143449bfc24bb3fd172d53a84f/tqdm-4.64.0.tar.gz"
    sha256 "40be55d30e200777a307a7585aee69e4eabb46b4ec6a4b4a5f2d9f11e7d5408d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "git", "init"
    system "#{bin}/rbt", "setup-repo", "--server", "https://demo.reviewboard.org"
    out = shell_output("#{bin}/rbt clear-cache")
    assert_match "Cleared cache in", out
  end
end
