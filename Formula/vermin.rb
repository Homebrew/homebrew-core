class Vermin < Formula
  include Language::Python::Virtualenv

  desc "Concurrently detect the minimum Python versions needed to run code"
  homepage "https://github.com/netromdk/vermin"
  url "https://github.com/netromdk/vermin/archive/v1.5.2.tar.gz"
  sha256 "e4b6ca6f3e71b0d83a179dc4a4ba50682f60474cf8c948ba9f82e330f219ff4a"
  license "MIT"
  head "https://github.com/netromdk/vermin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2500d85571abe6515b1932b207bce6fa4ec3b72eec84ba8126695d90508b5eb5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2500d85571abe6515b1932b207bce6fa4ec3b72eec84ba8126695d90508b5eb5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2500d85571abe6515b1932b207bce6fa4ec3b72eec84ba8126695d90508b5eb5"
    sha256 cellar: :any_skip_relocation, ventura:        "48e59e6f917d3487ba7c61e8b011d0b37eb19df62eb3645f53f3b51181b8398c"
    sha256 cellar: :any_skip_relocation, monterey:       "48e59e6f917d3487ba7c61e8b011d0b37eb19df62eb3645f53f3b51181b8398c"
    sha256 cellar: :any_skip_relocation, big_sur:        "48e59e6f917d3487ba7c61e8b011d0b37eb19df62eb3645f53f3b51181b8398c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8453b63b554fc3c1da3b0a44f49b3e54458e48e545b39662413e3ae1a2fa5e6f"
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
