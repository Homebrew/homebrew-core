class Sshuttle < Formula
  include Language::Python::Virtualenv

  desc "Proxy server that works as a poor man's VPN"
  homepage "https://github.com/sshuttle/sshuttle"
  url "https://files.pythonhosted.org/packages/e9/4b/51d6aaa900a6a13efb380b0a084a327c41aad28a267d4c1f074cb2e41baa/sshuttle-1.0.5.tar.gz"
  sha256 "fd8c691aac2cb80933aae7f94d9d9e271a820efc5c48e73408f1a90da426a1bd"
  license "LGPL-2.1-or-later"
  head "https://github.com/sshuttle/sshuttle.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "c9e76a2c946a5093591707b85b66c8201b693af597f79534d14d2e6101e20cff" => :big_sur
    sha256 "d567ae9a98102b13d91ee38945352677712db52539892713315ad0b1c5a3649a" => :arm64_big_sur
    sha256 "b80986476eb84c3cded3910bb7ef5210407cadf6716b277e8d3341c9413be7a8" => :catalina
    sha256 "5f3e98db1083312557436f54752aa0eb0d300dadb66a73cecb228b892578617c" => :mojave
  end

  depends_on "python@3.9"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/e1/b0/7276de53321c12981717490516b7e612364f2cb372ee8901bd4a66a000d7/psutil-5.8.0.tar.gz"
    sha256 "0c9ccb99ab76025f2f0bbecf341d4656e9c1351db8cc8a03ccd62e318ab4b5c6"
  end

  def install
    # Building the docs requires installing
    # markdown & BeautifulSoup Python modules
    # so we don't.
    virtualenv_install_with_resources
  end

  test do
    system bin/"sshuttle", "-h"
  end
end
