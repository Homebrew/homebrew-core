class Trzsz < Formula
  include Language::Python::Virtualenv

  desc "Simple file transfer tools, similar to lrzsz (rz/sz), and compatible with tmux"
  homepage "https://trzsz.github.io"
  url "https://files.pythonhosted.org/packages/c1/8f/f99cd5ad86d07a13885a78a83edf95bb8b9ff254d3b8c25b4437b6c35b49/trzsz-1.1.7.tar.gz"
  sha256 "72c7dc2b28e417101ccf8bf59e4fb0d28f4d54cbeb5acd5d08c4d6968e2ca6af"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b849158b67971110b9d8f407b583ca872faf3c8fe34c4c5dfbdcc1ee79d0d628"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d07fc8f0ea203b4b3256ddb4f86c21319130317d1486058862e75b6cc5780ee8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "43bbe239f66e93a82c1726608575ddda47d0975130f6033ad0587c0f5d3fc8ad"
    sha256 cellar: :any,                 arm64_linux:       "380b3410682f83fba71d99494a192f9cfb01738e586e6e05311de19369f6fd37"
    sha256 cellar: :any,                 x86_64_linux:      "979d84676108503428ca5826bf9edb11961924def7bdfab297ea0c4759e1bdfb"
  end

  depends_on "python@3.15"

  conflicts_with "trzsz-go", because: "both install `trz`, `tsz` binaries"

  pypi_packages extra_packages: "trzsz-iterm2"

  resource "iterm2" do
    url "https://files.pythonhosted.org/packages/e2/be/ce305245d48e43d014d5de6fa4df05ed5900e50c24830b69ea26eca8e358/iterm2-2.25.tar.gz"
    sha256 "19a214bc27e780265527edd99403297432b1611ff2b8213b4675b25d646cb4a8"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/d9/89/5b8517baa72f84a67b8a307ba953c91057af618bf40bf676f3c03551f8f0/protobuf-7.36.2.tar.gz"
    sha256 "497d0463ff3316681da6c0b9e8d06cb465d61abce00b613ab42226175644d1bb"
  end

  resource "trzsz-iterm2" do
    url "https://files.pythonhosted.org/packages/41/c6/a8b16af3a7a2e0b85ceb1d270e4493edb464af7144c8f49a5ade2bf9f45a/trzsz_iterm2-1.1.7.tar.gz"
    sha256 "2d93969c57df4642a92e44bdf960b2b0c5fad07f4111b9045c33b920abccbc41"
  end

  resource "trzsz-libs" do
    url "https://files.pythonhosted.org/packages/fb/4d/017a7455f9bba3649a09272877f576e80968adf8b592b3469c7f72d49247/trzsz_libs-1.1.7.tar.gz"
    sha256 "287e3005d8ae14f7b0bbda8808f3fd5e4ca401e5d86e7e5ac53b88acedcd9f60"
  end

  resource "trzsz-svr" do
    url "https://files.pythonhosted.org/packages/70/26/41da498a42038f11019738f0454428c963638b8feea98744a14e341b07ee/trzsz_svr-1.1.7.tar.gz"
    sha256 "2261a2ae2324b050524465e306a30ddf6ede6a1aeb1a4eac6423414044fd7599"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/01/89/3f825ab71c242fffb62ea8fe638741c290f62f8d7aadf8125ff897747af3/websockets-17.2.tar.gz"
    sha256 "36c2fb94c990cc2545143b12690e2de6c16300f9dbe5b4f33fa300cf57dc8792"
  end

  def install
    virtualenv_install_with_resources
    bin.install_symlink libexec/"bin/trz"
    bin.install_symlink libexec/"bin/tsz"
    bin.install_symlink libexec/"bin/trzsz-iterm2"
  end

  test do
    assert_match "trz (trzsz) py #{version}", shell_output("#{bin}/trz -v")
    assert_match "tsz (trzsz) py #{version}", shell_output("#{bin}/tsz -v")
    assert_match "trzsz-iterm2 (trzsz) py #{version}", shell_output("#{bin}/trzsz-iterm2 -v")

    touch "tmpfile"
    assert_match "Not a directory", shell_output("#{bin}/trz tmpfile 2>&1")

    rm "tmpfile"
    assert_match "No such file", shell_output("#{bin}/tsz tmpfile 2>&1")

    assert_match "arguments are required", shell_output("#{bin}/trzsz-iterm2 2>&1", 2)
  end
end
