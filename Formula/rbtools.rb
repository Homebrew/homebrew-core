class Rbtools < Formula
  include Language::Python::Virtualenv

  desc "CLI and API for working with code and document reviews on Review Board"
  homepage "https://www.reviewboard.org/downloads/rbtools/"
  url "https://files.pythonhosted.org/packages/d2/ce/363101545b7a61dac2ab94f5a718ac9e2120d1dda3b2bc5acb40f8034eef/RBTools-4.0.tar.gz"
  sha256 "67556ba8ce2e9977c4a4a5e14c4785cbe9215be56d04f8167fd703a4ae0f266f"
  license "MIT"
  head "https://github.com/reviewboard/rbtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea8ce92df678eb844bd665b82aeb914a49796d7768157c8e5215ce7c30404d63"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3cab2b8caa619e1866375de504103ae8d098373dfd0c3c0ed7744e9d13bae92e"
    sha256 cellar: :any_skip_relocation, monterey:       "b79b161855eaddb1bf77f07b758d90fd80d4adc7360fa01fd9019986ac9ada2b"
    sha256 cellar: :any_skip_relocation, big_sur:        "aad18b97c776b8632b9e5512b4aa17df4f18b4fff2a1130f210d3cac2bfe4ede"
    sha256 cellar: :any_skip_relocation, catalina:       "dbf269465e0d6a9667f396ec6b22afd286abe3c6c2adb5375dda73724db51f65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b598e8f785e590480593e094306a107757d6b880b8ad35af7ee51004c27db0f"
  end

  depends_on "python-typing-extensions"
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
