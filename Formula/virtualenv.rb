class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/b8/5c/c6acf0fb35c2e830114a81ae771599e0dd11b5905f2386782fa2793ec6c8/virtualenv-20.15.0.tar.gz"
  sha256 "4c44b1d77ca81f8368e2d7414f9b20c428ad16b343ac6d226206c5b84e2b4fcc"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8345fdd7e3be051c84e93519befbed4726b91a919c8734b68426cb92e4995d4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8e872f10d76ca8688bc470bd626ef88ad1e5f8c03ccb466eaacfb456f10cee66"
    sha256 cellar: :any_skip_relocation, monterey:       "5d1395c85f34afdbc2b56d875f0deecf65f7199d4d5fc0bfb031fb9573299213"
    sha256 cellar: :any_skip_relocation, big_sur:        "8bd93388e695bd790889d3477f02dd10f200af4a03ef52da41eb3830d371f6d9"
    sha256 cellar: :any_skip_relocation, catalina:       "f9b4c57c175765f3c739e33712741979ff2de6d9092addb4479c7b5f0201818c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38f5c4383dce1fd2aca8bfdcacf68fd72c27dd2130caa7f7338922f7fcda53a2"
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
