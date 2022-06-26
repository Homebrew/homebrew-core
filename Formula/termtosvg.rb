class Termtosvg < Formula
  include Language::Python::Virtualenv

  desc "Record terminal sessions as SVG animations"
  homepage "https://nbedos.github.io/termtosvg"
  url "https://github.com/nbedos/termtosvg/archive/1.1.0.tar.gz"
  sha256 "53e9ad5976978684699d14b83cac37bf173d76c787f1b849859ad8aef55f22d2"
  license "BSD-3-Clause"
  revision 3

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "724f67913066d53b19c8ca53eb8110a39293cd416dcf2c2d1cea5f78a070bb83"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "23db60dd604e925a43b598be9a7fd2f6a9c94b32764066ba2bfcf45e9b60396d"
    sha256 cellar: :any_skip_relocation, monterey:       "a5bec176e665df6ed59fea8cfb15550668bcaee87624f35fea2737f74c050366"
    sha256 cellar: :any_skip_relocation, big_sur:        "32f1142366e73140d1d96f7003d9e3d745a08adb998278d3ec96acbea25888e4"
    sha256 cellar: :any_skip_relocation, catalina:       "085ece852b31385103c159ee5b81fac163264e803a1014ada30e0f4260fc43ac"
    sha256 cellar: :any_skip_relocation, mojave:         "9ddce257d68a972d67278fd51e2ac818fd13b7ad84932f0590bda076b1224aa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21df9137fcd9c002b52eab21f6d6690b0b187ca1436e77d328ca0157643b95e6"
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
