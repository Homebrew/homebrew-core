class Termtosvg < Formula
  include Language::Python::Virtualenv

  desc "Record terminal sessions as SVG animations"
  homepage "https://nbedos.github.io/termtosvg"
  url "https://github.com/nbedos/termtosvg/archive/1.1.0.tar.gz"
  sha256 "53e9ad5976978684699d14b83cac37bf173d76c787f1b849859ad8aef55f22d2"
  license "BSD-3-Clause"
  revision 3

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "64592df207911cfbeff3795bfa938b2dcf57e151a6b9466ab907ee3411236607"
    sha256 cellar: :any_skip_relocation, big_sur:       "16c74ac4446e7e91a1b7474ce3026f8546ba04430b8572944db7152fa9c3d48e"
    sha256 cellar: :any_skip_relocation, catalina:      "350d8b4e73ae41f0ea1268c19df0c5f0eb101085bc2d29df5013579b24e72a4d"
    sha256 cellar: :any_skip_relocation, mojave:        "22decfefbd2791ac22f3e267467f53a84524298a5cf1d9b285e97568555b12f0"
    sha256 cellar: :any_skip_relocation, high_sierra:   "26a80230af97da8f083d5e3004cb3a000e4cd16e33ce4e733400a9d9d0ade42a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a59382abe26b1f6fabec9c381c34cf1e828c6a864269d1f421c158bf689a704"
  end

  deprecate! date: "2020-06-16", because: :repo_archived

  depends_on "python@3.10"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/e5/21/a2e4517e3d216f0051687eea3d3317557bde68736f038a3b105ac3809247/lxml-4.6.3.tar.gz"
    sha256 "39b78571b3b30645ac77b95f7c69d1bffc4cf8c3b157c435a34da72e78c82468"
  end

  resource "pyte" do
    url "https://files.pythonhosted.org/packages/66/37/6fed89b484c8012a0343117f085c92df8447a18af4966d25599861cd5aa0/pyte-0.8.0.tar.gz"
    sha256 "7e71d03e972d6f262cbe8704ff70039855f05ee6f7ad9d7129df9c977b5a88c5"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system libexec/"bin/python", "-m", "unittest", "termtosvg.tests.suite"
  end
end
