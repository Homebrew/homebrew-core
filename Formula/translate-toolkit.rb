class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/e0/77/3b14b8f73a8c95280bfc47e9776b6d1ee047340414d58d92c2bccc4a27c3/translate-toolkit-3.3.3.tar.gz"
  sha256 "d4f84fdade3885bf0cf01bb77948aed6d270546b899c44164f8f3737a3a37d29"
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
    url "https://files.pythonhosted.org/packages/db/f7/43fecb94d66959c1e23aa53d6161231dca0e93ec500224cf31b3c4073e37/lxml-4.6.2.tar.gz"
    sha256 "cd11c7e8d21af997ee8079037fff88f16fda188a9776eb4b81c7e4c9c0a7d7fc"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"pretranslate", "-h"
    system bin/"podebug", "-h"
  end
end
