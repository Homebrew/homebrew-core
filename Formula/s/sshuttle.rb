class Sshuttle < Formula
  include Language::Python::Virtualenv

  desc "Proxy server that works as a poor man's VPN"
  homepage "https://github.com/sshuttle/sshuttle"
  url "https://files.pythonhosted.org/packages/94/6e/f9a1fb50cd034cac1ee4efd017a9873301f75103271205a8f1c411a9fb1e/sshuttle-1.1.2.tar.gz"
  sha256 "f1f82bc59c45745df7543f38b0fa0f1a6a34d8a9e17dd8d9e5e259f069c763d6"
  license "LGPL-2.1-or-later"
  head "https://github.com/sshuttle/sshuttle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ae0a3b39536919ccdf473bb80b79258c7d0641966f74a87acefa65992d762791"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cba6bfc80686df1e1f370710691d7e0070120798cc25a3427eb44f311909fac6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ecea47bc1b5b47ac0085159e39d539059a9b8898e1c58fcf957fc25ffb456cc"
    sha256 cellar: :any_skip_relocation, sonoma:         "f6d3222e10b9143e826a49aeefc50574ec18ff661c652eadf7b83d4864ff5c9c"
    sha256 cellar: :any_skip_relocation, ventura:        "bfc78d99dcec5c2db983a7b29dc7fc3464823cf86c9f948bf9add856d983e168"
    sha256 cellar: :any_skip_relocation, monterey:       "6902892747688175efadebd273c346c3018cfea6cab362e7ef0a9efad08e7571"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5169accb3329a9853603e421ad9594d045f9b09bc11188b8a59f84b48215d35c"
  end

  depends_on "python@3.12"

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
