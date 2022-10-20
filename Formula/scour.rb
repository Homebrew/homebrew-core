class Scour < Formula
  include Language::Python::Virtualenv

  desc "SVG file scrubber"
  homepage "https://www.codedread.com/scour/"
  url "https://files.pythonhosted.org/packages/75/19/f519ef8aa2f379935a44212c5744e2b3a46173bf04e0110fb7f4af4028c9/scour-0.38.2.tar.gz"
  sha256 "6881ec26660c130c5ecd996ac6f6b03939dd574198f50773f2508b81a68e0daf"
  license "Apache-2.0"
  revision 1
  version_scheme 1
  head "https://github.com/scour-project/scour.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d226022631dfccfd24e33cf7d2a03a282e4aae9140360e39d5d6cfbf2ce42780"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d226022631dfccfd24e33cf7d2a03a282e4aae9140360e39d5d6cfbf2ce42780"
    sha256 cellar: :any_skip_relocation, monterey:       "293fee6eb7fbd1d4ba156ef42f3300fa41aacc92e06dc5b68b97997584ac178c"
    sha256 cellar: :any_skip_relocation, big_sur:        "293fee6eb7fbd1d4ba156ef42f3300fa41aacc92e06dc5b68b97997584ac178c"
    sha256 cellar: :any_skip_relocation, catalina:       "293fee6eb7fbd1d4ba156ef42f3300fa41aacc92e06dc5b68b97997584ac178c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3d0a179b3408e507960e4c0d092c6c686fa1928e391c42c93bc3ffb1cf53f93"
  end

  depends_on "python@3.10"
  depends_on "six"

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/scour", "-i", test_fixtures("test.svg"), "-o", "scrubbed.svg"
    assert_predicate testpath/"scrubbed.svg", :exist?
  end
end
