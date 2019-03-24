class RstLint < Formula
  include Language::Python::Virtualenv

  desc "ReStructuredText linter"
  homepage "https://github.com/twolfson/restructuredtext-lint"
  url "https://github.com/twolfson/restructuredtext-lint/archive/1.3.0.tar.gz"
  sha256 "4bf9d4724f59bc05ebe1cd5192c03d4597ee95c4bbf60bd5644422e1a2558da3"

  bottle do
    cellar :any_skip_relocation
    sha256 "d4f872f6ac7b155f2f7ad419192cdc9847a948f4ea9dbd59e6c41bddd0e0697f" => :mojave
    sha256 "2257bb70af0eeffad85f346ae36cf26df6b9dcffa0673fa2d66530b8f0050760" => :high_sierra
    sha256 "9ae21bb23126e276c651693ee5df78e9670142765c7ec1fea1ba5777cf196731" => :sierra
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
