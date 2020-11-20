class RstLint < Formula
  include Language::Python::Virtualenv

  desc "ReStructuredText linter"
  homepage "https://github.com/twolfson/restructuredtext-lint"
  url "https://github.com/twolfson/restructuredtext-lint/archive/1.3.1.tar.gz"
  sha256 "469fcc0dae4f511da5a28f5d0f9b5d0f477dabca4a44cd8c84e20b8a99791b89"
  license "Unlicense"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "51abe83d01f907beecf6b2a5bb585ebb152b54421323cc26d06827d92cb01293" => :big_sur
    sha256 "bd41571f9b9392ddba89b20f41d4ca1b2e2c62d2a0430983ad5e8e00341da8d0" => :catalina
    sha256 "585d2d891b0f107d0b6d961de6689a4004aa49646ce2894464c7627039e1598c" => :mojave
    sha256 "b22e716ab45eec53f86e360efec814d3e882aa9a29cd938dd814d29a87eb9cd8" => :high_sierra
  end

  depends_on "python@3.9"

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
