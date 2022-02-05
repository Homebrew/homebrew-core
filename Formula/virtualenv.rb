class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/9f/85/a968cda343234cd22265ddea1cb7801e25eb1536081099d7016ca7e105c1/virtualenv-20.13.1.tar.gz"
  sha256 "e0621bcbf4160e4e1030f05065c8834b4e93f4fcc223255db2a823440aca9c14"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70ec6a67f0120088513cd561535ba207435f75b773d5b16b288be9d7624e77ee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ed96108b6112bc9ae3a8a266be3f5a31f2b607aa5b2a37ec49b92cf482fcfa9e"
    sha256 cellar: :any_skip_relocation, monterey:       "7af34d45c83a383e34a83d155582ab7199fdb458b3f91557e658c2d664664538"
    sha256 cellar: :any_skip_relocation, big_sur:        "e4bfdf68ad50042c19de3e35fccdf064a21f978f291bb3027ce718d02ea1e7e8"
    sha256 cellar: :any_skip_relocation, catalina:       "fced420e54cfc830f15dcb7dbda6a4481da686f89d079636f1b805a0be75b738"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "074a6764ff657a51ab656bb50a120daa7c2af3e1ccc7b60b4d1361edf3c3a2bb"
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
