class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "http://toolkit.translatehouse.org/"
  url "https://github.com/translate/translate/releases/download/2.2.5/translate-toolkit-2.2.5.tar.gz"
  sha256 "acaadb70c386795b3ea15605ddf57da6e29fae58a026b18988c04f44e2f58415"
  head "https://github.com/translate/translate.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "10df6ce11fc2925233611579f82f596ede2ad46460e587a197627f6507d7f68a" => :high_sierra
    sha256 "ffcfae1743967fbd7815d6b772f6330889115f8121f36e019fd2c5e920312150" => :sierra
    sha256 "e3387cc0175996b1a065352707d65506e8e613580d1b33f5a43db0b1eaf1672e" => :el_capitan
    sha256 "0906c4e2cda5f89cb8c4b0caf6e70ace27a62611be39ad01611e1b8637a2c121" => :yosemite
  end

  depends_on "python" if MacOS.version <= :snow_leopard

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
