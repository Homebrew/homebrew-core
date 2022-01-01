class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/96/68/d7a8456db669a0f8402ea5a6533d43bc687c37d0441eb147bc74b6ea182b/virtualenv-20.12.1.tar.gz"
  sha256 "d51ae01ef49e7de4d2b9d85b4926ac5aabc3f3879a4b4e4c4a8027fa2f0e4f6a"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f76a3275155e207313a2b5690dfe6497426e6fc60a1f0bc126027b88bf326693"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d082cd4b8e8241c81d8d42f1775409dad06037659d2569864b0c0f11e091c00"
    sha256 cellar: :any_skip_relocation, monterey:       "9dbc609d674d78d2ba34081a53fbf3781d5777302a1c3b77297deb38c6e378be"
    sha256 cellar: :any_skip_relocation, big_sur:        "cffaf048240a9027f7f5b4b1349262c61becdf00edc6ea7525afd4ee7d4b4dfa"
    sha256 cellar: :any_skip_relocation, catalina:       "9e9714a3937b61c8fd0ad07eedbd7b28986958b7efbbf9539a6c82dca97687a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0bfafb1c8a427c4970b2b96aef715f5a6bb906cb17f3b5892b84977a61c16ecb"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/85/01/88529c93e41607f1a78c1e4b346b24c74ee43d2f41cfe33ecd2e20e0c7e3/distlib-0.3.4.zip"
    sha256 "e4b58818180336dc9c529bfb9a0b58728ffc09ad92027a3f30b7cd91e3458579"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/11/d1/22318a1b5bb06c9be4c065ad6a09cb7bfade737758dc08235c99cd6cf216/filelock-3.4.2.tar.gz"
    sha256 "38b4f4c989f9d06d44524df1b24bd19e167d851f19b50bf3e3559952dddc5b80"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/be/00/bd080024010e1652de653bd61181e2dfdbef5fa73bfd32fec4c808991c31/platformdirs-2.4.1.tar.gz"
    sha256 "440633ddfebcc36264232365d7840a970e75e1018d15b4327d11f91909045fda"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end
