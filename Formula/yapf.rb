class Yapf < Formula
  include Language::Python::Virtualenv

  desc "Formatter for python code"
  homepage "https://github.com/google/yapf"
  url "https://files.pythonhosted.org/packages/8e/1e/730a64d83e1b6a64bb8efa5358fc8e9418e6c2d19862523dce22be1040ed/yapf-0.29.0.tar.gz"
  sha256 "712e23c468506bf12cadd10169f852572ecc61b266258422d45aaf4ad7ef43de"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "6bbe6c40b433bee94f923c479ca8020314960edae9452eedd627b031603180dd" => :catalina
    sha256 "158dcb7867a2572a30caa27951dd11431554de050a432691ab250796aa76b30b" => :mojave
    sha256 "b794952a1ac7f0d1537745d89c8d88846b45ff8758019d1cf594789f552a05cd" => :high_sierra
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
