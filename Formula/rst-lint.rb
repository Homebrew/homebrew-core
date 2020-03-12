class RstLint < Formula
  include Language::Python::Virtualenv

  desc "ReStructuredText linter"
  homepage "https://github.com/twolfson/restructuredtext-lint"
  url "https://github.com/twolfson/restructuredtext-lint/archive/1.3.0.tar.gz"
  sha256 "4bf9d4724f59bc05ebe1cd5192c03d4597ee95c4bbf60bd5644422e1a2558da3"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "f2e1f46bf019b4f7d1b7b5e749fe729ea070539c211626d5a0e69f059c39c30a" => :catalina
    sha256 "a4c02982ae36f5ae3d2ac2b961e0f20d77bbf5135fe789fdc64196d8f307bc92" => :mojave
    sha256 "791c788f3bf1f97cf11513fa8c2c775268c382c8d41bd406b6d45bd4dfabdac5" => :high_sierra
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
