class Sshuttle < Formula
  include Language::Python::Virtualenv

  desc "Proxy server that works as a poor man's VPN"
  homepage "https://github.com/sshuttle/sshuttle"
  url "https://files.pythonhosted.org/packages/f1/4d/91c8bff8fabe44cd88edce0b18e874e60f1e11d4e9d37c254f2671e1a3d4/sshuttle-1.1.1.tar.gz"
  sha256 "f5a3ed1e5ab1213c7a6df860af41f1a903ab2cafbfef71f371acdcff21e69ee6"
  license "LGPL-2.1-or-later"
  head "https://github.com/sshuttle/sshuttle.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "90c2823e56ebaeb8b25636b88c882d9345d04e55af0d83269a09a952c459e111"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90c2823e56ebaeb8b25636b88c882d9345d04e55af0d83269a09a952c459e111"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "90c2823e56ebaeb8b25636b88c882d9345d04e55af0d83269a09a952c459e111"
    sha256 cellar: :any_skip_relocation, ventura:        "180b62b05fd0d2134dc57648bd830cd52ccb2cf169ccfd7f8224c58dd7597b22"
    sha256 cellar: :any_skip_relocation, monterey:       "180b62b05fd0d2134dc57648bd830cd52ccb2cf169ccfd7f8224c58dd7597b22"
    sha256 cellar: :any_skip_relocation, big_sur:        "180b62b05fd0d2134dc57648bd830cd52ccb2cf169ccfd7f8224c58dd7597b22"
    sha256 cellar: :any_skip_relocation, catalina:       "180b62b05fd0d2134dc57648bd830cd52ccb2cf169ccfd7f8224c58dd7597b22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89386b334888a8effeca3997f8910b1a4543ca37cae33a50d80f047b4b65576e"
  end

  depends_on "python@3.11"

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
