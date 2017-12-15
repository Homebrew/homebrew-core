class RstLint < Formula
  include Language::Python::Virtualenv

  desc "ReStructuredText linter"
  homepage "https://github.com/twolfson/restructuredtext-lint"
  url "https://github.com/twolfson/restructuredtext-lint/archive/1.1.2.tar.gz"
  sha256 "baa99906eaafc00a975a8dee59f6bbbbecc21add2eb630dce6bef64ac0efd4d0"

  bottle do
    cellar :any_skip_relocation
    sha256 "79937d81644e4078ebe68d823353818c0ad27101cecb344da69b2dfe3385ad36" => :high_sierra
    sha256 "eba17238c6294b34c746ecb7203770cd09d1c19513f0ad0b4f1777e1932bfbfc" => :sierra
    sha256 "e41c9a9a6aa7d3527686354d46dd2ec1b203063c282acd82f28154400bc4b5c9" => :el_capitan
  end

  depends_on :python if MacOS.version <= :snow_leopard

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
