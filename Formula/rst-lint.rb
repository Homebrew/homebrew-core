class RstLint < Formula
  include Language::Python::Virtualenv

  desc "ReStructuredText linter"
  homepage "https://github.com/twolfson/restructuredtext-lint"
  url "https://github.com/twolfson/restructuredtext-lint/archive/1.2.1.tar.gz"
  sha256 "a6a37cc1f06a7347d53ec39e41e101d9d26e8118e4ac2f602985990960a51b25"

  bottle do
    cellar :any_skip_relocation
    sha256 "fda6b9e208ae80012c883a159e9bc9322b6d12b8c9b3a5f54f8a2cb37a137a1d" => :mojave
    sha256 "ce1b1d7179d16f81917d85a72dd84488dc32c8323f1ecbb5029cc6f4095bbc2e" => :high_sierra
    sha256 "36e4a419033b0dedb26121fed365cea8f882d93645d95f433cc879188f00570f" => :sierra
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
