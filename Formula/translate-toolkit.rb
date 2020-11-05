class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://github.com/translate/translate/archive/3.2.0.tar.gz"
  sha256 "f55afa52e24f0327f8dfd53ae139d6123b4bfef89630d17517272c96f187b29c"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "015efa106cb3abf1ea35fdf4769de42ec35ce648f4d5d4891829772ae179eb20" => :catalina
    sha256 "51660c48ee4be1f54848d99b5f2fd9dc94c0cc023d4a302c55d49ab9b9e820a7" => :mojave
    sha256 "2b5b4777bbbca8c34081c53ad9fcb29ecca9983b708e57ee8833f60a026317aa" => :high_sierra
  end

  depends_on "python@3.9"

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
