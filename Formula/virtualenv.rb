class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/9d/17/5a822952d90f791947f9d1d11c84c055ffc3b7a315c2552d4f46a0d6cd12/virtualenv-20.16.2.tar.gz"
  sha256 "0ef5be6d07181946891f5abc8047fda8bc2f0b4b9bf222c64e6e8963baee76db"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df0f386e8ea7fb87d10fdb3db0ed9319627ca36da53874cb312c4fd1b8b1df68"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "85ba2c6470810215a48defd2d347cfafe1f120c2c921d762ba553fda84602ca7"
    sha256 cellar: :any_skip_relocation, monterey:       "8251971ff519060a20adeee4a105c59980ec45c43a66b4d9bb9a9f46e2ab3b54"
    sha256 cellar: :any_skip_relocation, big_sur:        "85dabe4375ec6e3eddc1ac753cb04f0071b7c5ac4453100a5bfdd8f2fa924f54"
    sha256 cellar: :any_skip_relocation, catalina:       "8c6907c86318205b96fea4a943d03ed1d96f2688426c7e7d7a5e4a14c235ecae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88520cca8b47c6567a7c6f376d905092aca844a5a1824c8c3e721888e126a31e"
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
