class Vermin < Formula
  include Language::Python::Virtualenv

  desc "Concurrently detect the minimum Python versions needed to run code"
  homepage "https://github.com/netromdk/vermin"
  url "https://github.com/netromdk/vermin/archive/v1.4.2.tar.gz"
  sha256 "c9a69420b610bfb25d5a2abd7da6edf0ae4329481a857ef6c5d71f602ed5c63d"
  license "MIT"
  head "https://github.com/netromdk/vermin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0b072725c7837319e3a0136a4ee56610ff734d2e4b21cd113de011412bb9067"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c0b072725c7837319e3a0136a4ee56610ff734d2e4b21cd113de011412bb9067"
    sha256 cellar: :any_skip_relocation, monterey:       "b3010a816194fab5d82a519b82855a5a99e161355483c98361fc27b9bddd9f21"
    sha256 cellar: :any_skip_relocation, big_sur:        "b3010a816194fab5d82a519b82855a5a99e161355483c98361fc27b9bddd9f21"
    sha256 cellar: :any_skip_relocation, catalina:       "b3010a816194fab5d82a519b82855a5a99e161355483c98361fc27b9bddd9f21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42de1cb7e7aeca2c0e28a507212f4ed1984ad594ad5d118449151d3f50caa478"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    path = libexec/Language::Python.site_packages("python3.10")/"vermin"
    assert_match "Minimum required versions: 2.7, 3.0", shell_output("#{bin}/vermin #{path}")
  end
end
