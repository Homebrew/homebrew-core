class Sshuttle < Formula
  include Language::Python::Virtualenv

  desc "Proxy server that works as a poor man's VPN"
  homepage "https://github.com/sshuttle/sshuttle"
  url "https://files.pythonhosted.org/packages/ee/5d/8eb1de9ed90732309cc8c64256d2e35de3f269713d707e1074a37d794665/sshuttle-1.0.4.tar.gz"
  sha256 "21a11f3f0f710de92241d8ffca58bebb969f689f650d59e97ba366d7407e16e5"
  license "LGPL-2.1-or-later"
  revision 2
  head "https://github.com/sshuttle/sshuttle.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "fa77f74869c9185da2b49344915bdb4d2b6983a1782c41d8a1a9fedf8b601dea" => :big_sur
    sha256 "0a7693876ec8d147c9bbc302ecbf55aa3de2e36d0a88b3816eecfe7a8e7c7ae6" => :arm64_big_sur
    sha256 "4f5d464826fac3aa195ed93b99c35b21dc76400d691e9a36e449baed645f0be9" => :catalina
    sha256 "f1a764a8fb4a9240109b733358c10bb21cadda3fa008c929c8a95f2188aa6385" => :mojave
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
