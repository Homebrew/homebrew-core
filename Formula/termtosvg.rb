class Termtosvg < Formula
  include Language::Python::Virtualenv

  desc "Record terminal sessions as SVG animations"
  homepage "https://nbedos.github.io/termtosvg"
  url "https://github.com/nbedos/termtosvg/archive/0.9.0.tar.gz"
  sha256 "156d92b3a186d075bf42677135053dc28460f097de45c9388f31911b3e8b17b2"

  bottle do
    cellar :any_skip_relocation
    sha256 "a41b6080f406b9a04221c8328ac2772d5097994659aa4a033d3ff706dfd5fda0" => :mojave
    sha256 "cfcd6703680cbfd26dc5b1c532f674a1e5b3074f7207e118989648d16826d74e" => :high_sierra
    sha256 "65e860a6e9f95e47b2d763a37a66bb70c08c0afc90966d13c9df54c91d7b1dce" => :sierra
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
