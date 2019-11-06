class Shyaml < Formula
  include Language::Python::Virtualenv

  desc "Command-line YAML parser"
  homepage "https://github.com/0k/shyaml"
  url "https://files.pythonhosted.org/packages/bc/ca/d8c47fad7a6ce01ddd2b7093673433dbfae414015f971ea7ffda56da125f/shyaml-0.6.1.tar.gz"
  sha256 "3a57e380f66043c661d417106a0f101f8068c80caa2afef57c90447b88526c3d"
  head "https://github.com/0k/shyaml.git"

  bottle do
    cellar :any
    sha256 "1b2fac099650ddce3b321c848d052cde2ddea11323572491b8fc534ae6b345fc" => :catalina
    sha256 "6aa2db7ebec7ea9a269c90e6c63491bad0f419570790b717ce4e6db3e382ea74" => :mojave
    sha256 "a985968768985ec82d27b9b2e4d409fe965a1b610e12f31086175417eafa8ffb" => :high_sierra
    sha256 "82bf65013962514ea7e9f9decadfc063f528902a0cea281e7dbf3f3a30c42515" => :sierra
  end

  depends_on "libyaml"
  depends_on "python"

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/9f/2c/9417b5c774792634834e730932745bc09a7d36754ca00acf1ccd1ac2594d/PyYAML-5.1.tar.gz"
    sha256 "436bc774ecf7c103814098159fbb84c2715d25980175292c648f2da143909f95"
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
