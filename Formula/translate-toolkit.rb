class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/85/82/3a438db453da5daf3c1401d1f678f075f6810b5fc54340700ce5fb9b8fdf/translate-toolkit-3.8.6.tar.gz"
  sha256 "44702fefc19a7e574952453201275936e11b8523c21b5298d5b04be57364bbf4"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d393614cf4fd11fba3730aabaa91a9aac409c82bc571edb1961cd1a33afa275"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b91313f175d269fa2fc542aff141830d7e97247c6d2ac1126c441429a02b8c93"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a11462a3f9c753f895688436b7945e7026482c0c008e69843037a6b8f9773376"
    sha256 cellar: :any_skip_relocation, ventura:        "7ad727516e80fd6a203f4d56ee2c78758183f674ad3174f27fae5dae06fe8ca4"
    sha256 cellar: :any_skip_relocation, monterey:       "801aa31cc40aca5472ff43bd17358dfbc0ada16636d7f5aa33e5d8aea82630f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "20cd0cabe0c5d210a3f9e6a120802000d5546d10ae3a3b360549df1d920df2fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f0909c38dafc5f2627f5561d5299524cd6885705867c4b32064b05dc20438d8"
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
