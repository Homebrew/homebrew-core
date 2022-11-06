class RstLint < Formula
  include Language::Python::Virtualenv

  desc "ReStructuredText linter"
  homepage "https://github.com/twolfson/restructuredtext-lint"
  url "https://files.pythonhosted.org/packages/48/9c/6d8035cafa2d2d314f34e6cd9313a299de095b26e96f1c7312878f988eec/restructuredtext_lint-1.4.0.tar.gz"
  sha256 "1b235c0c922341ab6c530390892eb9e92f90b9b75046063e047cacfb0f050c45"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "beb5f0802720f3e66b214d3e5fb1e241c88cf49b854536dba364010560f371fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "beb5f0802720f3e66b214d3e5fb1e241c88cf49b854536dba364010560f371fc"
    sha256 cellar: :any_skip_relocation, monterey:       "47eabdd2dd739cc65455fda75be0a11e563758e1f2c557b3b6e959a6fef84ac2"
    sha256 cellar: :any_skip_relocation, big_sur:        "47eabdd2dd739cc65455fda75be0a11e563758e1f2c557b3b6e959a6fef84ac2"
    sha256 cellar: :any_skip_relocation, catalina:       "47eabdd2dd739cc65455fda75be0a11e563758e1f2c557b3b6e959a6fef84ac2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7467b4f1729ea1b4c16306bcfe6dcb8e7668ef15537e5aaf4a85b87d6e20dc97"
  end

  depends_on "python@3.11"

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/6b/5c/330ea8d383eb2ce973df34d1239b3b21e91cd8c865d21ff82902d952f91f/docutils-0.19.tar.gz"
    sha256 "33995a6753c30b7f577febfc2c50411fec6aac7f7ffeb7c4cfe5991072dcf9e6"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # test invocation on a file with no issues
    (testpath/"pass.rst").write <<~EOS
      Hello World
      ===========
    EOS
    assert_equal "", shell_output("#{bin}/rst-lint pass.rst")

    # test invocation on a file with a whitespace style issue
    (testpath/"fail.rst").write <<~EOS
      Hello World
      ==========
    EOS
    output = shell_output("#{bin}/rst-lint fail.rst", 2)
    assert_match "WARNING fail.rst:2 Title underline too short.", output
  end
end
