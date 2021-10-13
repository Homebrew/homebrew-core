class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/51/db/eabac6fb11d18cf0f2e55db661d98207ca3edfe7a90ea14c82ce5c87ac53/translate-toolkit-3.4.1.tar.gz"
  sha256 "2edc72794513e33ece2a2ee5ee25709fe4fbeac4686ecf80366d4999dd98cfd0"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "93c67f8692eb7e00b6d1ef243dfafd79ebbc821130c65c4d1a748893c6d45676"
    sha256 cellar: :any_skip_relocation, big_sur:       "6285d1de148f1c0d7407454194ad3fdb1bd510e73017cab6d6b5d91c07aa5d79"
    sha256 cellar: :any_skip_relocation, catalina:      "c6ac5d4c0f9e945ab107f42f3f74f4f4c3eb42c39055019edc901255b5f2303d"
    sha256 cellar: :any_skip_relocation, mojave:        "c8b8eb31015877d2052636d3cf440be4da5b29936cc2a76bb04d968ba00aa330"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd2c1adeb663005f98249505678ebd9a4270c13fd3b75f8d060f8df07b5c847d"
  end

  depends_on "python@3.10"

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
