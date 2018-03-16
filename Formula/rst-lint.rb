class RstLint < Formula
  include Language::Python::Virtualenv

  desc "ReStructuredText linter"
  homepage "https://github.com/twolfson/restructuredtext-lint"
  url "https://github.com/twolfson/restructuredtext-lint/archive/1.1.3.tar.gz"
  sha256 "eb75dda827c656a33be6e60f18b3943c4dd4252205e557ec95d1cf44df8e3a35"

  bottle do
    cellar :any_skip_relocation
    sha256 "098a3b74c65c030729fad809210f1e31d96a2295610376989134be981f4fcc30" => :high_sierra
    sha256 "d6edae2002e2df530bd14e8cb27eb6dce1a29fe15b5ec614d9c3b7610fe00d96" => :sierra
    sha256 "aebb1a098a77f6e9477c5f426b363895d2f0cc77c46a3d84c871a9fab2f08d54" => :el_capitan
  end

  depends_on "python@2" if MacOS.version <= :snow_leopard

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
