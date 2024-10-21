class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/10/7f/192dd6ab6d91ebea7adf6c030eaf549b1ec0badda9f67a77b633602f66ac/virtualenv-20.27.0.tar.gz"
  sha256 "2ca56a68ed615b8fe4326d11a0dca5dfbe8fd68510fb6c6349163bed3c15f2b2"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fffd040d4c2380da273741048b882fdf5515cb2d8274765a72ae6aad6634da1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fffd040d4c2380da273741048b882fdf5515cb2d8274765a72ae6aad6634da1e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fffd040d4c2380da273741048b882fdf5515cb2d8274765a72ae6aad6634da1e"
    sha256 cellar: :any_skip_relocation, sonoma:        "498b180a8409a544933d80403b43d732f670f75c3d30e6de6ae670b2ca2d6208"
    sha256 cellar: :any_skip_relocation, ventura:       "498b180a8409a544933d80403b43d732f670f75c3d30e6de6ae670b2ca2d6208"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8255659b0a2613160da72e12f2c3b73ad98bb9a4b2a37fcc1dd984526f88b721"
  end

  depends_on "python@3.13"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/0d/dd/1bec4c5ddb504ca60fc29472f3d27e8d4da1257a854e1d96742f15c1d02d/distlib-0.3.9.tar.gz"
    sha256 "a60f20dea646b8a33f3e7772f74dc0b2d0772d2837ee1342a00645c81edf9403"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/9d/db/3ef5bb276dae18d6ec2124224403d1d67bccdbefc17af4cc8f553e341ab1/filelock-3.16.1.tar.gz"
    sha256 "c249fbfcd5db47e5e2d6d62198e565475ee65e4831e2561c8e313fa7eb961435"
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
