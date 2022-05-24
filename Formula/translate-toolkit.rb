class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/b6/71/1b7b4b74cfe2c3ec0ec25da29555d487c0a68be03112246a34d1f380dfec/translate-toolkit-3.6.2.tar.gz"
  sha256 "91b247b159f4fa2ae2ed9b0a6c88a2dc207f1cd3cb93f754a9059e7eaebe8c54"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a966fc23b7cb5653e4c70fd4477cc36636aca09f6b28f30c03821dfbf07e4d02"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc61978f1aeb8339da055caa3c5d1e5a10fdba4ba826ec436f22651f677bbe2b"
    sha256 cellar: :any_skip_relocation, monterey:       "797e27d307ed6059a53b5d991628ff9c86326149618844c68eb51323be3ffcf0"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b6267bd9493ae5e52202e4efda11a8e61d4fc4b12f862e04d83cfc3fc49d44a"
    sha256 cellar: :any_skip_relocation, catalina:       "08dbd30adbae99af7b16978294d8c774392a2cdb06b8cfdca49d013b1fb6a8ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d766dbe1b73c8b5518e8e5ec33eb7e6ba75e2b3662ab8bfcef1260b63826be8e"
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
