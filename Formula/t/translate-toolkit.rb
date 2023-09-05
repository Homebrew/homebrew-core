class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/d6/55/a26b19ff6245f6a84e45f9ff37f3a5d165222d81b8492fa79d34d22e14c6/translate-toolkit-3.10.1.tar.gz"
  sha256 "642e8597c55c3a31b8a6506194f0e64095965d5a1e7e0261d045a2865783a366"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "15ec0417a353cc6921e0098dcf14556f28fdfd97a2d7222aa95ab0c2b310fa75"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b02fbf3d3b657a8b4d6ebfcd52616939346c63fc80ecffacd1046b54a39bc623"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1fb8c2a8eb266cfd0bc55b284526c5e62ecf26830bc3ea40bd1dd958c9f260a9"
    sha256 cellar: :any_skip_relocation, ventura:        "b8cf5825857cd0e8814e402c2219a92ba229dfd82c2e844aea25e5ee5b6a2143"
    sha256 cellar: :any_skip_relocation, monterey:       "c76f206d3e47e69853bb329bc73735ba74e1ff990097d1bfcd726e5031dcb34a"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c9e0f5f4a08feb28b92fa4d40b881a6c564d307d0ac91f1839e6aa1e64296b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eba4521ada490ff2244dfc082160842a5cb9467ca970090e09aa7aa9356d0fc0"
  end

  depends_on "python@3.11"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/30/39/7305428d1c4f28282a4f5bdbef24e0f905d351f34cf351ceb131f5cddf78/lxml-4.9.3.tar.gz"
    sha256 "48628bd53a426c9eb9bc066a923acaa0878d1e86129fd5359aee99285f4eed9c"
  end

  def install
    # Workaround to avoid creating libexec/bin/__pycache__ which gets linked to bin
    ENV["PYTHONPYCACHEPREFIX"] = buildpath/"pycache"

    virtualenv_install_with_resources
  end

  test do
    system bin/"pretranslate", "-h"
    system bin/"podebug", "-h"
  end
end
