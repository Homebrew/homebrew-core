class Sshuttle < Formula
  include Language::Python::Virtualenv

  desc "Proxy server that works as a poor man's VPN"
  homepage "https://github.com/sshuttle/sshuttle"
  url "https://github.com/sshuttle/sshuttle.git",
      :tag => "v0.78.4",
      :revision => "6ec42adbf4fc7ed28e5f3c0a813779e61fa01b0f"
  head "https://github.com/sshuttle/sshuttle.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "41802e6f5d6a5ce100cd3ea5e76e2bef9067e14a8d83efde5dc79aaccb3d92de" => :mojave
    sha256 "f9fbc1a692fe6e7e633be34c8379763437901142676348e7c1fd1b9c90da6a10" => :high_sierra
    sha256 "e35af7e75eb90bc4deb67ea297a37343d9f56b4493aa0fec90438946e1baa880" => :sierra
    sha256 "a4dac5efa96e42dabf26c5569a1cc57d3a3caf2363d33a0027308278dc161fd1" => :el_capitan
  end

  depends_on "python@2"

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
