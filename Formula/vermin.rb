class Vermin < Formula
  include Language::Python::Virtualenv

  desc "Concurrently detect the minimum Python versions needed to run code"
  homepage "https://github.com/netromdk/vermin"
  url "https://github.com/netromdk/vermin/archive/v1.4.0.tar.gz"
  sha256 "984773ed6af60329e700b39c58b7584032acbc908a00b5a76d1ce5468c825c70"
  license "MIT"
  head "https://github.com/netromdk/vermin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "979e49dcf59072276cf1f26ef959b72285a34dbf50be7fd9b3d1a17691ba7782"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "979e49dcf59072276cf1f26ef959b72285a34dbf50be7fd9b3d1a17691ba7782"
    sha256 cellar: :any_skip_relocation, monterey:       "b161ec94326e573a7b96c5cc887ea932d17a1b4b3a501ba9f0522873ac997903"
    sha256 cellar: :any_skip_relocation, big_sur:        "b161ec94326e573a7b96c5cc887ea932d17a1b4b3a501ba9f0522873ac997903"
    sha256 cellar: :any_skip_relocation, catalina:       "b161ec94326e573a7b96c5cc887ea932d17a1b4b3a501ba9f0522873ac997903"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1dddfe95d6b2572b6b3e354219b638dea36d7d03a80740c51cf315510fcaa4af"
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
