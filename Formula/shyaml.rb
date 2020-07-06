class Shyaml < Formula
  include Language::Python::Virtualenv

  desc "Command-line YAML parser"
  homepage "https://github.com/0k/shyaml"
  url "https://files.pythonhosted.org/packages/bc/ca/d8c47fad7a6ce01ddd2b7093673433dbfae414015f971ea7ffda56da125f/shyaml-0.6.1.tar.gz"
  sha256 "3a57e380f66043c661d417106a0f101f8068c80caa2afef57c90447b88526c3d"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/0k/shyaml.git"

  bottle do
    cellar :any
    sha256 "510026ded6fc62625ee9bd2cab4d94d03155e94270ae0aa38947b894282c2808" => :catalina
    sha256 "c850436b06215814c879e02db80331c3b94e63ccfa03df8bd25915ef4dfac668" => :mojave
    sha256 "d52705a99a5f376d41d2ead578d73f5eb309b0efa595215364ea42cb4191eed6" => :high_sierra
  end

  depends_on "libyaml"
  depends_on "python@3.8"

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
