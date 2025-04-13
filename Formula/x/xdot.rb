class Xdot < Formula
  include Language::Python::Virtualenv

  desc "Interactive viewer for graphs written in Graphviz's dot language"
  homepage "https://github.com/jrfonseca/xdot.py"
  url "https://files.pythonhosted.org/packages/38/76/0503dddc3100e25135d1380f89cfa5d729b7d113a851804aa98dc4f19888/xdot-1.4.tar.gz"
  sha256 "fb029dab92b3c188ad5479108014edccb6c7df54f689ce7f1bd1c699010b7781"
  license "LGPL-3.0-or-later"
  head "https://github.com/jrfonseca/xdot.py.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f3a6484db099186946f2e3fca16c51cd622e70030959554352b1128c1169d07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f3a6484db099186946f2e3fca16c51cd622e70030959554352b1128c1169d07"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8f3a6484db099186946f2e3fca16c51cd622e70030959554352b1128c1169d07"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f3a6484db099186946f2e3fca16c51cd622e70030959554352b1128c1169d07"
    sha256 cellar: :any_skip_relocation, ventura:       "8f3a6484db099186946f2e3fca16c51cd622e70030959554352b1128c1169d07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b3962fef1f997c4e28a6ee0684728d9be91070c1ffee7e974dcabdf556839b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9784e3d92d41e7cc137ec42897898b98428120f7107e168ec24b8b97ea0f8fb"
  end

  depends_on "adwaita-icon-theme"
  depends_on "graphviz"
  depends_on "gtk+3"
  depends_on "numpy"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python@3.13"

  resource "graphviz" do
    url "https://files.pythonhosted.org/packages/fa/83/5a40d19b8347f017e417710907f824915fba411a9befd092e52746b63e9f/graphviz-0.20.3.zip"
    sha256 "09d6bc81e6a9fa392e7ba52135a9d49f1ed62526f96499325930e87ca1b5925d"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
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
