class Sshuttle < Formula
  include Language::Python::Virtualenv

  desc "Proxy server that works as a poor man's VPN"
  homepage "https://github.com/sshuttle/sshuttle"
  url "https://github.com/sshuttle/sshuttle.git",
      :tag      => "v0.78.5",
      :revision => "752a95310198886515577463a4a7e36d7f218018"
  head "https://github.com/sshuttle/sshuttle.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "107aecff3f7504b0eab9d370aca884bc13f24df4ff6b55a2b8e4d8664ba985a2" => :catalina
    sha256 "dff7259d647fd392e53de03660ece7be96452882938f387c199938f8054f4c2b" => :mojave
    sha256 "28f3d7fc8858779cb6020908302fb185810d574e8023e935b8410d0660973d49" => :high_sierra
    sha256 "04e8f60acb5131f58a0fbe66d7c8d847c4d423db3edb2671ff1319fc499a2c5f" => :sierra
  end

  depends_on "python"

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
