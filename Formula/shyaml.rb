class Shyaml < Formula
  include Language::Python::Virtualenv

  desc "Command-line YAML parser"
  homepage "https://github.com/0k/shyaml"
  url "https://files.pythonhosted.org/packages/33/34/7ad4b645bdd5c6cd100748fc2429924b553439221aa9b9386f658e5a05f2/shyaml-0.5.2.tar.gz"
  sha256 "80650ebfe6fa2e16083451d515207472d60990c1c15fc0fd607c27077790ac23"
  revision 1
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
    url "https://files.pythonhosted.org/packages/9e/a3/1d13970c3f36777c583f136c136f804d70f500168edc1edea6daa7200769/PyYAML-3.13.tar.gz"
    sha256 "3ef3092145e9b70e3ddd2c7ad59bdd0252a94dfe3949721633e41344de00a6bf"
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
