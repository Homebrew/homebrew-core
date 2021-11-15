class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/08/a5/876e2407d0d405fde31524e04f6ea2d068e06f53afc7b5c857a2fde51612/translate-toolkit-3.5.1.tar.gz"
  sha256 "3b51f548ef9d27b4f47a33b7d4eb299119d0fff71ba41f48eb5bd9bbeeb91708"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c726d06e80789183673ad4e7eb2ceaa034db6cae0ae4dc0a67fc2e9e75d57cf2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae5e78a300e148813bdaf3bf2b14587d139895b5aaea2464e8b582221d79e108"
    sha256 cellar: :any_skip_relocation, monterey:       "97e55fa37ebeb0a7ad63d4f8837717ed668e4904e1ec759182a4c3ed82ffb655"
    sha256 cellar: :any_skip_relocation, big_sur:        "62b23fd44d5cb971ea36b064561e35ec58159c4f843f4eaf98a76030969c6622"
    sha256 cellar: :any_skip_relocation, catalina:       "cbaddedfdae37dcf7e7c7d385ba334b3ca57620ed36ecf2462f709fe242e605c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8aa19e9bd58947456946af18af710b0877d6e7b946811c229ea2627946bd311"
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
