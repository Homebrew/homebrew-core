class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/9f/85/a968cda343234cd22265ddea1cb7801e25eb1536081099d7016ca7e105c1/virtualenv-20.13.1.tar.gz"
  sha256 "e0621bcbf4160e4e1030f05065c8834b4e93f4fcc223255db2a823440aca9c14"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "165d03f58847450bba58e6acec45f54b10406bf4150c49498fc742acf5f9b042"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f38cb7a6d8e2feb3a39e57508c6f525857ec8735672d2b512eb285433a77388"
    sha256 cellar: :any_skip_relocation, monterey:       "c5bb7765c52792b1506d1e1210438e3fb969d97a816ba3bef19a4dc80c82f68e"
    sha256 cellar: :any_skip_relocation, big_sur:        "b11be71b4661ef9f943342f74134ad7d10644f2c53bfd009621e823e8e38a3d3"
    sha256 cellar: :any_skip_relocation, catalina:       "08ff864a43f2a18333fa92d83d1be047f2e06c0cf9696371bc95103b10261134"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65d96f297af0eab67de1678fe902760edc022b0818da493ccebd12cf231fc4c3"
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
