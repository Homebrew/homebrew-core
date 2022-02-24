class RstLint < Formula
  include Language::Python::Virtualenv

  desc "ReStructuredText linter"
  homepage "https://github.com/twolfson/restructuredtext-lint"
  url "https://files.pythonhosted.org/packages/48/9c/6d8035cafa2d2d314f34e6cd9313a299de095b26e96f1c7312878f988eec/restructuredtext_lint-1.4.0.tar.gz"
  sha256 "1b235c0c922341ab6c530390892eb9e92f90b9b75046063e047cacfb0f050c45"
  license "Unlicense"

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
