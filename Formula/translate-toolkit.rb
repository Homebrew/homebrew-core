class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "http://toolkit.translatehouse.org/"
  url "https://github.com/translate/translate/releases/download/1.13.0/translate-toolkit-1.13.0.tar.bz2"
  sha256 "dcbbf49058e4196a06e988d9dc1e762321ab0d057c4be035b84e3c11353fc2f8"
  head "https://github.com/translate/translate.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a94ad64962410b08fc781a5be8475a094b1c94837985573d7aa1957483e16387" => :sierra
    sha256 "edf462681a76fa0c57b30259e5b403da4c4c9d9d37416653c083b6cd4c2bc873" => :el_capitan
    sha256 "6592587cad1508205717c75108d3ddb46512062f51b593c8a73ffcc01f5dd3ba" => :yosemite
    sha256 "d7012e9f5f530c82557db988fe6266d108d52ad426e0e832182852815f96aabe" => :mavericks
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
