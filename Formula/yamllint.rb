class Yamllint < Formula
  include Language::Python::Virtualenv

  desc "Linter for YAML files"
  homepage "https://github.com/adrienverge/yamllint"
  url "https://github.com/adrienverge/yamllint/archive/v1.24.2.tar.gz"
  sha256 "bc2335eb34ae77aeb550273bdc26800e50146bdbd5c07d8ae88aed72c4dac4df"
  license "GPL-3.0"

  bottle do
    cellar :any
    sha256 "c900ce7a81a4a5aa4c6403dda10cf194cb33bbcb6d41c628c9077bcea5361880" => :catalina
    sha256 "38cb3e431c8f9ceddb4a500c2f230b8503c06b91a0a556c97766b27dca8e915a" => :mojave
    sha256 "8a1022efa145f1e3c7082aa4ad557ddea139d31dda6155a0fa24b23a6dab5b4b" => :high_sierra
  end

  depends_on "libyaml"
  depends_on "python@3.8"

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/64/c2/b80047c7ac2478f9501676c988a5411ed5572f35d1beff9cae07d321512c/PyYAML-5.3.1.tar.gz"
    sha256 "b8eac752c5e14d3eca0e6dd9199cd627518cb5ec06add0de9d32baeee6fe645d"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/93/9c/4bb0a33b0ec07d2076f0b3d7c6aae4dad0a99f9a7a14f7f7ff6f4ed7fa38/pathspec-0.8.0.tar.gz"
    sha256 "da45173eb3a6f2a5a487efba21f050af2b41948be6ab52b6a1e3ff22bb8b7061"
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
