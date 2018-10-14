class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://github.com/translate/translate/releases/download/2.3.0/translate-toolkit-2.3.0.tar.gz"
  sha256 "763325a419fdf2d5429e24bad42f33bccca7eb58279f57ddd742c4c3ea794ccb"
  revision 1
  head "https://github.com/translate/translate.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5a4a516a3886641e194464f062f12ecd1731734838cadfb173e7775c441154f3" => :mojave
    sha256 "470b8cb77ab55519825824d8f4f94aebaab46e6ec88230b9242115c8cd369294" => :high_sierra
    sha256 "4f38a5cb7b5d69e409d71c03db009f8a03a9b2ae155ffe4913438f9718d3ef70" => :sierra
  end

  depends_on "python"

  resource "argparse" do
    url "https://files.pythonhosted.org/packages/18/dd/e617cfc3f6210ae183374cd9f6a26b20514bbb5a792af97949c5aacddf0f/argparse-1.4.0.tar.gz"
    sha256 "62b089a55be1d8949cd2bc7e0df0bddb9e028faefc8c32038cc84862aefdd6e4"
  end

  resource "diff-match-patch" do
    url "https://files.pythonhosted.org/packages/22/82/46eaeab04805b4fac17630b59f30c4f2c8860988bcefd730ff4f1992908b/diff-match-patch-20121119.tar.gz"
    sha256 "9dba5611fbf27893347349fd51cc1911cb403682a7163373adacc565d11e2e4c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"pretranslate", "-h"
  end
end
