class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/3b/8e/ff64fa52bb085310f9f6534ba09a5833db93ca5c228f8c2b246ff4cd36d4/translate-toolkit-3.3.2.tar.gz"
  sha256 "0795bd3c8668213199550ae4ed8938874083139ec1f8c473dcca1524a206b108"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "09c6090129d3d27db017e00c11df44cce6e1c4c8143274997995fe58346be85f"
    sha256 cellar: :any_skip_relocation, big_sur:       "ce3f37e2d6b801ed65ac7eb74aa52d646e7df48343766240d49539d38d47f952"
    sha256 cellar: :any_skip_relocation, catalina:      "90b90e2a9cec920135e6d3211ab078df0bd576a1dc821b244cd65f31e2d8891e"
    sha256 cellar: :any_skip_relocation, mojave:        "0ebd287bc19035a24805d37129eff3ce14061da83a88648e99a47d6d3505d19f"
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
