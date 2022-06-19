class Xdot < Formula
  include Language::Python::Virtualenv

  desc "Interactive viewer for graphs written in Graphviz's dot language"
  homepage "https://github.com/jrfonseca/xdot.py"
  url "https://files.pythonhosted.org/packages/8b/f5/f5282a470a1c0f16b6600edae18ffdc3715cdd6ac8753205df034650cebe/xdot-1.2.tar.gz"
  sha256 "3df91e6c671869bd2a6b2a8883fa3476dbe2ba763bd2a7646cf848a9eba71b70"
  license "LGPL-3.0-or-later"
  head "https://github.com/jrfonseca/xdot.py.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "adec932e49a5bf43f613b4e24123d23dd6365cd63ff770b80471280e8d24dc46"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "adec932e49a5bf43f613b4e24123d23dd6365cd63ff770b80471280e8d24dc46"
    sha256 cellar: :any_skip_relocation, monterey:       "adec932e49a5bf43f613b4e24123d23dd6365cd63ff770b80471280e8d24dc46"
    sha256 cellar: :any_skip_relocation, big_sur:        "cde9b3087f5d052432a49145b7e7b91aae192999a842f5764c6ed17cda033206"
    sha256 cellar: :any_skip_relocation, catalina:       "d8f03ae6eeb651fce014693fa933718777d2e1add5dbdd6939460797ca8bb4d0"
    sha256 cellar: :any_skip_relocation, mojave:         "771363f972fd67d88d8ed836a654248bbc9cc41109881eec54211aedaf507681"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00bda24e0f9c4ed867f2ca07a76aa49b7bafbad3de1ad3a95ef273cd6354108a"
  end

  depends_on "adwaita-icon-theme"
  depends_on "graphviz"
  depends_on "gtk+3"
  depends_on "numpy"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python@3.9"

  resource "graphviz" do
    url "https://files.pythonhosted.org/packages/43/ae/a0ee0dbddc06dbecfaece65c45c8c4729c394b5eb62e04e711e6495cdf64/graphviz-0.20.zip"
    sha256 "76bdfb73f42e72564ffe9c7299482f9d72f8e6cb8d54bce7b48ab323755e9ba5"
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
