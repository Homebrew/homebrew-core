class Yamllint < Formula
  include Language::Python::Virtualenv

  desc "Linter for YAML files"
  homepage "https://github.com/adrienverge/yamllint"
  url "https://github.com/adrienverge/yamllint/archive/v1.15.0.tar.gz"
  sha256 "9c27608ec61777f83c2cb29158b247a02079ad2aebb86522dd941397e3e78f6a"

  bottle do
    cellar :any
    sha256 "be9d8bba05db325ed4a474ee4c5040cb0b7f6a874dfe330b3d886c44f4a65b99" => :mojave
    sha256 "2ab41df3c08b003a6c38baf53fee8bb5ebeccdc50bf98b7acaca43ac2146dd16" => :high_sierra
    sha256 "8204a95064cc1d40f0bde7bdcc5a9b13f1a5e50cd5683b99ddba68ae732f138a" => :sierra
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
