class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/ab/c1/446eb4c232c82e045dfe282c049bc1ed92c0805693b34f3097c4fe463cb8/translate-toolkit-3.5.2.tar.gz"
  sha256 "43d8fa8d765480c822ff7931f60be8b2836fd52307a4e85e449624b9d6fecef0"
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
    url "https://files.pythonhosted.org/packages/84/74/4a97db45381316cd6e7d4b1eb707d7f60d38cb2985b5dfd7251a340404da/lxml-4.7.1.tar.gz"
    sha256 "a1613838aa6b89af4ba10a0f3a972836128801ed008078f8c1244e65958f1b24"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"pretranslate", "-h"
    system bin/"podebug", "-h"
  end
end
