class Yamllint < Formula
  include Language::Python::Virtualenv

  desc "Linter for YAML files"
  homepage "https://github.com/adrienverge/yamllint"
  url "https://github.com/adrienverge/yamllint/archive/v1.11.1.tar.gz"
  sha256 "56221b7c0a50b1619e491eb157624a5d1b160c1a4f019d64f117268f42fe4ca4"
  revision 1

  bottle do
    cellar :any
    sha256 "9656e08b29dc202a8c8ef97f9a7c62d33f4865dd00a0c30cd308adc3827f9543" => :high_sierra
    sha256 "ea180291f5c3c822f9937d00366a35e4303c0dc5def41dcc85fbd718e5a17fc4" => :sierra
    sha256 "6fe885dabb4b597a2ae610b8e68430af2342ae51be23b56eb0a347d396755af8" => :el_capitan
  end

  depends_on "libyaml"
  depends_on "python"

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/bd/da/0a49c1a31c60634b93fd1376b3b7966c4f81f2da8263f389cad5b6bbd6e8/PyYAML-4.2b1.tar.gz"
    sha256 "ef3a0d5a5e950747f4a39ed7b204e036b37f9bddc7551c1a813b8727515a832e"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/5e/59/d40bf36fda6cc9ec0e2d2d843986fa7d91f7144ad83e909bcb126b45ea88/pathspec-0.5.6.tar.gz"
    sha256 "be664567cf96a718a68b33329862d1e6f6803ef9c48a6e2636265806cfceb29d"
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
