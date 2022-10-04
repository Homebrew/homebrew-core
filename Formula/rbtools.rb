class Rbtools < Formula
  include Language::Python::Virtualenv

  desc "CLI and API for working with code and document reviews on Review Board"
  homepage "https://www.reviewboard.org/downloads/rbtools/"
  url "https://files.pythonhosted.org/packages/79/fb/9fc2b00ec363cec85a70f3ffaf9d133495c2d5fb716ff9e5ebec5bf7035a/RBTools-3.1.2.tar.gz"
  sha256 "c83c0ed68ab998ac84cb759d809ad25e2bc4ae7d0d4e6b9f3e188db8440ae3b9"
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
    url "https://files.pythonhosted.org/packages/2b/65/24d033a9325ce42ccbfa3ca2d0866c7e89cc68e5b9d92ecaba9feef631df/colorama-0.4.5.tar.gz"
    sha256 "e6c6b4334fc50988a639d9b98aa429a0b57da6e17b9a44f0451f930b6967b7a4"
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
  end

  test do
    system "git", "init"
    system "#{bin}/rbt", "setup-repo", "--server", "https://demo.reviewboard.org"
    out = shell_output("#{bin}/rbt clear-cache")
    assert_match "Cleared cache in", out
  end
end
