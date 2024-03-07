class RstLint < Formula
  include Language::Python::Virtualenv

  desc "ReStructuredText linter"
  homepage "https://github.com/twolfson/restructuredtext-lint"
  url "https://files.pythonhosted.org/packages/48/9c/6d8035cafa2d2d314f34e6cd9313a299de095b26e96f1c7312878f988eec/restructuredtext_lint-1.4.0.tar.gz"
  sha256 "1b235c0c922341ab6c530390892eb9e92f90b9b75046063e047cacfb0f050c45"
  license "Unlicense"

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2013010f0f3dcc1c2e868018e13c77e805ca45cb152f6acfae68a7badc362db4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "09d370fb0f3e19c7a1c7ed849460b5999d4b2aa3c85b1692a66310d1666880f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6e6c405acfb82857aa08fcdbf891cbaa3c1a56365cf80502fd8af584b5aff48"
    sha256 cellar: :any_skip_relocation, sonoma:         "eddb01270707c267cf7ec8a5ab305eeb9ae0eaf7c5aaa02c2fa1225540ebb482"
    sha256 cellar: :any_skip_relocation, ventura:        "83a5b7049353db3c3b5cd68261256734844f97e993e65dab8ca06e6b12875e46"
    sha256 cellar: :any_skip_relocation, monterey:       "775ade00686e821d32947f01d5918dd369244cc4004669b001d4ae2c09b272b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23f218209f20b76eeeec8fd8c1b9ad9a03071cf81c292d75581a3b8ab0402541"
  end

  depends_on "docutils"
  depends_on "python@3.12"

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
