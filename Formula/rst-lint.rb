class RstLint < Formula
  include Language::Python::Virtualenv

  desc "ReStructuredText linter"
  homepage "https://github.com/twolfson/restructuredtext-lint"
  url "https://github.com/twolfson/restructuredtext-lint/archive/1.3.0.tar.gz"
  sha256 "4bf9d4724f59bc05ebe1cd5192c03d4597ee95c4bbf60bd5644422e1a2558da3"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "5de2e78e3830b41f34e19e15d0a8d8c8922005e08f21be4c46778af5b0a65764" => :catalina
    sha256 "fc083735d0449b72bc1934c1e06bf832e12b390e565ab2af82138442474394b6" => :mojave
    sha256 "653b51d8d1b356ff314042c6f4d596abdfe0a703724ede6bd85df9e30eb97449" => :high_sierra
  end

  depends_on "python@3.8"

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/84/f4/5771e41fdf52aabebbadecc9381d11dea0fa34e4759b4071244fa094804c/docutils-0.14.tar.gz"
    sha256 "51e64ef2ebfb29cae1faa133b3710143496eca21c530f3f71424d77687764274"
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
