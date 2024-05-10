class RstLint < Formula
  include Language::Python::Virtualenv

  desc "ReStructuredText linter"
  homepage "https://github.com/twolfson/restructuredtext-lint"
  url "https://files.pythonhosted.org/packages/48/9c/6d8035cafa2d2d314f34e6cd9313a299de095b26e96f1c7312878f988eec/restructuredtext_lint-1.4.0.tar.gz"
  sha256 "1b235c0c922341ab6c530390892eb9e92f90b9b75046063e047cacfb0f050c45"
  license "Unlicense"

  bottle do
    rebuild 6
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e905e695e089e2c31d67b53fad2b3162e7e1b3c27068535ab6fe9c5eed55d367"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e905e695e089e2c31d67b53fad2b3162e7e1b3c27068535ab6fe9c5eed55d367"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e905e695e089e2c31d67b53fad2b3162e7e1b3c27068535ab6fe9c5eed55d367"
    sha256 cellar: :any_skip_relocation, sonoma:         "e905e695e089e2c31d67b53fad2b3162e7e1b3c27068535ab6fe9c5eed55d367"
    sha256 cellar: :any_skip_relocation, ventura:        "e905e695e089e2c31d67b53fad2b3162e7e1b3c27068535ab6fe9c5eed55d367"
    sha256 cellar: :any_skip_relocation, monterey:       "e905e695e089e2c31d67b53fad2b3162e7e1b3c27068535ab6fe9c5eed55d367"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0cb2d8ff6a65493086ab426e3391cff943cd74e3521859f3728427cc7472591"
  end

  depends_on "python@3.12"

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/1f/53/a5da4f2c5739cf66290fac1431ee52aff6851c7c8ffd8264f13affd7bcdd/docutils-0.20.1.tar.gz"
    sha256 "f08a4e276c3a1583a86dce3e34aba3fe04d02bba2dd51ed16106244e8a923e3b"
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
