class Yamllint < Formula
  include Language::Python::Virtualenv

  desc "Linter for YAML files"
  homepage "https://github.com/adrienverge/yamllint"
  url "https://files.pythonhosted.org/packages/50/a1/9093baeb2545d43c22bbcc98c94b926d324598b50e196b492b0882dcb465/yamllint-1.26.1.tar.gz"
  sha256 "87d9462b3ed7e9dfa19caa177f7a77cd9888b3dc4044447d6ae0ab233bcd1324"
  license "GPL-3.0-or-later"
  head "https://github.com/adrienverge/yamllint.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "221c2e2a16a472df48e1c34e5d3601378c1269dea73355d6e661ee7d6fbf59c5"
    sha256 cellar: :any, big_sur:       "22fb22e74df2350b9785f914d016fa070c2002c662dd660e73acc3cb361e010c"
    sha256 cellar: :any, catalina:      "a6df81f340082bd40685bd955826e32bddaf47645dc38be92fca8a71e8f253b8"
    sha256 cellar: :any, mojave:        "1541161a955a3dff2da13c21596a6778361375202563a2e393b1511d3a396afc"
  end

  depends_on "libyaml"
  depends_on "python@3.9"

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/b7/64/e097eea8dcd2b2f7df6e4425fc98e7494e37b1a6e149603c31d327080a05/pathspec-0.8.1.tar.gz"
    sha256 "86379d6b86d75816baba717e64b1a3a3469deb93bb76d613c9ce79edc5cb68fd"
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
