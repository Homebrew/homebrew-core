class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/08/a5/876e2407d0d405fde31524e04f6ea2d068e06f53afc7b5c857a2fde51612/translate-toolkit-3.5.1.tar.gz"
  sha256 "3b51f548ef9d27b4f47a33b7d4eb299119d0fff71ba41f48eb5bd9bbeeb91708"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39c4cadc2ff8063fc42d48d808653519d41a14e78f69b5d8b4320e4a2b18eb66"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c2ee426411c346ecf85cbb0b50f88ee64fa213323dbb5ca22fc4adbda314f25d"
    sha256 cellar: :any_skip_relocation, monterey:       "4c3177c722c59f4495d86991b162b16ab44c7e7635bdf434ce4c3e195e4f703a"
    sha256 cellar: :any_skip_relocation, big_sur:        "12bde4703bb24bd413ee15ae8adcf6fad32c023c1a67dc3b44bd9210c9ba54f5"
    sha256 cellar: :any_skip_relocation, catalina:       "b7b7e795126299d060cee9145b3bdea8839c691f59b895ef5a4e0307137e2bfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e64da4fb32b17bf883b18652392d37183cae93fa4a151d058bdf77ee36bdd70"
  end

  depends_on "python@3.10"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/fe/4c/a4dbb4e389f75e69dbfb623462dfe0d0e652107a95481d40084830d29b37/lxml-4.6.4.tar.gz"
    sha256 "daf9bd1fee31f1c7a5928b3e1059e09a8d683ea58fb3ffc773b6c88cb8d1399c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"pretranslate", "-h"
    system bin/"podebug", "-h"
  end
end
