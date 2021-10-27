class RstLint < Formula
  include Language::Python::Virtualenv

  desc "ReStructuredText linter"
  homepage "https://github.com/twolfson/restructuredtext-lint"
  url "https://files.pythonhosted.org/packages/45/69/5e43d0e8c2ca903aaa2def7f755b97a3aedc5793630abbd004f2afc3b295/restructuredtext_lint-1.3.2.tar.gz"
  sha256 "d3b10a1fe2ecac537e51ae6d151b223b78de9fafdd50e5eb6b08c243df173c80"
  license "Unlicense"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f38f4267988a8a15da26707c04bd7fe201a12ca94c43e7ac32a054953143f49"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9f38f4267988a8a15da26707c04bd7fe201a12ca94c43e7ac32a054953143f49"
    sha256 cellar: :any_skip_relocation, monterey:       "4e0d8defb5305731e9053120f61fba399c1fc2908367df0ce332acfc09d2550a"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e0d8defb5305731e9053120f61fba399c1fc2908367df0ce332acfc09d2550a"
    sha256 cellar: :any_skip_relocation, catalina:       "4e0d8defb5305731e9053120f61fba399c1fc2908367df0ce332acfc09d2550a"
    sha256 cellar: :any_skip_relocation, mojave:         "4e0d8defb5305731e9053120f61fba399c1fc2908367df0ce332acfc09d2550a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5492b290c6c3b00356c0d956ca4d270855c2852519114ade876c6ea5b183932"
  end

  depends_on "python@3.10"

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/2f/e0/3d435b34abd2d62e8206171892f174b180cd37b09d57b924ca5c2ef2219d/docutils-0.16.tar.gz"
    sha256 "c2de3a60e9e7d07be26b7f2b00ca0309c207e06c100f9cc2a94931fc75a478fc"
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
