class Xdot < Formula
  include Language::Python::Virtualenv

  desc "Interactive viewer for graphs written in Graphviz's dot language"
  homepage "https://github.com/jrfonseca/xdot.py"
  url "https://files.pythonhosted.org/packages/8b/f5/f5282a470a1c0f16b6600edae18ffdc3715cdd6ac8753205df034650cebe/xdot-1.2.tar.gz"
  sha256 "3df91e6c671869bd2a6b2a8883fa3476dbe2ba763bd2a7646cf848a9eba71b70"
  license "LGPL-3.0-or-later"
  revision 1
  head "https://github.com/jrfonseca/xdot.py.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d34c1157f229d19ee48c1ea536c77d16eaacd6d62d359a342cfaa2b5fbf4d501"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f78b343057695b52041f6592297348110d9013c47fca2b430be830647c8a32b9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f78b343057695b52041f6592297348110d9013c47fca2b430be830647c8a32b9"
    sha256 cellar: :any_skip_relocation, ventura:        "089a791d01ee40a258bbd8057fc18cc47818a3468670bf193fd442bee9024d1f"
    sha256 cellar: :any_skip_relocation, monterey:       "5215a6bd62479ab926302984c29c7f28a91cb5d42c4d8d056d0ab3ecafe5af57"
    sha256 cellar: :any_skip_relocation, big_sur:        "5215a6bd62479ab926302984c29c7f28a91cb5d42c4d8d056d0ab3ecafe5af57"
    sha256 cellar: :any_skip_relocation, catalina:       "5215a6bd62479ab926302984c29c7f28a91cb5d42c4d8d056d0ab3ecafe5af57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2e110c2ed7deb3a436515aba477df6e72cc554473a429f9280fc928fc2cff06"
  end

  depends_on "adwaita-icon-theme"
  depends_on "graphviz"
  depends_on "gtk+3"
  depends_on "numpy"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python@3.10"

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
