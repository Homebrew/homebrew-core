class Shyaml < Formula
  include Language::Python::Virtualenv

  desc "Command-line YAML parser"
  homepage "https://github.com/0k/shyaml"
  url "https://files.pythonhosted.org/packages/bc/ca/d8c47fad7a6ce01ddd2b7093673433dbfae414015f971ea7ffda56da125f/shyaml-0.6.1.tar.gz"
  sha256 "3a57e380f66043c661d417106a0f101f8068c80caa2afef57c90447b88526c3d"
  head "https://github.com/0k/shyaml.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "1f553d4c50f311b1702c973a189e64a0bae519885d94af51b14fd09e82ade8e0" => :mojave
    sha256 "ff016e9adec1fcde3aed838decd83cd643e1da3b4fdda4f3760edc706a96204e" => :high_sierra
    sha256 "f56ae02770869a49ec55215d3444dfd07bdd2fb1788e4cc6f124bd63bfaf2769" => :sierra
    sha256 "ff1078dcd1f6df8b14d7389704cec6ab3d60c79a926d741db4600af72ed87c55" => :el_capitan
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
