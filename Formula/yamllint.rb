class Yamllint < Formula
  include Language::Python::Virtualenv

  desc "Linter for YAML files"
  homepage "https://github.com/adrienverge/yamllint"
  url "https://github.com/adrienverge/yamllint/archive/v1.25.0.tar.gz"
  sha256 "995b69c880bc1ba9368ed13be3421ae7de221e6e886aa6dc4ac52a780a87034a"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    cellar :any
    sha256 "4da53cd2d8d61957b50189cdaf4378319bc233ae4d9714c95cb189a06058ff2e" => :catalina
    sha256 "e6c94f6fc961be975a542b3c1fdd0a490d7755a54fe8af07e3611175a9adf619" => :mojave
    sha256 "bf90ed58f27615bccd363fc33da8a03b0d60e4e1400d62872c1e46a59592e3ba" => :high_sierra
  end

  depends_on "libyaml"
  depends_on "python@3.9"

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
