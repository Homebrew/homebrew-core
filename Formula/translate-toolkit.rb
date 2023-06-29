class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/c5/af/4e8d1c57d68b80bfcf3320cbfa99ccb29b9c7be267029524d12187a924d7/translate-toolkit-3.9.1.tar.gz"
  sha256 "df5a8b8832c723fe3d09c79db66245f1ff05d1c61527f60a695093cb800ca57b"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d8ec3af5295f07beb1587567c9e0af342808c6a7c91995376ae6a91f7658f27a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa72132019cc5d04de3423fce6a1757ff6aa9a8fbd945d3d9f80d29b62c0eef2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2989a0360b673635d8ae95ba12c8da13c0a545c8dca5008d3129eeb63e787917"
    sha256 cellar: :any_skip_relocation, ventura:        "330b70891fd373afe790afa273e0222ab13614f1697cc1e30086f5567835e4fa"
    sha256 cellar: :any_skip_relocation, monterey:       "18f6f035538d65342a14278e26dcff55f5599dd4745c7b0dfd3ddee0f0e42427"
    sha256 cellar: :any_skip_relocation, big_sur:        "1bdeaa823bfcd9268660a1b0c950afae33ff4838f3b7c54e072b3abe7669426c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c22c37ce00816766e625c58a768d1673f113f9e04b131fe77c7b9e653a65f82b"
  end

  depends_on "python@3.11"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/06/5a/e11cad7b79f2cf3dd2ff8f81fa8ca667e7591d3d8451768589996b65dec1/lxml-4.9.2.tar.gz"
    sha256 "2455cfaeb7ac70338b3257f41e21f0724f4b5b0c0e7702da67ee6c3640835b67"
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
