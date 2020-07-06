class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://github.com/translate/translate/archive/3.0.0.tar.gz"
  sha256 "edbd6035ca20f2edffb434fb80378f77494fdf41698f006fc93e0c4ce2eea8f2"
  license "GPL-2.0"
  head "https://github.com/translate/translate.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ea2f48f2d845370599c79250cff84803ebcf726bd31692d1c97cd2596d1e0f22" => :catalina
    sha256 "247a179be9f3125d7a87bf2c6cbace25cec702b39197c7f021f0eba2730b1dfb" => :mojave
    sha256 "f24e86898ef8e33d9090c369a4c9fbb235fa18307f8fda529a63b965f005c9a8" => :high_sierra
  end

  depends_on "python@3.8"

  resource "argparse" do
    url "https://files.pythonhosted.org/packages/18/dd/e617cfc3f6210ae183374cd9f6a26b20514bbb5a792af97949c5aacddf0f/argparse-1.4.0.tar.gz"
    sha256 "62b089a55be1d8949cd2bc7e0df0bddb9e028faefc8c32038cc84862aefdd6e4"
  end

  resource "diff-match-patch" do
    url "https://files.pythonhosted.org/packages/f0/2a/5ba07def0e9107d935aba62cf632afbd0f7c723a98af47ccbcab753d2452/diff-match-patch-20181111.tar.gz"
    sha256 "a809a996d0f09b9bbd59e9bbd0b71eed8c807922512910e05cbd3f9480712ddb"
  end

  resource "Python-Levenshtein" do
    url "https://files.pythonhosted.org/packages/42/a9/d1785c85ebf9b7dfacd08938dd028209c34a0ea3b1bcdb895208bd40a67d/python-Levenshtein-0.12.0.tar.gz"
    sha256 "033a11de5e3d19ea25c9302d11224e1a1898fe5abd23c61c7c360c25195e3eb1"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/21/9f/b251f7f8a76dec1d6651be194dfba8fb8d7781d10ab3987190de8391d08e/six-1.14.0.tar.gz"
    sha256 "236bdbdce46e6e6a3d61a337c0f8b763ca1e8717c03b369e87a7ec7ce1319c0a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"pretranslate", "-h"
  end
end
