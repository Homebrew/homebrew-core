class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/b5/eb/627acb832cab45f001af16347d24cbcfa702997c18653542c2eefd3482b6/translate-toolkit-3.7.0.tar.gz"
  sha256 "a3d403dce1fcabb146db20ae6acded9197d04e478561762fb43b174f5584d229"
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
    url "https://files.pythonhosted.org/packages/aa/23/bda4e9881090f0f5e33e2efe89aacfa0668eb6e1ab2de28591e2912d78d4/lxml-4.9.0.tar.gz"
    sha256 "520461c36727268a989790aef08884347cd41f2d8ae855489ccf40b50321d8d7"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"pretranslate", "-h"
    system bin/"podebug", "-h"
  end
end
