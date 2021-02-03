class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/ab/47/d7e0a2fddd457cef11b0f144c4854751e820b2fdaff7671f4b3ef05f5f0e/translate-toolkit-3.3.1.tar.gz"
  sha256 "e0feec51e2031c80d92416e657b709deac63cc5b026979a153b9f8cd4629983c"
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
