class Xdot < Formula
  desc "Interactive viewer for graphs written in Graphviz's dot language"
  homepage "https://github.com/jrfonseca/xdot.py"
  url "https://files.pythonhosted.org/packages/8b/f5/f5282a470a1c0f16b6600edae18ffdc3715cdd6ac8753205df034650cebe/xdot-1.2.tar.gz"
  sha256 "3df91e6c671869bd2a6b2a8883fa3476dbe2ba763bd2a7646cf848a9eba71b70"
  license "LGPL-3.0"
  head "https://github.com/jrfonseca/xdot.py.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, monterey: "adec932e49a5bf43f613b4e24123d23dd6365cd63ff770b80471280e8d24dc46"
    sha256 cellar: :any_skip_relocation, big_sur:  "cde9b3087f5d052432a49145b7e7b91aae192999a842f5764c6ed17cda033206"
    sha256 cellar: :any_skip_relocation, catalina: "d8f03ae6eeb651fce014693fa933718777d2e1add5dbdd6939460797ca8bb4d0"
    sha256 cellar: :any_skip_relocation, mojave:   "771363f972fd67d88d8ed836a654248bbc9cc41109881eec54211aedaf507681"
  end

  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "numpy"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python@3.9"

  resource "graphviz" do
    url "https://files.pythonhosted.org/packages/33/c4/82459071796f59ef218d3c22d43d35aa0fbcf74f9fcce8829672febd7f5e/graphviz-0.15.zip"
    sha256 "2b85f105024e229ec330fe5067abbe9aa0d7708921a585ecc2bf56000bf5e027"
  end

  def install
    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    resource("graphviz").stage do
      system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(libexec/"vendor")
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/xdot", "--help"
  end
end
