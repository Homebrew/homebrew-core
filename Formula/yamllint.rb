class Yamllint < Formula
  include Language::Python::Virtualenv

  desc "Linter for YAML files"
  homepage "https://github.com/adrienverge/yamllint"
  url "https://github.com/adrienverge/yamllint/archive/v1.18.0.tar.gz"
  sha256 "9cb686e484600fd4aa312e71920d3bbb70ff41ba358d57c557fede0a2bc2fe00"

  bottle do
    cellar :any
    sha256 "531818e0a7071a2f879d9822a549dce239431ddd6d5e29a9dab45e85658fd34c" => :catalina
    sha256 "472299009d245cefd218755378caa5c43001efcbfae1c689c8f61388bb1f4b5c" => :mojave
    sha256 "53c8d9214d79642cd0dd15723efab24fa092bcd53816b535df94967400495379" => :high_sierra
    sha256 "8ac4e116780f39be2e27062da6c3398c5b8ea445bd607999a7906838b7d9a993" => :sierra
  end

  depends_on "libyaml"
  depends_on "python"

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/e3/e8/b3212641ee2718d556df0f23f78de8303f068fe29cdaa7a91018849582fe/PyYAML-5.1.2.tar.gz"
    sha256 "01adf0b6c6f61bd11af6e10ca52b7d4057dd0be0343eb9283c878cf3af56aee4"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/7a/68/5902e8cd7f7b17c5879982a3a3ee2ad0c3b92b80c79989a2d3e1ca8d29e1/pathspec-0.6.0.tar.gz"
    sha256 "e285ccc8b0785beadd4c18e5708b12bb8fcf529a1e61215b3feff1d1e559ea5c"
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
