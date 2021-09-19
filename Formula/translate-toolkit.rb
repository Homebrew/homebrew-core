class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/51/db/eabac6fb11d18cf0f2e55db661d98207ca3edfe7a90ea14c82ce5c87ac53/translate-toolkit-3.4.1.tar.gz"
  sha256 "2edc72794513e33ece2a2ee5ee25709fe4fbeac4686ecf80366d4999dd98cfd0"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "07987b1dffacec39808bf49f5c0de6cacb60a2d4a0272223e457e71dd82494e8"
    sha256 cellar: :any_skip_relocation, big_sur:       "59c2e81acb166823333a7e1d29233458190e0322251671dd058415abed477c2d"
    sha256 cellar: :any_skip_relocation, catalina:      "9a54d5be8cb7bc27eec427f1432516f9e76fe96e2724644561a7fa42dac53ca9"
    sha256 cellar: :any_skip_relocation, mojave:        "71bc173f6d2ceb3d533c76510cdaf367f417e1ff4daaf124a09fef2ff2a8c647"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "958c328014f1b6be1b372da6bf17e4098fd0d5d0d4dd33a5180cfacd5e3aabd9"
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
