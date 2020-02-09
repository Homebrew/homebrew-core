class Termtosvg < Formula
  include Language::Python::Virtualenv

  desc "Record terminal sessions as SVG animations"
  homepage "https://nbedos.github.io/termtosvg"
  url "https://github.com/nbedos/termtosvg/archive/1.1.0.tar.gz"
  sha256 "53e9ad5976978684699d14b83cac37bf173d76c787f1b849859ad8aef55f22d2"

  bottle do
    cellar :any_skip_relocation
    sha256 "98353f1a6df1675441bd9fbd7f7015905b654cdce008582072d6b7e8c8fdde42" => :catalina
    sha256 "94ec2cd77e154ba2314aeff68ce68ad7614c9a5c8be8bcf0830bc02b3f5b37a5" => :mojave
    sha256 "24b342f95d1700df9485dba70ef456a7f8bb64391a3b58502ca4c651e330f494" => :high_sierra
  end

  depends_on "python"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-U", "-e", "."
    venv.pip_install_and_link buildpath
    bin.install_symlink libexec/"bin/termtosvg"
  end

  test do
    system libexec/"bin/python", "-m", "unittest", "termtosvg.tests.suite"
  end
end
