class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/c7/9c/57d19fa093bcf5ac61a48087dd44d00655f85421d1aa9722f8befbf3f40a/virtualenv-20.29.3.tar.gz"
  sha256 "95e39403fcf3940ac45bc717597dba16110b74506131845d9b687d5e73d947ac"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c888013eaf097b93f06e4f1ee69370db5462cd6453434b22fb9142977be74f9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c888013eaf097b93f06e4f1ee69370db5462cd6453434b22fb9142977be74f9f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c888013eaf097b93f06e4f1ee69370db5462cd6453434b22fb9142977be74f9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "88a9890fd89d9e4227b07d686671cf3b1d77e6a0bcd38539ed03449375364b4a"
    sha256 cellar: :any_skip_relocation, ventura:       "88a9890fd89d9e4227b07d686671cf3b1d77e6a0bcd38539ed03449375364b4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f25b7ca7024eb19b1f02e4a7368c3051a6bcef5cfc7ad20044a4e704b996942c"
  end

  depends_on "python@3.13"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/0d/dd/1bec4c5ddb504ca60fc29472f3d27e8d4da1257a854e1d96742f15c1d02d/distlib-0.3.9.tar.gz"
    sha256 "a60f20dea646b8a33f3e7772f74dc0b2d0772d2837ee1342a00645c81edf9403"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/dc/9c/0b15fb47b464e1b663b1acd1253a062aa5feecb07d4e597daea542ebd2b5/filelock-3.17.0.tar.gz"
    sha256 "ee4e77401ef576ebb38cd7f13b9b28893194acc20a8e68e18730ba9c0e54660e"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/13/fc/128cc9cb8f03208bdbf93d3aa862e16d376844a14f9a0ce5cf4507372de4/platformdirs-4.3.6.tar.gz"
    sha256 "357fb2acbc885b0419afd3ce3ed34564c13c9b95c89360cd9563f73aa5e2b907"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end
