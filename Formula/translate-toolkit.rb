class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/22/e2/06907247a5af63c8f803b688daedf7fd488067eead833db66660ac8dfd16/translate-toolkit-3.3.6.tar.gz"
  sha256 "abc6815ac563a013ba5dcbc245bddb6b2000f8de112999a85ed087a989de1860"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a439b83d140d4be311b56ee1cbd85a3371d1da9b500b4fc8e18bf00416828537"
    sha256 cellar: :any_skip_relocation, big_sur:       "e32e7e1132860ff63ce9ff7f8a5c440292abf81bcf0a64053a550da975ad90ee"
    sha256 cellar: :any_skip_relocation, catalina:      "ff423a7b0fa3804ff469a8313dc01ace1d7677169135ab03c7aa8dcdba66d184"
    sha256 cellar: :any_skip_relocation, mojave:        "2fa93ac32fca77071ba94be9700af857fce115df8743611c41605a5ea8e27e74"
  end

  depends_on "python@3.9"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/e5/21/a2e4517e3d216f0051687eea3d3317557bde68736f038a3b105ac3809247/lxml-4.6.3.tar.gz"
    sha256 "39b78571b3b30645ac77b95f7c69d1bffc4cf8c3b157c435a34da72e78c82468"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"pretranslate", "-h"
    system bin/"podebug", "-h"
  end
end
