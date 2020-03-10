class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://github.com/translate/translate/archive/2.5.0.tar.gz"
  sha256 "4c4f28ab70f8bd028c8242c76a0dfef4ad88e0f62df53c5d7d6f2adcfac57600"
  revision 1
  head "https://github.com/translate/translate.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b26b15dd5cad2f33db55a095c5c122249f374201cf7768f4f1e203c53097b30f" => :catalina
    sha256 "db113798b83ef63ad4b7de9615a6fa3ceb5282480784931ebad375cbbd6ccf93" => :mojave
    sha256 "78e607805c484ec8be1d1e0381c33e50a2519f1be0b868681e9ab2013307ff1b" => :high_sierra
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
