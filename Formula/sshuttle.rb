class Sshuttle < Formula
  include Language::Python::Virtualenv

  desc "Proxy server that works as a poor man's VPN"
  homepage "https://github.com/sshuttle/sshuttle"
  url "https://files.pythonhosted.org/packages/ee/5d/8eb1de9ed90732309cc8c64256d2e35de3f269713d707e1074a37d794665/sshuttle-1.0.4.tar.gz"
  sha256 "21a11f3f0f710de92241d8ffca58bebb969f689f650d59e97ba366d7407e16e5"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/sshuttle/sshuttle.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "465a87922822f59c5e3cbc014a2eb15e3dde2fa30064db8ec8eda3752fe58be1" => :big_sur
    sha256 "53647c69a4285465b4e8b51c474a9f8cf2f53091d30bafbca66b092713ef8a33" => :arm64_big_sur
    sha256 "41b9c52318318597e31403c66bc1fff91fd3da97047e6d82344f406118d06d17" => :catalina
    sha256 "5ee6b7d0f0afdd178a769213c1da1c1caea53228e8a21dcd4571b7fcc643deef" => :mojave
    sha256 "ddc86c2b17f9b3caedd813a8f2d11b9154637f5783b73a031276aef78909b1c1" => :high_sierra
  end

  depends_on "python@3.9"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/3e/d18f2c04cf2b528e18515999b0c8e698c136db78f62df34eee89cee205f1/psutil-5.7.2.tar.gz"
    sha256 "90990af1c3c67195c44c9a889184f84f5b2320dce3ee3acbd054e3ba0b4a7beb"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/3e/d18f2c04cf2b528e18515999b0c8e698c136db78f62df34eee89cee205f1/psutil-5.7.2.tar.gz"
    sha256 "90990af1c3c67195c44c9a889184f84f5b2320dce3ee3acbd054e3ba0b4a7beb"
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
