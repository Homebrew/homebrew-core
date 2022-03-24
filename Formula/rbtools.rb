class Rbtools < Formula
  include Language::Python::Virtualenv

  desc "CLI and API for working with code and document reviews on Review Board"
  homepage "https://www.reviewboard.org/downloads/rbtools/"
  url "https://files.pythonhosted.org/packages/50/e6/461ac31f26064acf3a1ba1c5f3b75bf32bfb82732b5982c08455c0bc7fe8/RBTools-3.0.tar.gz"
  sha256 "344b81f23ff271d02d20fd8751c0de1dbad5271ef4b0e0ec1a1df6f540f66294"
  license "MIT"
  head "https://github.com/reviewboard/rbtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61fbb58c12263f9aacbcf55cfc82fe037f7c1c3e4ff4fcc66c118eb9a36226ce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "97b5537cbecb0546c35ec34f1a85ae1462237a646dacf198c7aea41f060093a3"
    sha256 cellar: :any_skip_relocation, monterey:       "aeae28bf5939133b4f12a686d28910a55de9c0ae9e3052cd8ae7a4c9d85875ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "de0bfda19e6c31a29e7d5b12571fb404d0b1da5a7f96ab2a6e7f8bd8e943fd95"
    sha256 cellar: :any_skip_relocation, catalina:       "8cdd3319dc129639bd2a17f3473935bb37591ad4a50a26578f6b7201a1199b74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2f4859711ee408d4a7285d9c7ffff5735fc52798c2c6f6af0518df96e632d35"
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
