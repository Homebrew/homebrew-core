class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/09/75/527fd0f2edd605e25cbe18acdf499b8ecaa83070092b7ef7dad5c9df148f/translate-toolkit-3.7.3.tar.gz"
  sha256 "14e44dc9b187ccf51c215c57a37475a6bd3719da68104d89dc0b8f33d973dc3e"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e51a7c9db7e8b3e2a56cdd6c7cb6bdefca3f5a7658b8ef7765bc607050e30e9a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d5646858beb6d5e77063de8913f5c706d25a482679a22e645f00e1addd5a503f"
    sha256 cellar: :any_skip_relocation, monterey:       "c8206587310c12005399d2ba583ff66dedae4b408eb39ea41c2f6ad0fdfe8047"
    sha256 cellar: :any_skip_relocation, big_sur:        "5a42dd227814d16c46beb7fbfa1fe3e0b439527bfe65acf0092485da43f423a8"
    sha256 cellar: :any_skip_relocation, catalina:       "335f72ba82f43ec5eeccddf2a93356a88077c756284a4a4ef21e09cdb8eb4ef1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dfd71df4565781a58c548efd648257b3fcffef099d25b6b2b3e621651d147594"
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
