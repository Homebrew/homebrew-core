class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/85/82/3a438db453da5daf3c1401d1f678f075f6810b5fc54340700ce5fb9b8fdf/translate-toolkit-3.8.6.tar.gz"
  sha256 "44702fefc19a7e574952453201275936e11b8523c21b5298d5b04be57364bbf4"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "27eaf3adbbf28e5f506f9ef162434cda42fdaf0aa7bb16c40c17ae9bb93cfcb1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68caae6ec74d6f0f4073310d7704d48f6393e90fffbc66d60f3ca4c40d2fd047"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a42e6e4f70198120d4432b2e72efbf1e472e2d30e40ed1587d0a5667fe3dcc7a"
    sha256 cellar: :any_skip_relocation, ventura:        "16fbc8479f3cde7c246b3cace55b32ce0f136d887662e9bef29a2d5b899c6b31"
    sha256 cellar: :any_skip_relocation, monterey:       "900872a9221ae6d0c8f3a302da183594639bfd471a65797bdd606684041e4f9b"
    sha256 cellar: :any_skip_relocation, big_sur:        "0b6fb427720c4569ccae2556e6fcd620c919e7cb92f38b4bd74c09cdeda5782c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26fdd3d575108207ef76c7277f5660ced4c2f57a397d21daad97142f682c569f"
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
