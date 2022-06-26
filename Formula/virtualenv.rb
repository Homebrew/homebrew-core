class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/b8/5c/c6acf0fb35c2e830114a81ae771599e0dd11b5905f2386782fa2793ec6c8/virtualenv-20.15.0.tar.gz"
  sha256 "4c44b1d77ca81f8368e2d7414f9b20c428ad16b343ac6d226206c5b84e2b4fcc"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "050306f785bb603427fb0cad0e69c94ec9829bada406f5f0e7aa58fd0762918a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac499f2fb05c4d4b0c104ba50851294abee1ab823ac71dd781815fa141306a4b"
    sha256 cellar: :any_skip_relocation, monterey:       "e27dd5e6b499261865f0fcd673542f812e7ae29bc5fc0b32fbee19870dfa1a16"
    sha256 cellar: :any_skip_relocation, big_sur:        "93aaaf29f185c9720d9541b30d3a15adcd56a51b2d1eed51f458d0424f020c2d"
    sha256 cellar: :any_skip_relocation, catalina:       "c885e2af9b74327b73c0f1ca144371d41f5c84a513f91835df3dc0cb5c965686"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22f96dce9b4e94c320324bb243c6e5ec907df26f8472cb48c66cac7ec54d8816"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/85/01/88529c93e41607f1a78c1e4b346b24c74ee43d2f41cfe33ecd2e20e0c7e3/distlib-0.3.4.zip"
    sha256 "e4b58818180336dc9c529bfb9a0b58728ffc09ad92027a3f30b7cd91e3458579"
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
