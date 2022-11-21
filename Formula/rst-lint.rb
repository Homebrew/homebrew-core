class RstLint < Formula
  include Language::Python::Virtualenv

  desc "ReStructuredText linter"
  homepage "https://github.com/twolfson/restructuredtext-lint"
  url "https://files.pythonhosted.org/packages/48/9c/6d8035cafa2d2d314f34e6cd9313a299de095b26e96f1c7312878f988eec/restructuredtext_lint-1.4.0.tar.gz"
  sha256 "1b235c0c922341ab6c530390892eb9e92f90b9b75046063e047cacfb0f050c45"
  license "Unlicense"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a7f44fad9fa36f3cea3a00fa82551e5d207894382af0377950f135b077dc9ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a7f44fad9fa36f3cea3a00fa82551e5d207894382af0377950f135b077dc9ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a7f44fad9fa36f3cea3a00fa82551e5d207894382af0377950f135b077dc9ba"
    sha256 cellar: :any_skip_relocation, monterey:       "d4de260e262b373caea855d30ca2099352389e2ed4b2bc42d7fe5a71c49fee9b"
    sha256 cellar: :any_skip_relocation, big_sur:        "d4de260e262b373caea855d30ca2099352389e2ed4b2bc42d7fe5a71c49fee9b"
    sha256 cellar: :any_skip_relocation, catalina:       "d4de260e262b373caea855d30ca2099352389e2ed4b2bc42d7fe5a71c49fee9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14f8a2ecf4359b3cd5618a93ca86feb95c3cd97b03669eeae9d1131b1680e094"
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
