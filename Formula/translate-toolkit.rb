class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "http://toolkit.translatehouse.org/"
  url "https://github.com/translate/translate/releases/download/2.2.1/translate-toolkit-2.2.1.tar.gz"
  sha256 "370cb43f456c7fba4f644bfeccdf9aa53edfd90fa72061982040893b06b959e9"
  head "https://github.com/translate/translate.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d69d47cab214bbb4af8f6771ebd7ea8127c092720d5282e9e8d7aa37b31b2a4e" => :sierra
    sha256 "2215196bf1bb37ca376e0b2987e9430b37d9dbad97454ab470ec11ffc19f087c" => :el_capitan
    sha256 "40afdaa90672dc71b6493a4f49edf1ff6870b6698e8729f8dbdd9d5eb828e97a" => :yosemite
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
