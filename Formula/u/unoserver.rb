class Unoserver < Formula
  include Language::Python::Virtualenv

  desc "Server for file conversions with Libre Office"
  homepage "https://github.com/unoconv/unoserver"
  url "https://files.pythonhosted.org/packages/6f/87/1301e71a6cbf920d51f10ab3b1b068701d6f979c4ee5f831bfcdad7b7d95/unoserver-3.6.tar.gz"
  sha256 "e446bcb3638c51880f002aaeecab1cf74dfa9df81035f027f7ff2e081b6d7015"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f0b7692be773167a24a806ed93948424b73107819d5044665afd74615eb45ec4"
  end

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "office installation", pipe_output("#{bin}/unoserver 2>&1")
  end
end
