class Yamllint < Formula
  include Language::Python::Virtualenv

  desc "Linter for YAML files"
  homepage "https://github.com/adrienverge/yamllint"
  url "https://files.pythonhosted.org/packages/75/33/c8014b6678936daf30e15291bfb9d608fff1d8adafa024a6565d225e6f4c/yamllint-1.25.0.tar.gz"
  sha256 "b1549cbe5b47b6ba67bdeea31720f5c51431a4d0c076c1557952d841f7223519"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/adrienverge/yamllint.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "d17a340b3d8c1a2b5c85449cc7930ae4263c94eb9a924971066c53af45d46ee3" => :big_sur
    sha256 "4da53cd2d8d61957b50189cdaf4378319bc233ae4d9714c95cb189a06058ff2e" => :catalina
    sha256 "e6c94f6fc961be975a542b3c1fdd0a490d7755a54fe8af07e3611175a9adf619" => :mojave
    sha256 "bf90ed58f27615bccd363fc33da8a03b0d60e4e1400d62872c1e46a59592e3ba" => :high_sierra
  end

  depends_on "libyaml"
  depends_on "python@3.9"

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/b7/64/e097eea8dcd2b2f7df6e4425fc98e7494e37b1a6e149603c31d327080a05/pathspec-0.8.1.tar.gz"
    sha256 "86379d6b86d75816baba717e64b1a3a3469deb93bb76d613c9ce79edc5cb68fd"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/64/c2/b80047c7ac2478f9501676c988a5411ed5572f35d1beff9cae07d321512c/PyYAML-5.3.1.tar.gz"
    sha256 "b8eac752c5e14d3eca0e6dd9199cd627518cb5ec06add0de9d32baeee6fe645d"
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
