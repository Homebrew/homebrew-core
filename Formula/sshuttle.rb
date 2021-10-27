class Sshuttle < Formula
  include Language::Python::Virtualenv

  desc "Proxy server that works as a poor man's VPN"
  homepage "https://github.com/sshuttle/sshuttle"
  url "https://files.pythonhosted.org/packages/e9/4b/51d6aaa900a6a13efb380b0a084a327c41aad28a267d4c1f074cb2e41baa/sshuttle-1.0.5.tar.gz"
  sha256 "fd8c691aac2cb80933aae7f94d9d9e271a820efc5c48e73408f1a90da426a1bd"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/sshuttle/sshuttle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31fad7e2bdb6af7e4a3231d70a49aa5544c821c0ef2560fc27b045baa4c89e37"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b42243ff9ffd1eb0d6e4166ba785c906b481599cd2b2b9565d4904c910aa89ae"
    sha256 cellar: :any_skip_relocation, monterey:       "2e11c52c3367841e788003da4a0f339e207e9f6ece5d7eb5ba1552b54cdc476b"
    sha256 cellar: :any_skip_relocation, big_sur:        "4473c1b22e08070fa71beebecd01c9fdf5d396cf9b56907e6b1e27d32bceb389"
    sha256 cellar: :any_skip_relocation, catalina:       "f02f3c772af4b221b9469849c315be5c92abbc12f5024bdfc1bb03d12ed2fcac"
    sha256 cellar: :any_skip_relocation, mojave:         "21d7eff40bde6f0ad2f2003136d934e85867f5d6a5d7c7c669294cbdd378eb3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a49ae38bb94abe1487b2982a9058c7c2be134fedee80b9bcc58a6b3829d8135"
  end

  depends_on "python@3.10"

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
