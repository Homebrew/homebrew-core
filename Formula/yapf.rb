class Yapf < Formula
  include Language::Python::Virtualenv

  desc "Formatter for python code"
  homepage "https://github.com/google/yapf"
  url "https://files.pythonhosted.org/packages/8e/1e/730a64d83e1b6a64bb8efa5358fc8e9418e6c2d19862523dce22be1040ed/yapf-0.29.0.tar.gz"
  sha256 "712e23c468506bf12cadd10169f852572ecc61b266258422d45aaf4ad7ef43de"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "3c8ed0da14d9c9deffe008f7de41ba3574df0b3dcff3477e988c9b58884184ab" => :catalina
    sha256 "8ffbfe8a3b6b474dcae1822e64ccbca54fd344cc5b080f018bc51adb33956510" => :mojave
    sha256 "326436e6bc974790bf36de06e7ea7070d3d0bcaf52b14e2067727c3e95ee47dc" => :high_sierra
  end

  depends_on "python@3.8"

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("echo \"x='homebrew'\" | #{bin}/yapf")
    assert_equal "x = 'homebrew'", output.strip
  end
end
