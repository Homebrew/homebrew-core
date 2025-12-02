class Xdot < Formula
  include Language::Python::Virtualenv

  desc "Interactive viewer for graphs written in Graphviz's dot language"
  homepage "https://github.com/jrfonseca/xdot.py"
  url "https://files.pythonhosted.org/packages/38/76/0503dddc3100e25135d1380f89cfa5d729b7d113a851804aa98dc4f19888/xdot-1.4.tar.gz"
  sha256 "fb029dab92b3c188ad5479108014edccb6c7df54f689ce7f1bd1c699010b7781"
  license "LGPL-3.0-or-later"
  head "https://github.com/jrfonseca/xdot.py.git", branch: "main"

  no_autobump! because: "`update-python-resources` cannot determine dependencies"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "31da3f49cb2d321330f9caf9ead425cc46dfb18b4bb9b85b572a4b985131dfa9"
  end

  depends_on "adwaita-icon-theme"
  depends_on "graphviz"
  depends_on "gtk+3"
  depends_on "numpy"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python@3.14"

  pypi_packages exclude_packages: ["numpy", "pygobject"],
                extra_packages:   "graphviz"

  resource "graphviz" do
    url "https://files.pythonhosted.org/packages/fa/83/5a40d19b8347f017e417710907f824915fba411a9befd092e52746b63e9f/graphviz-0.20.3.zip"
    sha256 "09d6bc81e6a9fa392e7ba52135a9d49f1ed62526f96499325930e87ca1b5925d"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
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
