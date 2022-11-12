class Vermin < Formula
  include Language::Python::Virtualenv

  desc "Concurrently detect the minimum Python versions needed to run code"
  homepage "https://github.com/netromdk/vermin"
  url "https://github.com/netromdk/vermin/archive/v1.5.1.tar.gz"
  sha256 "2d1c7601d054da9fa5c5eb6c817c714235f9d484b74011f7f86c98f0a25e93ea"
  license "MIT"
  head "https://github.com/netromdk/vermin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9bdba06b0268e163dbc6ee04273ce0fae645ed40b4bd573ecf8db888a9e70e55"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9bdba06b0268e163dbc6ee04273ce0fae645ed40b4bd573ecf8db888a9e70e55"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9bdba06b0268e163dbc6ee04273ce0fae645ed40b4bd573ecf8db888a9e70e55"
    sha256 cellar: :any_skip_relocation, monterey:       "8c9911824d09800d5da7295be4a56dd084c9fb8f34908c68c9aecb634a922637"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c9911824d09800d5da7295be4a56dd084c9fb8f34908c68c9aecb634a922637"
    sha256 cellar: :any_skip_relocation, catalina:       "8c9911824d09800d5da7295be4a56dd084c9fb8f34908c68c9aecb634a922637"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68ee6fd04cef3fe6ddf3a603c06169e289288963420c6dec1373bdfced582962"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    path = libexec/Language::Python.site_packages("python3.11")/"vermin"
    assert_match "Minimum required versions: 2.7, 3.0", shell_output("#{bin}/vermin #{path}")
  end
end
