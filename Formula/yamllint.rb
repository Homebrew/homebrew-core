class Yamllint < Formula
  include Language::Python::Virtualenv

  desc "Linter for YAML files"
  homepage "https://github.com/adrienverge/yamllint"
  url "https://files.pythonhosted.org/packages/9d/3d/f313c341f0592d23bd7dfe24e46af0d16a796cd865d5ac0041bb200f9cc4/yamllint-1.26.3.tar.gz"
  sha256 "3934dcde484374596d6b52d8db412929a169f6d9e52e20f9ade5bf3523d9b96e"
  license "GPL-3.0-or-later"
  head "https://github.com/adrienverge/yamllint.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "c32e191d3556bb2437d473102b23e88e78b4949e49d334501cc35c5f8e174cd6"
    sha256 cellar: :any,                 big_sur:       "2b55ce529a710907e020567612a5da5c17641a8dbf6aad0d9d52eb7bc0d9d290"
    sha256 cellar: :any,                 catalina:      "353876497c255a31d87fc64ab9e92ea18b5cae00bf31d2de8920e26b96ddc3dc"
    sha256 cellar: :any,                 mojave:        "d167a9db92455faa155de1271e7e7480b9f74dfc649318475a23a62531f577c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ecd751a548d7b41fd12580d7a782866ee799633a777bcb911a2abfc00ffa3d7"
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
