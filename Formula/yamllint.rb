class Yamllint < Formula
  include Language::Python::Virtualenv

  desc "Linter for YAML files"
  homepage "https://github.com/adrienverge/yamllint"
  url "https://files.pythonhosted.org/packages/74/2f/05aff60fa063c49c28bd24f4f848d9a81583c65082de154fcd2a467548e6/yamllint-1.26.2.tar.gz"
  sha256 "0b08a96750248fdf21f1e8193cb7787554ef75ed57b27f621cd6b3bf09af11a1"
  license "GPL-3.0-or-later"
  head "https://github.com/adrienverge/yamllint.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "221c2e2a16a472df48e1c34e5d3601378c1269dea73355d6e661ee7d6fbf59c5"
    sha256 cellar: :any,                 big_sur:       "22fb22e74df2350b9785f914d016fa070c2002c662dd660e73acc3cb361e010c"
    sha256 cellar: :any,                 catalina:      "a6df81f340082bd40685bd955826e32bddaf47645dc38be92fca8a71e8f253b8"
    sha256 cellar: :any,                 mojave:        "1541161a955a3dff2da13c21596a6778361375202563a2e393b1511d3a396afc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fcb8b2aff84f043648b681412ac46f0de6f9ba14f9e21f2e8a197a44558f7ac"
  end

  depends_on "libyaml"
  depends_on "python@3.9"

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/f6/33/436c5cb94e9f8902e59d1d544eb298b83c84b9ec37b5b769c5a0ad6edb19/pathspec-0.9.0.tar.gz"
    sha256 "e564499435a2673d586f6b2130bb5b95f04a3ba06f81b8f895b651a3c76aabb1"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"bad.yaml").write <<~EOS
      ---
      foo: bar: gee
    EOS
    output = shell_output("#{bin}/yamllint -f parsable -s bad.yaml", 1)
    assert_match "syntax error: mapping values are not allowed here", output

    (testpath/"good.yaml").write <<~EOS
      ---
      foo: bar
    EOS
    assert_equal "", shell_output("#{bin}/yamllint -f parsable -s good.yaml")
  end
end
