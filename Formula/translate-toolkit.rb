class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/09/75/527fd0f2edd605e25cbe18acdf499b8ecaa83070092b7ef7dad5c9df148f/translate-toolkit-3.7.3.tar.gz"
  sha256 "14e44dc9b187ccf51c215c57a37475a6bd3719da68104d89dc0b8f33d973dc3e"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f023a7d00fc3f69d9bf24922750a49652f606e69c47fbca7c7de78032597be3e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2e60c03d083f87613a8f77b87079fc4197452d2f294260493711e488d326e9f1"
    sha256 cellar: :any_skip_relocation, monterey:       "485047a629bb4ef507100b1d0c4d9de0c3e92e722f4e9bd9e59559727a78c3e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "696e0f92448bcbe5032a023fd81e4052f0fbb6acef2ca5524768f929969791fd"
    sha256 cellar: :any_skip_relocation, catalina:       "fc711152009473793e42050208c01fda6f4259a5a093c421f376432c0243fc29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9576ef4f0452d8203526a2204b73322e9e424508b8b52e189d72e4b3c0d8763f"
  end

  depends_on "python@3.10"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/70/bb/7a2c7b4f8f434aa1ee801704bf08f1e53d7b5feba3d5313ab17003477808/lxml-4.9.1.tar.gz"
    sha256 "fe749b052bb7233fe5d072fcb549221a8cb1a16725c47c37e42b0b9cb3ff2c3f"
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
