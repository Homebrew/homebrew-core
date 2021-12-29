class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/29/25/e9626115f1be59b3890ad480d174343fae96045ebac337eed4ede0b3dfd6/virtualenv-20.11.1.tar.gz"
  sha256 "17f26e9d0c4350d9df713d41077b2b3344cba59e104306e4105c8c75deeddcf7"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8dac2d45665c28632a0b739d3a569bd6d34787295d67eaa1ff6aaa21d758e472"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "481bc49962fe63b3fe44775bbbc5419998e727d15ed4196b72143d86bfcba04c"
    sha256 cellar: :any_skip_relocation, monterey:       "7a23f32da846a4cb4160577d0bca38851cf052b1504f88ef2fe0bebaeb62ee41"
    sha256 cellar: :any_skip_relocation, big_sur:        "ccc8660928b21b1d091b8bea47991219f60e75bdb646a2a64674f393fdf6ea70"
    sha256 cellar: :any_skip_relocation, catalina:       "79b14a9c8a7fc6228914246a59b2cdf83b5ddc3a6d609728c79040d44e57d8b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f41c33aa15e66c3f8be75624f4c8dcd9302cefbbbdf12e2704fb9f76b13762dc"
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
