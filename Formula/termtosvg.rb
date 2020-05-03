class Termtosvg < Formula
  include Language::Python::Virtualenv

  desc "Record terminal sessions as SVG animations"
  homepage "https://nbedos.github.io/termtosvg"
  url "https://github.com/nbedos/termtosvg/archive/1.1.0.tar.gz"
  sha256 "53e9ad5976978684699d14b83cac37bf173d76c787f1b849859ad8aef55f22d2"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "98353f1a6df1675441bd9fbd7f7015905b654cdce008582072d6b7e8c8fdde42" => :catalina
    sha256 "94ec2cd77e154ba2314aeff68ce68ad7614c9a5c8be8bcf0830bc02b3f5b37a5" => :mojave
    sha256 "24b342f95d1700df9485dba70ef456a7f8bb64391a3b58502ca4c651e330f494" => :high_sierra
  end

  depends_on "python@3.8"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/39/2b/0a66d5436f237aff76b91e68b4d8c041d145ad0a2cdeefe2c42f76ba2857/lxml-4.5.0.tar.gz"
    sha256 "8620ce80f50d023d414183bf90cc2576c2837b88e00bea3f33ad2630133bbb60"
  end

  resource "pyte" do
    url "https://files.pythonhosted.org/packages/66/37/6fed89b484c8012a0343117f085c92df8447a18af4966d25599861cd5aa0/pyte-0.8.0.tar.gz"
    sha256 "7e71d03e972d6f262cbe8704ff70039855f05ee6f7ad9d7129df9c977b5a88c5"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/25/9d/0acbed6e4a4be4fc99148f275488580968f44ddb5e69b8ceb53fc9df55a0/wcwidth-0.1.9.tar.gz"
    sha256 "ee73862862a156bf77ff92b09034fc4825dd3af9cf81bc5b360668d425f3c5f1"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system libexec/"bin/python", "-m", "unittest", "termtosvg.tests.suite"
  end
end
