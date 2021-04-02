class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/c1/84/a780fdb5a2f74783fa011169252e67af532146cc7a5d31be40e31e82bc42/translate-toolkit-3.3.4.tar.gz"
  sha256 "907965b3990fc616c708794c02490bdd438193c76b47b2186ed82c911c99a415"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7d68a7f2561c7a910deac3be0cda17f8997a24e9b4ffb4b70281c02d6ac861ec"
    sha256 cellar: :any_skip_relocation, big_sur:       "41bc7f57b0f187fa0398dfee83a462434389053a05c1baae0d911d8e249c783f"
    sha256 cellar: :any_skip_relocation, catalina:      "cb1e2ce602b5292f7e7823369f5067e1649e2dfa114dc8159e289bb682e2a5d2"
    sha256 cellar: :any_skip_relocation, mojave:        "c46aee1c0c40f13a6ebfa455f26d4a6543bb6e22e237ce80a85bf20c6a50ae1f"
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
