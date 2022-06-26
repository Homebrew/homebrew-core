class Zpaq < Formula
  desc "Incremental, journaling command-line archiver"
  homepage "http://mattmahoney.net/dc/zpaq.html"
  url "http://mattmahoney.net/dc/zpaq715.zip"
  version "7.15"
  sha256 "e85ec2529eb0ba22ceaeabd461e55357ef099b80f61c14f377b429ea3d49d418"
  license "Unlicense"
  revision 1
  head "https://github.com/zpaq/zpaq.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe862e92dd0fc348e0a93891fb863075443841d64aaee4ee5ac56b36ad49e3dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "743d0714aa93446980dbb496709e64415234c335c8399e55054d1f85ac6b074a"
    sha256 cellar: :any_skip_relocation, monterey:       "a0da31ebe030b392ea21c7d3339becb134b041b8e72ffd2e013e20630dbf2f5d"
    sha256 cellar: :any_skip_relocation, big_sur:        "2ca2aa378add42b28e3a4513e4176740e013ff9189b7d5d091c998c6ba8ec16f"
    sha256 cellar: :any_skip_relocation, catalina:       "6bedfd3bff1fa1e98b6a41eedf02aa1f7600943f9081624fb9811e69fd3d9ffa"
    sha256 cellar: :any_skip_relocation, mojave:         "6b9d7285117ab09ac91605b8d1b2b2d7b4c05874156968a398273a3d29254cc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fcee2715716cfdbac67ff81332d2cfc39eeae7ff286ff645c3740375b848e8ec"
  end

  resource "test" do
    url "http://mattmahoney.net/dc/calgarytest2.zpaq"
    sha256 "ad3b58c245b2a54136d3ff28be78c069b0272eb31f808bf82014134e5913cf7e"
  end

  def install
    # When building on non-Intel this is supposed to be manually uncommented
    # from the Makefile!  (It's also missing "-D" though)
    inreplace "Makefile", "# CPPFLAGS+=NOJIT", "CPPFLAGS+=-DNOJIT" unless Hardware::CPU.intel?
    system "make"
    system "make", "check"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    testpath.install resource("test")
    assert_match "all OK", shell_output("#{bin}/zpaq x calgarytest2.zpaq 2>&1")
  end
end
