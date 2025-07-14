class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/56/2c/444f465fb2c65f40c3a104fd0c495184c4f2336d65baf398e3c75d72ea94/virtualenv-20.31.2.tar.gz"
  sha256 "e10c0a9d02835e592521be48b332b6caee6887f332c111aa79a09b9e79efc2af"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d8d2567e3809e40e530c2fcf928bcc1e7e6affa708bb6fafa7a360038dae0f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d8d2567e3809e40e530c2fcf928bcc1e7e6affa708bb6fafa7a360038dae0f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1d8d2567e3809e40e530c2fcf928bcc1e7e6affa708bb6fafa7a360038dae0f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d853a4d494f78b89bbf20ba800b47f53014c5aa66aad3b897e611ebbc2da388"
    sha256 cellar: :any_skip_relocation, ventura:       "0d853a4d494f78b89bbf20ba800b47f53014c5aa66aad3b897e611ebbc2da388"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "062b68ff2df6b0a13e7186a81cb9d3e411d82f70d8c4ec0378d6acc0334285c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "062b68ff2df6b0a13e7186a81cb9d3e411d82f70d8c4ec0378d6acc0334285c2"
  end

  depends_on "python@3.13"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/0d/dd/1bec4c5ddb504ca60fc29472f3d27e8d4da1257a854e1d96742f15c1d02d/distlib-0.3.9.tar.gz"
    sha256 "a60f20dea646b8a33f3e7772f74dc0b2d0772d2837ee1342a00645c81edf9403"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/0a/10/c23352565a6544bdc5353e0b15fc1c563352101f30e24bf500207a54df9a/filelock-3.18.0.tar.gz"
    sha256 "adbc88eabb99d2fec8c9c1b229b171f18afa655400173ddc653d5d01501fb9f2"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/fe/8b/3c73abc9c759ecd3f1f7ceff6685840859e8070c4d947c93fae71f6a0bf2/platformdirs-4.3.8.tar.gz"
    sha256 "3d512d96e16bcb959a814c9f348431070822a6496326a4be0911c40b5a74c2bc"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end
