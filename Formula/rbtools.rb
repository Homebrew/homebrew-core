class Rbtools < Formula
  include Language::Python::Virtualenv

  desc "CLI and API for working with code and document reviews on Review Board"
  homepage "https://www.reviewboard.org/downloads/rbtools/"
  url "https://files.pythonhosted.org/packages/50/e6/461ac31f26064acf3a1ba1c5f3b75bf32bfb82732b5982c08455c0bc7fe8/RBTools-3.0.tar.gz"
  sha256 "344b81f23ff271d02d20fd8751c0de1dbad5271ef4b0e0ec1a1df6f540f66294"
  license "MIT"
  head "https://github.com/reviewboard/rbtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "445427064b85368a7212172972481aea4fc53a51f17b82bd0140056a7eda27c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf7d5f2acc18804b3df7972f615259422b2334982c67c9e804837ee89ef1713c"
    sha256 cellar: :any_skip_relocation, monterey:       "144152843b36fcd76c3fe84b8a14f76442d6a82863c81d474ca83e394672806a"
    sha256 cellar: :any_skip_relocation, big_sur:        "10d468168e0f8a76694e044cfbb775228110e417ff382f675ee966c8eb02c27c"
    sha256 cellar: :any_skip_relocation, catalina:       "f07f1d3b118761076d77532e415fb725d284f1a4e131826119e81128d33b2c04"
    sha256 cellar: :any_skip_relocation, mojave:         "b4a7c29fa71adde81123ce5bc2b9219ea49026ab0726168da7d8e10adc9ad20d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19cfd5c8412bb1c3d79f530bd097cd4187ec3fec8673fbf29cd5e1b12e906ff9"
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
    url "https://files.pythonhosted.org/packages/cb/a5/803a55cae355bc2402492c6a1c23dc08117844e4a1c3a293b0ea19bca6fa/tqdm-4.63.0.tar.gz"
    sha256 "1d9835ede8e394bb8c9dcbffbca02d717217113adc679236873eeaac5bc0b3cd"
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
