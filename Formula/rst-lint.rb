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
    sha256 "46d51dedf610ea9518195fb7e2f1d8a3298b4640b3ae490cfbb212ca665132b2" => :big_sur
    sha256 "7c6ef27de3684c2b642bb510abf6834ff7fea8a142cc1c95f754fff31a354270" => :arm64_big_sur
    sha256 "7dced462fec105930e7c757faf9065d8e82cf73299440ee7a67834ba7a1d813f" => :catalina
    sha256 "3f9bcd92d9df3e9f7c6a6aeb1bc395f9bcfeb963efd597c832c438b62040b3c3" => :mojave
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
