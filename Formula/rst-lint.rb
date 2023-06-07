class RstLint < Formula
  include Language::Python::Virtualenv

  desc "ReStructuredText linter"
  homepage "https://github.com/twolfson/restructuredtext-lint"
  url "https://files.pythonhosted.org/packages/48/9c/6d8035cafa2d2d314f34e6cd9313a299de095b26e96f1c7312878f988eec/restructuredtext_lint-1.4.0.tar.gz"
  sha256 "1b235c0c922341ab6c530390892eb9e92f90b9b75046063e047cacfb0f050c45"
  license "Unlicense"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "977a9d1c0f562445d972e95d59e883d26a7966b18ca3a124577936d8dde74018"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "977a9d1c0f562445d972e95d59e883d26a7966b18ca3a124577936d8dde74018"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "977a9d1c0f562445d972e95d59e883d26a7966b18ca3a124577936d8dde74018"
    sha256 cellar: :any_skip_relocation, ventura:        "c8bbc56f35fe2f218241996e273e173cbb2e19535ca95dd77bf97c6ce6ca5479"
    sha256 cellar: :any_skip_relocation, monterey:       "c8bbc56f35fe2f218241996e273e173cbb2e19535ca95dd77bf97c6ce6ca5479"
    sha256 cellar: :any_skip_relocation, big_sur:        "c8bbc56f35fe2f218241996e273e173cbb2e19535ca95dd77bf97c6ce6ca5479"
    sha256 cellar: :any_skip_relocation, catalina:       "c8bbc56f35fe2f218241996e273e173cbb2e19535ca95dd77bf97c6ce6ca5479"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "680297bd09a922363c112da4ce90736e24c732d5907727684625aa639ac777c3"
  end

  depends_on "docutils"
  depends_on "python@3.11"

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
