class Sha1dc < Formula
  desc "Tool to detect SHA-1 collisions in files, including SHAttered"
  homepage "https://github.com/cr-marcstevens/sha1collisiondetection"
  url "https://github.com/cr-marcstevens/sha1collisiondetection/archive/stable-v1.0.3.tar.gz"
  sha256 "77a1c2b2a4fbe4f78de288fa4831ca63938c3cb84a73a92c79f436238bd9ac07"
  license "MIT"

  # The "master" branch is unusably broken and behind the
  # "simplified_c90" branch that's the basis for release.
  head "https://github.com/cr-marcstevens/sha1collisiondetection.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5b325daffed30000496e7377b980768998ec15ac1b4c481838b0eccdcfd44354"
    sha256 cellar: :any,                 arm64_big_sur:  "392a2173a9bf9a53f40edb2ef6c77a9d34ee567c9d18f405288b7b83e7fdc87b"
    sha256 cellar: :any,                 monterey:       "8034c9dce92fc85c8f79c22f01becabacb0efed4cf40bf19ba750e8539ebed55"
    sha256 cellar: :any,                 big_sur:        "9f927c95f5b3838ba7c269a3376f52d5bc9ddea216f6cbf6d07e667fa6c1a829"
    sha256 cellar: :any,                 catalina:       "ed78939b30e385c3adeac725b9f2865d60b8c0e15e1ec75d1b6c90855dc14206"
    sha256 cellar: :any,                 mojave:         "1c12564c84282e1ddbac545864bd695527dca9026411725e4a4604eaed81ec8b"
    sha256 cellar: :any,                 high_sierra:    "a489f11b91a88486274717eace83368f6b072b134ddc62001157b1fae9873dab"
    sha256 cellar: :any,                 sierra:         "9eba4b19247672b715376e2086689e7418235d850a158636d2ba3deb46851933"
    sha256 cellar: :any,                 el_capitan:     "32d59c039a26d232b35f3c1877ca8c78ba0a303866adefee002c017359b03267"
    sha256 cellar: :any,                 yosemite:       "939388a0fe029d8cba8080a778269322489c55f787301947c82fb30cf8433b08"
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
