class Yamllint < Formula
  include Language::Python::Virtualenv

  desc "Linter for YAML files"
  homepage "https://github.com/adrienverge/yamllint"
  url "https://github.com/adrienverge/yamllint/archive/v1.12.0.tar.gz"
  sha256 "178e0f677f7911ef2055bdc8cd2638cbccb4751d7a4e303377993267dcac7fe4"

  bottle do
    cellar :any
    sha256 "70c1a88c4bea93cfa2ec21645a42d3f11c7435db86d29e8821e0dd186dc54141" => :mojave
    sha256 "3314a7def6b931c04a4822ddfd381ee80b8be6b7ef4e419ff0727f64aa758251" => :high_sierra
    sha256 "00cc059b4f60dfac563b8b9ac4e138eb7ee639ad6d72d8e6947498605a89f280" => :sierra
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
