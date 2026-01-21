class Xdot < Formula
  include Language::Python::Virtualenv

  desc "Interactive viewer for graphs written in Graphviz's dot language"
  homepage "https://github.com/jrfonseca/xdot.py"
  url "https://files.pythonhosted.org/packages/32/68/13f80d47bffda03eaf05bd076d1b2ef9a1cf39b461b37e32f303bcf048de/xdot-1.6.tar.gz"
  sha256 "ebddefc3e3aa9fd8b2e2ed884ed844043f843428b79dccda831803add55cc51d"
  license "LGPL-3.0-or-later"
  head "https://github.com/jrfonseca/xdot.py.git", branch: "main"

  no_autobump! because: "`update-python-resources` cannot determine dependencies"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "193dbb59ae557ef88dccf429fe0e1f8fd4fd82a0180b3bcf021dc84c5a891b9b"
  end

  depends_on "adwaita-icon-theme"
  depends_on "graphviz"
  depends_on "gtk+3"
  depends_on "numpy"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python@3.14"

  on_linux do
    depends_on "xorg-server" => :test
  end

  pypi_packages exclude_packages: ["numpy", "pygobject"],
                extra_packages:   "graphviz"

  resource "graphviz" do
    url "https://files.pythonhosted.org/packages/f8/b3/3ac91e9be6b761a4b30d66ff165e54439dcd48b83f4e20d644867215f6ca/graphviz-0.21.tar.gz"
    sha256 "20743e7183be82aaaa8ad6c93f8893c923bd6658a04c32ee115edb3c8a835f78"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    cmd = "#{bin}/xdot --help"
    cmd = "#{Formula["xorg-server"].bin}/xvfb-run #{cmd}" if OS.linux? && ENV.exclude?("DISPLAY")
    assert_match "interactive viewer for graphs", shell_output(cmd)
  end
end
