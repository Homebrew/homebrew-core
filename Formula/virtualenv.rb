class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/4a/c3/04f361a90ed4e6b3f3f696d61db5c786eaa741d2a6c125bc905b8a1c0200/virtualenv-20.14.0.tar.gz"
  sha256 "8e5b402037287126e81ccde9432b95a8be5b19d36584f64957060a3488c11ca8"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48e8a8e589283796cdd8df92158b88aa721a850bc31f2a2036be2015e5030971"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9da16b247781bf499d9414f6dee71c174f9d0bd4d2458c94278e953fa7cc89f1"
    sha256 cellar: :any_skip_relocation, monterey:       "c5b0ca7613344d966d30dc1f349caaf34b7fb890839287d71f54b0d7a0b4e70c"
    sha256 cellar: :any_skip_relocation, big_sur:        "8212ab02ce355fdebe3441e32371b33adb37e8d69481880cf0b6fabb0ecd2320"
    sha256 cellar: :any_skip_relocation, catalina:       "4426395cced6733cc8e0b219a59c8660c5e146c2941f4101693cc3f3b31e8e7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "434d067a301b5c6fec6b3cc442edb52c68f4519e4847c95f33b2b2283dcf4d5d"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/85/01/88529c93e41607f1a78c1e4b346b24c74ee43d2f41cfe33ecd2e20e0c7e3/distlib-0.3.4.zip"
    sha256 "e4b58818180336dc9c529bfb9a0b58728ffc09ad92027a3f30b7cd91e3458579"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/4d/cd/3b1244a19d61c4cf5bd65966eef97e6bc41e51fe84110916f26554d6ac8c/filelock-3.6.0.tar.gz"
    sha256 "9cd540a9352e432c7246a48fe4e8712b10acb1df2ad1f30e8c070b82ae1fed85"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/33/66/61da40aa546141b0d70b37fe6bb4ef1200b4b4cb98849f131b58faa9a5d2/platformdirs-2.5.1.tar.gz"
    sha256 "7535e70dfa32e84d4b34996ea99c5e432fa29a708d0f4e394bbcb2a8faa4f16d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end
