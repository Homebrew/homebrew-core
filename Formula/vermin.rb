class Vermin < Formula
  include Language::Python::Virtualenv

  desc "Concurrently detect the minimum Python versions needed to run code"
  homepage "https://github.com/netromdk/vermin"
  url "https://github.com/netromdk/vermin/archive/v1.4.1.tar.gz"
  sha256 "ee69d5e84f0d446e0d6574ec60c428798de6e6c8d055589f65ac02f074a7da25"
  license "MIT"
  head "https://github.com/netromdk/vermin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da21abb658da7cd0933a3a8e4707f55f1e98be0779a0a079bc953878ea3f1ad9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da21abb658da7cd0933a3a8e4707f55f1e98be0779a0a079bc953878ea3f1ad9"
    sha256 cellar: :any_skip_relocation, monterey:       "e6342067906c2748f93a63baf1ecfbdd7f65a4140875f333ba456dcb03d19fad"
    sha256 cellar: :any_skip_relocation, big_sur:        "e6342067906c2748f93a63baf1ecfbdd7f65a4140875f333ba456dcb03d19fad"
    sha256 cellar: :any_skip_relocation, catalina:       "e6342067906c2748f93a63baf1ecfbdd7f65a4140875f333ba456dcb03d19fad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bbf39bf561a03de3412452d1e61c2a756bbf87c0d3e0c5bbeca67b39d302e50"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    path = libexec/"lib/python3.10/site-packages/vermin"
    assert_match "Minimum required versions: 2.7, 3.0", shell_output("#{bin}/vermin #{path}")
  end
end
