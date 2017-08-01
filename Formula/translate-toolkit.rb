class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "http://toolkit.translatehouse.org/"
  url "https://github.com/translate/translate/releases/download/2.2.4/translate-toolkit-2.2.4.tar.gz"
  sha256 "c37e32616557e9e514dc5820c72a7cdf0989ab0e350ab4ed03a52bbc9d75cfa1"
  head "https://github.com/translate/translate.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8d23998d34f6764cb59f565f4fd1404be381a68b915a1a0c4b242a3acd6a8ab0" => :sierra
    sha256 "426e03c2c83b94d03060987192ea472eaa28b4cb39c7dc65ea2c11af2d620819" => :el_capitan
    sha256 "68a8cfd82937451fe3712b1f0561dad185b1b01d2bd59f688938a2aeb26cc207" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "argparse" do
    url "https://files.pythonhosted.org/packages/18/dd/e617cfc3f6210ae183374cd9f6a26b20514bbb5a792af97949c5aacddf0f/argparse-1.4.0.tar.gz"
    sha256 "62b089a55be1d8949cd2bc7e0df0bddb9e028faefc8c32038cc84862aefdd6e4"
  end

  resource "diff-match-patch" do
    url "https://files.pythonhosted.org/packages/22/82/46eaeab04805b4fac17630b59f30c4f2c8860988bcefd730ff4f1992908b/diff-match-patch-20121119.tar.gz"
    sha256 "9dba5611fbf27893347349fd51cc1911cb403682a7163373adacc565d11e2e4c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"pretranslate", "-h"
  end
end
