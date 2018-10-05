class Yamllint < Formula
  include Language::Python::Virtualenv

  desc "Linter for YAML files"
  homepage "https://github.com/adrienverge/yamllint"
  url "https://github.com/adrienverge/yamllint/archive/v1.12.0.tar.gz"
  sha256 "178e0f677f7911ef2055bdc8cd2638cbccb4751d7a4e303377993267dcac7fe4"

  bottle do
    cellar :any
    rebuild 1
    sha256 "c20c73fe3d322eb529b94a05a795d4f890c87a28e7d884c301f1e85c0ef13940" => :mojave
    sha256 "3ffaafca879769be72b0a8a98be07f8ffe746f8488f4430863fb8380544ab01c" => :high_sierra
    sha256 "921109aebc30770d96997b33565faf1d21f5821d4bf9e19d18fc6e0f5908712a" => :sierra
    sha256 "17ec47b0462e157f33a61fa95462c1b6f7bdd329fd687a870317c4eb4aeeaf9c" => :el_capitan
  end

  depends_on "libyaml"
  depends_on "python"

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/9e/a3/1d13970c3f36777c583f136c136f804d70f500168edc1edea6daa7200769/PyYAML-3.13.tar.gz"
    sha256 "3ef3092145e9b70e3ddd2c7ad59bdd0252a94dfe3949721633e41344de00a6bf"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/84/2a/bfee636b1e2f7d6e30dd74f49201ccfa5c3cf322d44929ecc6c137c486c5/pathspec-0.5.9.tar.gz"
    sha256 "54a5eab895d89f342b52ba2bffe70930ef9f8d96e398cccf530d21fa0516a873"
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
