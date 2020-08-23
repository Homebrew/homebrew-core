class RstLint < Formula
  include Language::Python::Virtualenv

  desc "ReStructuredText linter"
  homepage "https://github.com/twolfson/restructuredtext-lint"
  url "https://github.com/twolfson/restructuredtext-lint/archive/1.3.1.tar.gz"
  sha256 "469fcc0dae4f511da5a28f5d0f9b5d0f477dabca4a44cd8c84e20b8a99791b89"
  license "Unlicense"

  bottle do
    cellar :any_skip_relocation
    sha256 "45b5248c1e791f738f6cf2b645cec9d94d9992caa3a7d00594ad9ed2b12a11e6" => :catalina
    sha256 "e77f597dd712f47fe96b8b83130f9a85b51a1ce9113622443d36077b020bcd01" => :mojave
    sha256 "18c09b7c8bad5976c12dd900e827f2a036929a853707b2dd139c258278ccf548" => :high_sierra
  end

  depends_on "python@3.8"

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/2f/e0/3d435b34abd2d62e8206171892f174b180cd37b09d57b924ca5c2ef2219d/docutils-0.16.tar.gz"
    sha256 "c2de3a60e9e7d07be26b7f2b00ca0309c207e06c100f9cc2a94931fc75a478fc"
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
