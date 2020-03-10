class Sshuttle < Formula
  include Language::Python::Virtualenv

  desc "Proxy server that works as a poor man's VPN"
  homepage "https://github.com/sshuttle/sshuttle"
  url "https://github.com/sshuttle/sshuttle.git",
      :tag      => "v0.78.5",
      :revision => "752a95310198886515577463a4a7e36d7f218018"
  revision 2
  head "https://github.com/sshuttle/sshuttle.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "49be10db18c5b06daddb5d3000fc4a4d4914f85c00d451d5585c8125d62bc1fe" => :catalina
    sha256 "62634bac69ab54fd612e149785894aa3cd851124591f8bfa11c47d8ae7b2da46" => :mojave
    sha256 "9ffaac430d8dd88cd9c1177cb719fa0259e224fda293a5dde2790ccf87c95d71" => :high_sierra
  end

  depends_on "python@3.8"

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
