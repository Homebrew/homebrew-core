class RbenvGemset < Formula
  desc "Adds basic gemset support to rbenv"
  homepage "https://github.com/jf/rbenv-gemset"
  url "https://github.com/jf/rbenv-gemset/archive/v0.5.9.tar.gz"
  sha256 "856aa45ce1e9ac56d476667e2ca58f5f312600879fec4243073edc88a41954da"
  license :public_domain
  revision 1
  head "https://github.com/jf/rbenv-gemset.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "941ed7ed6ef3832ff33b7e042de26e099c122b95e091f92168ce48682ac4f213"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "57bcf5e57436cf4a85a595127c09b591f6a971b132e900ab12d29aae2d00f767"
    sha256 cellar: :any_skip_relocation, monterey:       "7eee4cfd9c81478ddba36988a711c88b8085f11bdc77f0ec6fa81a14871593ef"
    sha256 cellar: :any_skip_relocation, big_sur:        "002920ce6ab3bf97133b5e771c03a7a5c62f2a7af2175a807a899f0ebe932149"
    sha256 cellar: :any_skip_relocation, catalina:       "002920ce6ab3bf97133b5e771c03a7a5c62f2a7af2175a807a899f0ebe932149"
    sha256 cellar: :any_skip_relocation, mojave:         "002920ce6ab3bf97133b5e771c03a7a5c62f2a7af2175a807a899f0ebe932149"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e657abdbd0efb87bf83a2d59c7ae74218bd9e475be21de61004ac7648c74750"
  end

  depends_on "rbenv"

  def install
    prefix.install Dir["*"]
  end

  test do
    assert_match "gemset.bash", shell_output("rbenv hooks exec")
  end
end
