class Rbtools < Formula
  include Language::Python::Virtualenv

  desc "CLI and API for working with code and document reviews on Review Board"
  homepage "https://www.reviewboard.org/downloads/rbtools/"
  url "https://files.pythonhosted.org/packages/68/19/48f2e95bccac4299cdd75932e812cff9f0a0bd802afeb67027563b162ee4/RBTools-3.1.tar.gz"
  sha256 "a185dd9c4b42eeda6b611135b3a814cc01c9b870519a3b6d6d7e7401592692f9"
  license "MIT"
  head "https://github.com/reviewboard/rbtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2acfa6cccb168097c2f6ab2998c8296cf1ab2e8b76a67b5c33e044811abc8df"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "16ed4c6c8285943b06397b811cf4d143014c30d1e80e82080bb82ed2944a04a0"
    sha256 cellar: :any_skip_relocation, monterey:       "3e8b284cdb2ec40b50215f205e6e695814e3fdd58fb7abf915a02c108dc2fee7"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0a75a64077db79439ec71044d820108792196223d7c70fb806c0dbbc3a025f3"
    sha256 cellar: :any_skip_relocation, catalina:       "cae882c759abd127a2ef2afc4476a54f13a59d05cfd0d93963bd546799ade086"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4936682850ec625ae854d0804229825669f18adac88243dfca8ae06da3634989"
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
