class Shyaml < Formula
  include Language::Python::Virtualenv

  desc "Command-line YAML parser"
  homepage "https://github.com/0k/shyaml"
  url "https://files.pythonhosted.org/packages/bc/ca/d8c47fad7a6ce01ddd2b7093673433dbfae414015f971ea7ffda56da125f/shyaml-0.6.1.tar.gz"
  sha256 "3a57e380f66043c661d417106a0f101f8068c80caa2afef57c90447b88526c3d"
  license "BSD-2-Clause"
  revision 2
  head "https://github.com/0k/shyaml.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "701dda753798f5e343311a1e8378614a572909b0b35b6882f6ac0be56ab9e16a" => :catalina
    sha256 "ea8a71d7782e8bdf0c700e93e3455e7b4180ae86388f9631eaf1fca440b58e69" => :mojave
    sha256 "b1dae6f7ee6138a7bd70301a4851720e693b45adceabd47184618d091d767fdb" => :high_sierra
  end

  depends_on "libyaml"
  depends_on "python@3.9"

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/64/c2/b80047c7ac2478f9501676c988a5411ed5572f35d1beff9cae07d321512c/PyYAML-5.3.1.tar.gz"
    sha256 "b8eac752c5e14d3eca0e6dd9199cd627518cb5ec06add0de9d32baeee6fe645d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    yaml = <<~EOS
      key: val
      arr:
        - 1st
        - 2nd
    EOS
    assert_equal "val", pipe_output("#{bin}/shyaml get-value key", yaml, 0)
    assert_equal "1st", pipe_output("#{bin}/shyaml get-value arr.0", yaml, 0)
    assert_equal "2nd", pipe_output("#{bin}/shyaml get-value arr.-1", yaml, 0)
  end
end
