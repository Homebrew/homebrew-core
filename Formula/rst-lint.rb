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

  depends_on "python@3.10"

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/57/b1/b880503681ea1b64df05106fc7e3c4e3801736cf63deffc6fa7fc5404cf5/docutils-0.18.1.tar.gz"
    sha256 "679987caf361a7539d76e584cbeddc311e3aee937877c87346f31debc63e9d06"
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
