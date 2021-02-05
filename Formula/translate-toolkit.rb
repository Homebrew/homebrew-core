class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/3b/8e/ff64fa52bb085310f9f6534ba09a5833db93ca5c228f8c2b246ff4cd36d4/translate-toolkit-3.3.2.tar.gz"
  sha256 "0795bd3c8668213199550ae4ed8938874083139ec1f8c473dcca1524a206b108"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f2871f790bb13c0edef8aedecc5d1d938005ed055a202b3e264a6b045303d609"
    sha256 cellar: :any_skip_relocation, big_sur:       "076a916a9198ca1e6d8918548326a595dfbb73f56ecb815952addc07addd3890"
    sha256 cellar: :any_skip_relocation, catalina:      "648c4b60b04630cb2dcd6434ba0d3385c61179bf08770064165d3f7d7508f149"
    sha256 cellar: :any_skip_relocation, mojave:        "40714dc2fbe0a73b3509b1f0e9be48638b0a1b685f4019522d01f75fb6c1221d"
  end

  depends_on "python@3.9"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/db/f7/43fecb94d66959c1e23aa53d6161231dca0e93ec500224cf31b3c4073e37/lxml-4.6.2.tar.gz"
    sha256 "cd11c7e8d21af997ee8079037fff88f16fda188a9776eb4b81c7e4c9c0a7d7fc"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"pretranslate", "-h"
    system bin/"podebug", "-h"
  end
end
