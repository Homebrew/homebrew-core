class RstLint < Formula
  include Language::Python::Virtualenv

  desc "ReStructuredText linter"
  homepage "https://github.com/twolfson/restructuredtext-lint"
  url "https://files.pythonhosted.org/packages/ca/e6/eefcad2228f4124f17e01064428fbcd0ade06a274f3063ce3a126a569d6b/restructuredtext_lint-2.0.2.tar.gz"
  sha256 "dd25209b9e0b726929d8306339faf723734a3137db382bcf27294fa18a6bc52b"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "185f8cb77b1622016cf30ee43d7aaf5674fe67c424bc5b706a38515f538bcf7e"
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
