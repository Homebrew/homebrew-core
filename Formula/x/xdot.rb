class Xdot < Formula
  include Language::Python::Virtualenv

  desc "Interactive viewer for graphs written in Graphviz's dot language"
  homepage "https://github.com/jrfonseca/xdot.py"
  url "https://files.pythonhosted.org/packages/2d/74/7f9af65f53fda367a82b5355bc8dd55d6cc0320bbc84b233749df3fd58f0/xdot-1.3.tar.gz"
  sha256 "16dcaf7c063cc7fb26a5290a0d16606b03de178a6535e3d49dd16709b6420681"
  license "LGPL-3.0-or-later"
  head "https://github.com/jrfonseca/xdot.py.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a5fa743c1cd886c911a0b7be7e0c0ce047cb2137456dffd781df01a70bec5139"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5fa743c1cd886c911a0b7be7e0c0ce047cb2137456dffd781df01a70bec5139"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5fa743c1cd886c911a0b7be7e0c0ce047cb2137456dffd781df01a70bec5139"
    sha256 cellar: :any_skip_relocation, sonoma:         "6388495e914b6a72dc929489a99f638305c3bbc1a3d9afe7f8e825dc844345e5"
    sha256 cellar: :any_skip_relocation, ventura:        "6388495e914b6a72dc929489a99f638305c3bbc1a3d9afe7f8e825dc844345e5"
    sha256 cellar: :any_skip_relocation, monterey:       "6388495e914b6a72dc929489a99f638305c3bbc1a3d9afe7f8e825dc844345e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94dafcfccfdbb31a72bfbdd8840569763505d54610b024969e2b2cffa5fe8898"
  end

  depends_on "adwaita-icon-theme"
  depends_on "graphviz"
  depends_on "gtk+3"
  depends_on "numpy"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python@3.12"

  resource "graphviz" do
    url "https://files.pythonhosted.org/packages/a5/90/fb047ce95c1eadde6ae78b3fca6a598b4c307277d4f8175d12b18b8f7321/graphviz-0.20.1.zip"
    sha256 "8c58f14adaa3b947daf26c19bc1e98c4e0702cdc31cf99153e6f06904d492bf8"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/4d/5b/dc575711b6b8f2f866131a40d053e30e962e633b332acf7cd2c24843d83d/setuptools-69.2.0.tar.gz"
    sha256 "0ff4183f8f42cd8fa3acea16c45205521a4ef28f73c6391d8a25e92893134f2e"
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
