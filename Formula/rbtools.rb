class Rbtools < Formula
  include Language::Python::Virtualenv

  desc "CLI and API for working with code and document reviews on Review Board"
  homepage "https://www.reviewboard.org/downloads/rbtools/"
  url "https://files.pythonhosted.org/packages/79/fb/9fc2b00ec363cec85a70f3ffaf9d133495c2d5fb716ff9e5ebec5bf7035a/RBTools-3.1.2.tar.gz"
  sha256 "c83c0ed68ab998ac84cb759d809ad25e2bc4ae7d0d4e6b9f3e188db8440ae3b9"
  license "MIT"
  head "https://github.com/reviewboard/rbtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b642bb8943ed86f1d990f03e1288987859aad5a638ab931a0fb35104e20ce5a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b0479bb63b3f1c257a192690b8c19cbaf47673d6c9c45e6917407660b58b14e"
    sha256 cellar: :any_skip_relocation, monterey:       "82b298f78ac7f1b9c7d3ef7e6aaad771d2f3c819f04a1881b6136252866e8c91"
    sha256 cellar: :any_skip_relocation, big_sur:        "8cdf17d1d4ed32dab74d8301d5dac8bd150b428f30cd8ddfcbe30662a0ec910c"
    sha256 cellar: :any_skip_relocation, catalina:       "2a1020b895e0f389bc8b65f9a6da0d7a31693c18ae3dc6a4ee363d9b9910a3db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "923f925be9eec7df0faa5a14ebd62b70d5af72957bd4d257fa44cb41a77e8b3f"
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
