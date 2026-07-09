class Yamllint < Formula
  include Language::Python::Virtualenv

  desc "Linter for YAML files"
  homepage "https://github.com/adrienverge/yamllint"
  url "https://files.pythonhosted.org/packages/28/a0/8fc2d68e132cf918f18273fdc8a1b8432b60d75ac12fdae4b0ef5c9d2e8d/yamllint-1.38.0.tar.gz"
  sha256 "09e5f29531daab93366bb061e76019d5e91691ef0a40328f04c927387d1d364d"
  license "GPL-3.0-or-later"
  head "https://github.com/adrienverge/yamllint.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "da7c942af5a8d2dd8dacb439539a21251a2ee82aa965a7de7cb47713665471fa"
    sha256 cellar: :any,                 arm64_sequoia: "8e1afec98302dd31a2e7fb3d68e9a707a39a397fe2115b2f0dd9bbbf3b14d648"
    sha256 cellar: :any,                 arm64_sonoma:  "31fe178c470660060b420dc1f114067e4fdb763cda30d55650ab2e786fec7794"
    sha256 cellar: :any,                 sonoma:        "aea22a0b41c5319cf84793594d92825a8d6649cc41e62c984666a1ba5de35fab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93fd00ec0b1ceab422f20817ddba3e50e50f8ca69e0a026750dd036ed012d767"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8775acbc37acdeafd89099399fd587cf0a73ef43cd8f552e265c10891586f3bc"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/4c/b2/bb8e495d5262bfec41ab5cb18f522f1012933347fb5d9e62452d446baca2/pathspec-1.0.3.tar.gz"
    sha256 "bac5cf97ae2c2876e2d25ebb15078eb04d76e4b98921ee31c6f85ade8b59444d"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"bad.yaml").write <<~YAML
      ---
      foo: bar: gee
    YAML
    output = shell_output("#{bin}/yamllint -f parsable -s bad.yaml", 1)
    assert_match "syntax error: mapping values are not allowed here", output

    (testpath/"good.yaml").write <<~YAML
      ---
      foo: bar
    YAML
    assert_empty shell_output("#{bin}/yamllint -f parsable -s good.yaml")
  end
end
