class Yapf < Formula
  include Language::Python::Virtualenv

  desc "Formatter for python code"
  homepage "https://github.com/google/yapf"
  url "https://files.pythonhosted.org/packages/8e/1e/730a64d83e1b6a64bb8efa5358fc8e9418e6c2d19862523dce22be1040ed/yapf-0.29.0.tar.gz"
  sha256 "712e23c468506bf12cadd10169f852572ecc61b266258422d45aaf4ad7ef43de"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "8f94ec7a91fe28d85f005c33f5318e3c31d75164c43cc7ea2823e909b59a4483" => :catalina
    sha256 "d7a90b18dbc7231c34183ff55064026f113607791cd29e3bec3a88ef71cde4c5" => :mojave
    sha256 "fbb3fa64390834fe642fadc06632c6916976cb4b4e36bc97c19b2f339769465f" => :high_sierra
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
