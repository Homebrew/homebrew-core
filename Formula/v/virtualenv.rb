class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/3f/40/abc5a766da6b0b2457f819feab8e9203cbeae29327bd241359f866a3da9d/virtualenv-20.26.6.tar.gz"
  sha256 "280aede09a2a5c317e409a00102e7077c6432c5a38f0ef938e643805a7ad2c48"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ce1b84c047934f33e3e5374bb11a32a34b2e5447139012bf54c99fb37eb707c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ce1b84c047934f33e3e5374bb11a32a34b2e5447139012bf54c99fb37eb707c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2ce1b84c047934f33e3e5374bb11a32a34b2e5447139012bf54c99fb37eb707c"
    sha256 cellar: :any_skip_relocation, sonoma:        "289136ae1fe80ca772018604aeedfbdb15ce002d15ec142a59acfa119f4b8c8f"
    sha256 cellar: :any_skip_relocation, ventura:       "289136ae1fe80ca772018604aeedfbdb15ce002d15ec142a59acfa119f4b8c8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3518a5231c088a5c51b15289df55391c9abcafa7111b9701fd06eb46f42b4e8"
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
