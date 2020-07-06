class Termtosvg < Formula
  include Language::Python::Virtualenv

  desc "Record terminal sessions as SVG animations"
  homepage "https://nbedos.github.io/termtosvg"
  url "https://github.com/nbedos/termtosvg/archive/1.1.0.tar.gz"
  sha256 "53e9ad5976978684699d14b83cac37bf173d76c787f1b849859ad8aef55f22d2"
  license "BSD-3-Clause"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "f882539d594efc11647207ad81eed3c1a2f365c6c9a3b7be1401dffbab6ea98d" => :catalina
    sha256 "860ca46763f9cfeb387a806e380d6a680fc39f13d31795ebed68e7c2df087aaa" => :mojave
    sha256 "6cb7b9688575469970762f3ecdee882a30051a4b6d42f41af0e6aed159d97b0b" => :high_sierra
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
