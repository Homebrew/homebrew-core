class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/b6/71/1b7b4b74cfe2c3ec0ec25da29555d487c0a68be03112246a34d1f380dfec/translate-toolkit-3.6.2.tar.gz"
  sha256 "91b247b159f4fa2ae2ed9b0a6c88a2dc207f1cd3cb93f754a9059e7eaebe8c54"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d65fe0e35406ef983e1adfc34c68b40133d751e2ab8ab07ab90bb71cccf8ae7f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b2759488f9335eca4293c82cf4ffe13ba9fc93621754ef0fdc9a12da1ee61b25"
    sha256 cellar: :any_skip_relocation, monterey:       "a78cbc8ba3df0ba824db900d921759c6f025b8fbcbc815729de9d0f13f3956f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "27252ab117f532fab7830af63eb7c8125619aaa242b576b9887d0ae9e6b5f427"
    sha256 cellar: :any_skip_relocation, catalina:       "0ae171cc05f04437023441a5bf35f103f3b1c280fb8c29349ff5ae3a1405fb40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0d0d0c14997dec43f98fd9db13b864f1c735fa2864d8013f8ffc446359def09"
  end

  depends_on "python@3.10"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/3b/94/e2b1b3bad91d15526c7e38918795883cee18b93f6785ea8ecf13f8ffa01e/lxml-4.8.0.tar.gz"
    sha256 "f63f62fc60e6228a4ca9abae28228f35e1bd3ce675013d1dfb828688d50c6e23"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"pretranslate", "-h"
    system bin/"podebug", "-h"
  end
end
