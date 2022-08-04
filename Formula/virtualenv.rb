class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/3c/ea/a39a173e7943a8f001e1f97326f88e1535b945a3aec31130c3029dce19df/virtualenv-20.16.3.tar.gz"
  sha256 "d86ea0bb50e06252d79e6c241507cb904fcd66090c3271381372d6221a3970f9"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa11d9e9f546dee60b88bdf1755203abd1e905cf0d6524660a0d9d2addf33ba0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "153ba17eb36ab031b963ce7e54210f6420ec5dd426fc078db121e3a163f09fcd"
    sha256 cellar: :any_skip_relocation, monterey:       "3ad864105e461fe090ba8cf8ff29e105ddaf5ae176e75a40e7406235b2963ed4"
    sha256 cellar: :any_skip_relocation, big_sur:        "208e319ccf6978e37ad663cb7b9704dc3ede30adfe6fcaa1063181af29888c5b"
    sha256 cellar: :any_skip_relocation, catalina:       "507354fe5041b30c4c624485453b8406d66517682ef64e23aed804d5de67d55d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c9e2b2c6cad19271d678d7f6fa4ee3844bc71efa7c16aee1db5fb04099cb418"
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
