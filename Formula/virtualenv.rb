class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/57/60/e31195bb422c2c6ecc52b456855eb6be7dc53a5df583e3628626fd8c5718/virtualenv-20.11.0.tar.gz"
  sha256 "2f15b9226cb74b59c21e8236dd791c395bee08cdd33b99cddd18e1f866cdb098"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce2901614eb28e009f454472c28eac2ddb73312edcfbe7ecf856e839447bed1b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e243a4b3be1875d313c17021a39bfca69f8adffe1835317bc31214f5c17b027d"
    sha256 cellar: :any_skip_relocation, monterey:       "9391a498f1cc93c3b2e2c72cf0700f270ec8d223d5dedf8baef8ca9b58bdfb75"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ca54ec5105fd918ddfe32c3ba9d36402eebb08859f43bdcfbf66a17c70b69e8"
    sha256 cellar: :any_skip_relocation, catalina:       "4455eb82c916514636f7c0641f0daa2b651c5ad89add521323fb615e53ec4362"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c577f3965af7150bffa171b03248c3f28165f51ea7c9e6399afd671a3dc20cf2"
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
