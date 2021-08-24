class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/87/b3/5685345e8f7ca801c7a2e54c982a4435af67d30d2c73404744174df30122/translate-toolkit-3.4.0.tar.gz"
  sha256 "37bfbb73035bf6780f6745d40f3f7d02287b168ebac6aa2ce5a6dfbe4e1b86f7"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "64df7fac56b116b2181c7d305007a4435bc74039de971fbc1240bdcf6752e431"
    sha256 cellar: :any_skip_relocation, big_sur:       "54152eeaebe60c32cf1ab5b1f083d9c1cf3cc491b6acdb0680e00a96cd95e28c"
    sha256 cellar: :any_skip_relocation, catalina:      "c2f4a1e4c92d3570682b06b25a3a05372a892f10a5c97ce0924c1e1cbdb3e650"
    sha256 cellar: :any_skip_relocation, mojave:        "cf537c33124e0a1fd123939bb491e847d936a01065d2ddb91b892c46c5aeff5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9148123166c668c3c3c7d1d89caefdb62b1214618fda6aeee4aa2bf8925d08b3"
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
