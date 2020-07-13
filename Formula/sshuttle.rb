class Sshuttle < Formula
  include Language::Python::Virtualenv

  desc "Proxy server that works as a poor man's VPN"
  homepage "https://github.com/sshuttle/sshuttle"
  url "https://github.com/sshuttle/sshuttle.git",
      :tag      => "v1.0.3",
      :revision => "c5dcc918db666dfd1b30afc72cc198abfb3b3aa9"
  head "https://github.com/sshuttle/sshuttle.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4ed29a3e61c9b1faa65f336e9942f200a53b22dd8c0690da411c80c8817f02c9" => :catalina
    sha256 "7d95976338b60398fa655967997e5ca3731d1af20f3f1fc7d41aef7143ccbca9" => :mojave
    sha256 "6bb0dd8552477a173c6015ec75b2a05ccd3806500546bb490ea9d26e51a06d5e" => :high_sierra
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
