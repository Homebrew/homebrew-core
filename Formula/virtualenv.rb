class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/ef/b1/7763026877df6533d5e1bab93af5708159c9d9fe0b43ed75d6ac15b5f9c9/virtualenv-20.16.0.tar.gz"
  sha256 "6cfedd21e7584124a1d1e8f3b6e74c0bf8aeea44d9884b6d2d7241de5361a73c"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ec4e5540f1b90f9b7d9c15702db1b4e048db06f27b45df5d4e31362cbaf3e04"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc755b5164627694d23c14fa0b16dac92a99a6b5fe1667158c7f4fd205836c9c"
    sha256 cellar: :any_skip_relocation, monterey:       "dc85ab86a98a9ec3aa0d981972ec6e4888394b38319d97f902afb50a3cdadb2f"
    sha256 cellar: :any_skip_relocation, big_sur:        "65999fcd3fe448e0f82a8923971194dbb7faedbfe0a7de8e33932b1218877e6b"
    sha256 cellar: :any_skip_relocation, catalina:       "e67fc4d0fdafb05ad867c350c6c09c07299657be5ff96ab467cf9a7523cb3ee9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e77fcf7a0ce7b058df8eb668a083665b38c449b4d3d5cb0a4d9c4844a001013"
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
