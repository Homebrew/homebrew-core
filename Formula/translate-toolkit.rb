class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/70/e7/a1adb755aae35784ccb4323cde1216a71899bd68952e28ce1427b8f20533/translate-toolkit-3.6.0.tar.gz"
  sha256 "dfdb19383920948e5bc1dafacb994ee07f8d6ecc053cd6e2b4c545ce0430ddff"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53ed98e315bfcaf5e22e6d0e4764ebb0684bee3418fa3ac40724d0a85ff35924"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "271c7d9e4164f785177c7745d4604f7cdbe7624d7e57d09729fdcb87c80ba079"
    sha256 cellar: :any_skip_relocation, monterey:       "0d27584d4f308f514437913276cd66554de4caa4080a378bba574c890dc9624e"
    sha256 cellar: :any_skip_relocation, big_sur:        "9198ea874fb246a454d0750289d8a44ccb4d8667cf95671e235ba8c98effe4b6"
    sha256 cellar: :any_skip_relocation, catalina:       "e71bb387af6d6684deba4ec45dd6e346a7b7524debf53c821e26ad9ee0fd4f6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0900cfda447fcff6de7ac14426b0618cf535ccde71031ead8488350153ca3d65"
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
