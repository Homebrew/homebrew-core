class Vermin < Formula
  include Language::Python::Virtualenv

  desc "Concurrently detect the minimum Python versions needed to run code"
  homepage "https://github.com/netromdk/vermin"
  url "https://github.com/netromdk/vermin/archive/v1.5.1.tar.gz"
  sha256 "2d1c7601d054da9fa5c5eb6c817c714235f9d484b74011f7f86c98f0a25e93ea"
  license "MIT"
  head "https://github.com/netromdk/vermin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32a1245cb6854bc8fc762674d5df6db54f2e667c65f240f4f2a9377472f4b315"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32a1245cb6854bc8fc762674d5df6db54f2e667c65f240f4f2a9377472f4b315"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "32a1245cb6854bc8fc762674d5df6db54f2e667c65f240f4f2a9377472f4b315"
    sha256 cellar: :any_skip_relocation, ventura:        "18b4b98c45bc7cd0d574368764fd68f052ea7ff768ed14f39079ef11310a8d5a"
    sha256 cellar: :any_skip_relocation, monterey:       "18b4b98c45bc7cd0d574368764fd68f052ea7ff768ed14f39079ef11310a8d5a"
    sha256 cellar: :any_skip_relocation, big_sur:        "18b4b98c45bc7cd0d574368764fd68f052ea7ff768ed14f39079ef11310a8d5a"
    sha256 cellar: :any_skip_relocation, catalina:       "18b4b98c45bc7cd0d574368764fd68f052ea7ff768ed14f39079ef11310a8d5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97edc1e04378aab27f23a0a0f51ddafd8d10b2d1a623516eccc678db5ba7a7ab"
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
