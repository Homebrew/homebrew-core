class Termtosvg < Formula
  include Language::Python::Virtualenv

  desc "Record terminal sessions as SVG animations"
  homepage "https://nbedos.github.io/termtosvg"
  url "https://github.com/nbedos/termtosvg/archive/1.1.0.tar.gz"
  sha256 "53e9ad5976978684699d14b83cac37bf173d76c787f1b849859ad8aef55f22d2"

  bottle do
    cellar :any_skip_relocation
    sha256 "0c339642ddd4e2c5308bda1df5002afcb102045e926c85804ec9adb28949b230" => :catalina
    sha256 "761e3f4bbf4cef28a2e4fa6ffa629e42d608edeccd1954ad163a873204bcb9ab" => :mojave
    sha256 "3ca383905ac6bb41d58ed6f1f868e803ca8804354cafa5321bf820db4d5f4d3a" => :high_sierra
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
