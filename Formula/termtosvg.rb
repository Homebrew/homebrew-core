class Termtosvg < Formula
  include Language::Python::Virtualenv

  desc "Record terminal sessions as SVG animations"
  homepage "https://nbedos.github.io/termtosvg"
  url "https://github.com/nbedos/termtosvg/archive/0.7.0.tar.gz"
  sha256 "a90cbd2ea29e1bdf4059aa8feb8f19e9f32da5620b447289ac78cde38682c7c2"

  bottle do
    cellar :any_skip_relocation
    sha256 "b6feb245add3b66176dc35cba270d818d6ab9404fad35b820b6d896f3c03b3f0" => :mojave
    sha256 "d225f3c7c759e062d1e54e201455c7849c900f4c9431cde19218c3075316d02b" => :high_sierra
    sha256 "e466333346009ad6a43efdcf1c55a1d3b4c72811046e80e67918f9dff7848d22" => :sierra
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
