class Xdot < Formula
  include Language::Python::Virtualenv

  desc "Interactive viewer for graphs written in Graphviz's dot language"
  homepage "https://github.com/jrfonseca/xdot.py"
  url "https://files.pythonhosted.org/packages/38/76/0503dddc3100e25135d1380f89cfa5d729b7d113a851804aa98dc4f19888/xdot-1.4.tar.gz"
  sha256 "fb029dab92b3c188ad5479108014edccb6c7df54f689ce7f1bd1c699010b7781"
  license "LGPL-3.0-or-later"
  head "https://github.com/jrfonseca/xdot.py.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d7e8e28174ba8fb1ee4db28003a932a797ce3bdc3082a7c087c909b01c093ea9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fea41f59e6cf3192c8d6bc352f1d6f219672ec3815b0317c4c86a78eae14e2dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "674284613775b93ddca70f21cc26ccbc195c24d50c2f57ce2a489dbbc661a132"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b997eba3b1a3b41a6a15e64a0728cf6f43d59ef0e62d95c227199ce4c24c461"
    sha256 cellar: :any_skip_relocation, sonoma:         "ca942ec49815794f7a49442c754a7ce193d1702c2002297e869f6f8dcb3f8362"
    sha256 cellar: :any_skip_relocation, ventura:        "6d8747eb0f97917daf9c1c46d02c1348c4e4e7586d7dce7e99caf72eba057243"
    sha256 cellar: :any_skip_relocation, monterey:       "c479f17574ea512de3a1a152ab8423fcd95f0c2c93032233363750240b79bc12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d4ee5d0df84d35ecda8615029d5ad07067f9f8984b536750f3de9ab8a3ec47b"
  end

  depends_on "adwaita-icon-theme"
  depends_on "graphviz"
  depends_on "gtk+3"
  depends_on "numpy"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python@3.12"

  resource "graphviz" do
    url "https://files.pythonhosted.org/packages/fa/83/5a40d19b8347f017e417710907f824915fba411a9befd092e52746b63e9f/graphviz-0.20.3.zip"
    sha256 "09d6bc81e6a9fa392e7ba52135a9d49f1ed62526f96499325930e87ca1b5925d"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
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
