class RstLint < Formula
  include Language::Python::Virtualenv

  desc "ReStructuredText linter"
  homepage "https://github.com/twolfson/restructuredtext-lint"
  url "https://files.pythonhosted.org/packages/fd/6a/7ded74d30148c0ac23fc8092adc0985069f779af6ddc6a3c5b939f3c06a1/restructuredtext_lint-2.0.0.tar.gz"
  sha256 "0d0d6a6766eb38e25abec7655b4a7806ce9441d5365a68e656cbb691527e6a45"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c2e88b7f8cbb985e6da3a2a2bc4ce53a3009fe3ca27d40dc341cfce8deefb4c3"
  end

  depends_on "python@3.14"

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/d9/02/111134bfeb6e6c7ac4c74594e39a59f6c0195dc4846afbeac3cba60f1927/docutils-0.22.3.tar.gz"
    sha256 "21486ae730e4ca9f622677b1412b879af1791efcfba517e4c6f60be543fc8cdd"
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
    assert_empty shell_output("#{bin}/rst-lint pass.rst")

    # test invocation on a file with a whitespace style issue
    (testpath/"fail.rst").write <<~EOS
      Hello World
      ==========
    EOS
    output = shell_output("#{bin}/rst-lint fail.rst", 2)
    assert_match "WARNING fail.rst:2 Title underline too short.", output
  end
end
