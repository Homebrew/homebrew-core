class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/6a/95/01db50116d85cd4604b570c370a3b718de99ac44c95d3ee27a753f7ff02a/virtualenv-20.11.2.tar.gz"
  sha256 "7f9e9c2e878d92a434e760058780b8d67a7c5ec016a66784fe4b0d5e50a4eb5c"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c626fd21874ad8260e71ff63ed1d73a3cf09fcf3bfebcf4bb1abea6bc07573b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9434f07deff505cdf0b9bf477adea291f791ff440fb31bdbc70a11f894a285e1"
    sha256 cellar: :any_skip_relocation, monterey:       "3e442afc139e89cf5bb24c2bc18ce1456fee2d7e731b07737e17ccbc7beab440"
    sha256 cellar: :any_skip_relocation, big_sur:        "7882cbef36d5fd0d28213ce474e5f276bdf20673088266811df8efcb69632128"
    sha256 cellar: :any_skip_relocation, catalina:       "8a15c5a398cdcc13aba6c811d6831e3525e262b4f8355d68ecafbbb295650813"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e32320cb619d14a67931345a6f91304e8153efe4541a9d403054853aed03e0a8"
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
