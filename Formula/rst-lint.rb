class RstLint < Formula
  include Language::Python::Virtualenv

  desc "ReStructuredText linter"
  homepage "https://github.com/twolfson/restructuredtext-lint"
  url "https://github.com/twolfson/restructuredtext-lint/archive/1.3.1.tar.gz"
  sha256 "469fcc0dae4f511da5a28f5d0f9b5d0f477dabca4a44cd8c84e20b8a99791b89"

  bottle do
    cellar :any_skip_relocation
    sha256 "f2e1f46bf019b4f7d1b7b5e749fe729ea070539c211626d5a0e69f059c39c30a" => :catalina
    sha256 "a4c02982ae36f5ae3d2ac2b961e0f20d77bbf5135fe789fdc64196d8f307bc92" => :mojave
    sha256 "791c788f3bf1f97cf11513fa8c2c775268c382c8d41bd406b6d45bd4dfabdac5" => :high_sierra
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
