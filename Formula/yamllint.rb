class Yamllint < Formula
  include Language::Python::Virtualenv

  desc "Linter for YAML files"
  homepage "https://github.com/adrienverge/yamllint"
  url "https://github.com/adrienverge/yamllint/archive/v1.19.0.tar.gz"
  sha256 "4e0f4a1a937b242b4500efced6332a28e5afcac3e4a1679af5bce145b1d026e1"

  bottle do
    cellar :any
    sha256 "668c2f33c914ed5b6e319e9bee4bd8e66f0835d293409d1d0425fc31fa6454da" => :catalina
    sha256 "ed6d6b30eeb8e88129aa9a027284ed60b8ae6b050296901eaa5d035ff0408a74" => :mojave
    sha256 "72fe55cf7e722039e2f3fe65ca43ab3a4f3cb16d6666dd39d13a426ebbefb3c7" => :high_sierra
  end

  depends_on "libyaml"
  depends_on "python"

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/8d/c9/e5be955a117a1ac548cdd31e37e8fd7b02ce987f9655f5c7563c656d5dcb/PyYAML-5.2.tar.gz"
    sha256 "c0ee8eca2c582d29c3c2ec6e2c4f703d1b7f1fb10bc72317355a746057e7346c"
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
