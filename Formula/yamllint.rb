class Yamllint < Formula
  include Language::Python::Virtualenv

  desc "Linter for YAML files"
  homepage "https://github.com/adrienverge/yamllint"
  url "https://files.pythonhosted.org/packages/d6/0e/4968cd96b6d917b7e8c84335c5a931929c8e626cf0857b3749c61417bf6c/yamllint-1.26.0.tar.gz"
  sha256 "b0e4c89985c7f5f8451c2eb8c67d804d10ac13a4abe031cbf49bdf3465d01087"
  license "GPL-3.0-or-later"
  head "https://github.com/adrienverge/yamllint.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "fe78135e634a2658a12f40e4889be14af79d8843404d145c54495d719275e9d7"
    sha256 cellar: :any, big_sur:       "2586c661c4e1e06056653bb0d62da23d631c84ddfad11e08cc34dbe76a5b2bac"
    sha256 cellar: :any, catalina:      "526747beb092f4b3026a8b4615a9f6a4e858fe352cf917b99d1dd16159390870"
    sha256 cellar: :any, mojave:        "c25d4d11756aff320022e4f292ebd32fef55841ee13e1d8bde4b7fe88ab54f6c"
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
