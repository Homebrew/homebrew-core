class Trzsz < Formula
  include Language::Python::Virtualenv

  desc "Simple file transfer tools, similar to lrzsz (rz/sz), and compatible with tmux"
  homepage "https://trzsz.github.io"
  url "https://files.pythonhosted.org/packages/50/01/b8679a72c0604c964a6c4f46f100fa707ecad97c34f61e58334f764e9cca/trzsz-0.3.1.tar.gz"
  sha256 "97b008cd5441583e9090c9078854e90b3cdfe2fd95a1cfb717efee1b935a7737"
  license "MIT"

  depends_on "python@3.10"

  resource "trzsz-libs" do
    url "https://files.pythonhosted.org/packages/5e/c3/a5134c70082e80d402594b45e5d6a246f0e34a2fd5004bc83bb116a7ff14/trzsz-libs-0.3.1.tar.gz"
    sha256 "bea662ff2f553aae057910dc7427b235370e9c822ec3a4ad27cb1220f98d5e8d"
  end

  resource "trzsz-svr" do
    url "https://files.pythonhosted.org/packages/e9/7a/147baf7c62f25bc39c50dbdbad469da9536c592cc53de9cfb71c86256a1c/trzsz-svr-0.3.1.tar.gz"
    sha256 "5e2334b402a968936df312fcfaf81628c1fae08e63aa086fbfd6adacf4b89257"
  end

  resource "trzsz-iterm2" do
    url "https://files.pythonhosted.org/packages/3e/5b/81e0de0f52895439be6bde9e0152c4e9abb54eb5a2215e03972c47d378d8/trzsz-iterm2-0.3.1.tar.gz"
    sha256 "75fefed756dc1577d84c14b0d3eac90050229063d1403f3f83bf0dcc8df8f0de"
  end

  def install
    virtualenv_install_with_resources
    bin.install_symlink libexec/"bin/trz"
    bin.install_symlink libexec/"bin/tsz"
    bin.install_symlink libexec/"bin/trzsz-iterm2"
  end

  test do
    assert_match "trz (trzsz)", shell_output("#{bin}/trz -v")
    assert_match "tsz (trzsz)", shell_output("#{bin}/tsz -v")
    assert_match "trzsz-iterm2 (trzsz)", shell_output("#{bin}/trzsz-iterm2 -v")

    touch "tmpfile"
    assert_match "Not a directory", shell_output("#{bin}/trz tmpfile 2>&1")

    rm "tmpfile"
    assert_match "No such file", shell_output("#{bin}/tsz tmpfile 2>&1")

    assert_match "arguments are required", shell_output("#{bin}/trzsz-iterm2 2>&1", 2)
  end
end
