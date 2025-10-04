class Sha1dc < Formula
  desc "Tool to detect SHA-1 collisions in files, including SHAttered"
  homepage "https://github.com/cr-marcstevens/sha1collisiondetection"
  url "https://github.com/cr-marcstevens/sha1collisiondetection/archive/refs/tags/stable-v1.0.3.tar.gz"
  sha256 "77a1c2b2a4fbe4f78de288fa4831ca63938c3cb84a73a92c79f436238bd9ac07"
  license "MIT"

  # The "master" branch is unusably broken and behind the
  # "simplified_c90" branch that's the basis for release.
  head "https://github.com/cr-marcstevens/sha1collisiondetection.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "1c950f58012467621593e85886219563b034c7967bc8fb6d5af0b3f2be4bd2ca"
    sha256 cellar: :any,                 arm64_sequoia:  "5fe1a0a2661073a77af41918596aef1fda94c415dbed1a3e7b5a4ee7332aff1b"
    sha256 cellar: :any,                 arm64_sonoma:   "9a4352024715c628f177c0585164b8fabda1c4c266e16735f406353c8c2068ce"
    sha256 cellar: :any,                 arm64_ventura:  "dbfe38e4ad0344a2fe7df59871c2193c5000fa7d013ca6d7ac101d2ade9611f7"
    sha256 cellar: :any,                 arm64_monterey: "5b325daffed30000496e7377b980768998ec15ac1b4c481838b0eccdcfd44354"
    sha256 cellar: :any,                 arm64_big_sur:  "392a2173a9bf9a53f40edb2ef6c77a9d34ee567c9d18f405288b7b83e7fdc87b"
    sha256 cellar: :any,                 sonoma:         "278844956e65f88d768cc841e8c39059738bc406683b96ca92b9ba2871075f5f"
    sha256 cellar: :any,                 ventura:        "320528612c69085d4e283dba52d84dd5101fb2348ff15955a480c08cfe4f06d0"
    sha256 cellar: :any,                 monterey:       "8034c9dce92fc85c8f79c22f01becabacb0efed4cf40bf19ba750e8539ebed55"
    sha256 cellar: :any,                 big_sur:        "9f927c95f5b3838ba7c269a3376f52d5bc9ddea216f6cbf6d07e667fa6c1a829"
    sha256 cellar: :any,                 catalina:       "ed78939b30e385c3adeac725b9f2865d60b8c0e15e1ec75d1b6c90855dc14206"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "e70a02cce5e9c673cd751665e913a54e3db1e67530aa702b86c3452e5d45db90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "981db3d0b2fcf5e914e1506a746dfb2bd14d83a191f268d8cdf5cb57401c0475"
  end

  depends_on "coreutils" => :build # GNU install
  depends_on "libtool" => :build

  def install
    system "make", "INSTALL=ginstall", "PREFIX=#{prefix}", "install"
    (pkgshare/"test").install Dir["test/*"]
  end

  test do
    assert_match "*coll*", shell_output("#{bin}/sha1dcsum #{pkgshare}/test/shattered-1.pdf")
    assert_match "*coll*", shell_output("#{bin}/sha1dcsum #{pkgshare}/test/shattered-2.pdf")
    assert_match "*coll*", shell_output("#{bin}/sha1dcsum_partialcoll #{pkgshare}/test/sha1_reducedsha_coll.bin")
  end
end
