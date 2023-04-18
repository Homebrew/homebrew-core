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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34ec125d9822fb012b35f6edf42243d043c0ba3493abcb752fd9255d2101f8e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34ec125d9822fb012b35f6edf42243d043c0ba3493abcb752fd9255d2101f8e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "34ec125d9822fb012b35f6edf42243d043c0ba3493abcb752fd9255d2101f8e3"
    sha256 cellar: :any_skip_relocation, ventura:        "f7a0b7332146b6a22a1a5c20e76568530ee48377bc43da7e07e2bfa4d4101776"
    sha256 cellar: :any_skip_relocation, monterey:       "f7a0b7332146b6a22a1a5c20e76568530ee48377bc43da7e07e2bfa4d4101776"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7a0b7332146b6a22a1a5c20e76568530ee48377bc43da7e07e2bfa4d4101776"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "171aefa6d629d12a896bc37037afae817dcfd71a4a80285a154ca1729e5657b3"
  end

  depends_on "adwaita-icon-theme"
  depends_on "graphviz"
  depends_on "gtk+3"
  depends_on "numpy"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python@3.11"

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
