class RstLint < Formula
  include Language::Python::Virtualenv

  desc "ReStructuredText linter"
  homepage "https://github.com/twolfson/restructuredtext-lint"
  url "https://files.pythonhosted.org/packages/45/69/5e43d0e8c2ca903aaa2def7f755b97a3aedc5793630abbd004f2afc3b295/restructuredtext_lint-1.3.2.tar.gz"
  sha256 "d3b10a1fe2ecac537e51ae6d151b223b78de9fafdd50e5eb6b08c243df173c80"
  license "Unlicense"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "297a26765ed29b28f2ec1e6cf28e8fafed936a2c255f0e690b412b08714bb3a0" => :big_sur
    sha256 "f156a31ad65e1a3e56b7f45b1da4eb511ac5d3a371cfc8a3cbf4989aafae0f45" => :arm64_big_sur
    sha256 "4b462c6a7aad71c3c30db75f957616d8130c371ce0b4e0578ff3d3558d7a4127" => :catalina
    sha256 "d4b15aa742bb6c4131abca592f5de3ad7095cdc41353c66ef605abb2f4e4d71c" => :mojave
  end

  depends_on "python@3.9"

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
