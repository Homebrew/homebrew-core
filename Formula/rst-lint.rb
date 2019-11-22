class RstLint < Formula
  include Language::Python::Virtualenv

  desc "ReStructuredText linter"
  homepage "https://github.com/twolfson/restructuredtext-lint"
  url "https://github.com/twolfson/restructuredtext-lint/archive/1.3.0.tar.gz"
  sha256 "4bf9d4724f59bc05ebe1cd5192c03d4597ee95c4bbf60bd5644422e1a2558da3"

  bottle do
    cellar :any_skip_relocation
    sha256 "e7d5b085ef98fb5613edaec5be706c31831aa3721081dc43ca6282e69c45360c" => :catalina
    sha256 "6141abff3561e93a197148e81d2c0634a3665f41beabb4a5bbf92bb0355ce270" => :mojave
    sha256 "377505a302c81418df15ab1a29723a0b4572d78e7a8bb984a33bd57daf352fbd" => :high_sierra
    sha256 "46da54ff6e6f96663327291d0f51380107c377705d9eaccc7461c9156916799b" => :sierra
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
