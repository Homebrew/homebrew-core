class Xdot < Formula
  include Language::Python::Virtualenv

  desc "Interactive viewer for graphs written in Graphviz's dot language"
  homepage "https://github.com/jrfonseca/xdot.py"
  url "https://files.pythonhosted.org/packages/2d/74/7f9af65f53fda367a82b5355bc8dd55d6cc0320bbc84b233749df3fd58f0/xdot-1.3.tar.gz"
  sha256 "16dcaf7c063cc7fb26a5290a0d16606b03de178a6535e3d49dd16709b6420681"
  license "LGPL-3.0-or-later"
  head "https://github.com/jrfonseca/xdot.py.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a59db9e091ecff0b318f223f9ba316f91e1173e3221e19371cbf769f34721df4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e2e3c088fc43db9fd8d2b2ebfa02e729a533ef3e8562a78e06cb2652dc8a873"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f6bb055d3e4b04f798da20971c16d3ea67b3464d892592db34c23bbad3dcc35"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "724df2bb58f5435fa527b1e2f8863071f369178bb7becf1d07e583b6eb0b98ac"
    sha256 cellar: :any_skip_relocation, sonoma:         "0ffcc78cd4884c755043c73b53b8a795600b1627d94a54b69768fdb9b7ba5c8f"
    sha256 cellar: :any_skip_relocation, ventura:        "f1f0e861109fab15e0bcd39fe16c3aec5496d7bac450d9229c315efc07c2dbe6"
    sha256 cellar: :any_skip_relocation, monterey:       "2c74b79c48f9d6181e9182f154c4f8612db08f0ce53eee1e8cd1687ca8ead32d"
    sha256 cellar: :any_skip_relocation, big_sur:        "a9458a255391d1ddc5e7770d16e971e38ad7746928afef9022a85a223cba1a60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5038c9497d3a17f42998673271a3546ac00a01dbdb15a11bae99f7e9a99bf458"
  end

  depends_on "adwaita-icon-theme"
  depends_on "graphviz"
  depends_on "gtk+3"
  depends_on "numpy"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python@3.11"

  resource "graphviz" do
    url "https://files.pythonhosted.org/packages/a5/90/fb047ce95c1eadde6ae78b3fca6a598b4c307277d4f8175d12b18b8f7321/graphviz-0.20.1.zip"
    sha256 "8c58f14adaa3b947daf26c19bc1e98c4e0702cdc31cf99153e6f06904d492bf8"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # Disable test on Linux because it fails with this error:
    # Gtk couldn't be initialized. Use Gtk.init_check() if you want to handle this case.
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"xdot", "--help"
  end
end
