class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/ab/47/d7e0a2fddd457cef11b0f144c4854751e820b2fdaff7671f4b3ef05f5f0e/translate-toolkit-3.3.1.tar.gz"
  sha256 "e0feec51e2031c80d92416e657b709deac63cc5b026979a153b9f8cd4629983c"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2252b5c00295a305232b97f6012baf2cdbcbbde039f5070caa1218c3ece89bc4" => :big_sur
    sha256 "00452ca853d17c31029f3d992e0fad06a38fd529ffe77e391ea49edfd6bf4d19" => :arm64_big_sur
    sha256 "e4a0a4460589c926ad2c5645e19d379450daec1686536584e93296007e48450e" => :catalina
    sha256 "ca6fc0acb707f1fb6b963e7da797de6b57abaf655c3fa73e72dc3b2dc9ee5d41" => :mojave
  end

  depends_on "python@3.9"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/db/f7/43fecb94d66959c1e23aa53d6161231dca0e93ec500224cf31b3c4073e37/lxml-4.6.2.tar.gz"
    sha256 "cd11c7e8d21af997ee8079037fff88f16fda188a9776eb4b81c7e4c9c0a7d7fc"
  end

  resource "python-Levenshtein" do
    url "https://files.pythonhosted.org/packages/6b/ca/1a9d7115f233d929d4f25a4021795cd97cc89eeb82723ea98dd44390a530/python-Levenshtein-0.12.1.tar.gz"
    sha256 "554e273a88060d177e7b3c1e6ea9158dde11563bfae8f7f661f73f47e5ff0911"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"pretranslate", "-h"
    system bin/"podebug", "-h"
  end
end
