class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/6d/0e/0c41bda51d1bd283c69484c932646fcad0b5a36ff5ac9535e4be93aeb89c/virtualenv-20.16.1.tar.gz"
  sha256 "6cc42cad4d1a15c7ea5ed68e602eb49cc243b52d2eead36e577555cb56bf8705"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1fef39038ff53c6f971b71146772327c93aa35f59fdc099d5ce291df4ba35441"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6abcd5d36edcf31f079c73a34632cbb6376d9230e71e24644e12359c74d5b94e"
    sha256 cellar: :any_skip_relocation, monterey:       "6c91a4c1410c13382c7d4bf69a42f7df814704c3a14b19835ce2fd5de1c3c54c"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc2ac63e4c91098258e8c750804d310dea3ece2fda3d3378df8f3bfdbea04572"
    sha256 cellar: :any_skip_relocation, catalina:       "a6ed39216d987281126153e40ba2c926029f490a37de2089752008e1791b6a78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d71175d0b9fa947b297406894acbb669e608fbacf3552309589b1c60d96ca97f"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/31/d5/e2aa0aa3918c8d88c4c8e4ebbc50a840e101474b98cd83d3c1712ffe5bb4/distlib-0.3.5.tar.gz"
    sha256 "a7f75737c70be3b25e2bee06288cec4e4c221de18455b2dd037fe2a795cab2fe"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/f3/c7/5c1aef87f1197d2134a096c0264890969213c9cbfb8a4102087e8d758b5c/filelock-3.7.1.tar.gz"
    sha256 "3a0fd85166ad9dbab54c9aec96737b744106dc5f15c0b09a6744a445299fcf04"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/ff/7b/3613df51e6afbf2306fc2465671c03390229b55e3ef3ab9dd3f846a53be6/platformdirs-2.5.2.tar.gz"
    sha256 "58c8abb07dcb441e6ee4b11d8df0ac856038f944ab98b7be6b27b2a3c7feef19"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end
