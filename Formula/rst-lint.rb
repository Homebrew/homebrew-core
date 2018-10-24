class RstLint < Formula
  include Language::Python::Virtualenv

  desc "ReStructuredText linter"
  homepage "https://github.com/twolfson/restructuredtext-lint"
  url "https://github.com/twolfson/restructuredtext-lint/archive/1.1.3.tar.gz"
  sha256 "eb75dda827c656a33be6e60f18b3943c4dd4252205e557ec95d1cf44df8e3a35"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "b10a17bb1122b6c4643111d191cb0bfb43e9db860fa6210a0067964909896a5d" => :mojave
    sha256 "5c13d9a749419b30333975c240947f824c6e13f1e5ea2dcf076c6745d6ec82bf" => :high_sierra
    sha256 "3518edf1fcd6dd3bef0db46246266167070f4936219685f448fa9fcf5ac6fb41" => :sierra
  end

  depends_on "python"

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
