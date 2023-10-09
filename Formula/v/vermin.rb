class Vermin < Formula
  include Language::Python::Virtualenv

  desc "Concurrently detect the minimum Python versions needed to run code"
  homepage "https://github.com/netromdk/vermin"
  url "https://github.com/netromdk/vermin/archive/v1.5.2.tar.gz"
  sha256 "e4b6ca6f3e71b0d83a179dc4a4ba50682f60474cf8c948ba9f82e330f219ff4a"
  license "MIT"
  head "https://github.com/netromdk/vermin.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "81e03a3f0e63e4bbf8870a4b578f03eb105a6c5fc9f3efa298dd50a00bef28a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef58e826873d62bdf930acd1a218bf36b10667c34362848a5a615147d96bdba4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e7b6e5bbc3bda36c59555f2e0a273d1369e26b7420844c7b810a5e63341e9eb"
    sha256 cellar: :any_skip_relocation, sonoma:         "19f5ecc81dd07653ee54d9d66d214551e6d9f362bc50d5ce898039a693be246b"
    sha256 cellar: :any_skip_relocation, ventura:        "5cfac74609d01ef7335ac5b4943ec64381ee0bbab3cd881aa8b260f325d434ac"
    sha256 cellar: :any_skip_relocation, monterey:       "a5683b5b1ae418468d15588bbee7e8a532a936d3a88e4471c423fff44c59ec92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9eee3a7b11728ea390cccf0afc1df7e34a47bdad40c8640a6d6c091b67f05b97"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    path = libexec/Language::Python.site_packages("python3.12")/"vermin"
    assert_match "Minimum required versions: 2.7, 3.0", shell_output("#{bin}/vermin #{path}")
  end
end
