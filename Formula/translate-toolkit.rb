class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/c1/84/a780fdb5a2f74783fa011169252e67af532146cc7a5d31be40e31e82bc42/translate-toolkit-3.3.4.tar.gz"
  sha256 "907965b3990fc616c708794c02490bdd438193c76b47b2186ed82c911c99a415"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f5e5a3810e2756658ce0992c926f9347c48177ea9a76069a7fd504a6d668f69c"
    sha256 cellar: :any_skip_relocation, big_sur:       "a5af52630650fd236e33b0a27b43e6d88bc91f4a2c0e4fd544276747dc69cf6b"
    sha256 cellar: :any_skip_relocation, catalina:      "15762fcfdcc621fbae65c399c5d0b553f03aa475f59c7fba5bee4d9159ebc05f"
    sha256 cellar: :any_skip_relocation, mojave:        "8b6dee19aa31d7f02f9c5178f02b61b68dae8b71fb2d1c8c27b200551926b9c8"
  end

  depends_on "python@3.9"

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
