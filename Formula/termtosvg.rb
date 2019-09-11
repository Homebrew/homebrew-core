class Termtosvg < Formula
  include Language::Python::Virtualenv

  desc "Record terminal sessions as SVG animations"
  homepage "https://nbedos.github.io/termtosvg"
  url "https://github.com/nbedos/termtosvg/archive/0.9.0.tar.gz"
  sha256 "156d92b3a186d075bf42677135053dc28460f097de45c9388f31911b3e8b17b2"

  bottle do
    cellar :any_skip_relocation
    sha256 "076380fe41bc75f28e04d869c3f76c0442d82905cf3c2f18338cf5f652fc5a73" => :mojave
    sha256 "04b4c4e370b2bc7faa1c2d86a9e4761b33ffb6c82697dc11ea4fbba55412d290" => :high_sierra
    sha256 "934f9f91a9c23a5a7c44dab7ac3dab89a0d4377cfe006e2f12724d000ae73134" => :sierra
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
