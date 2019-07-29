class Sha1dc < Formula
  desc "Tool to detect SHA-1 collisions in files, including SHAttered"
  homepage "https://github.com/cr-marcstevens/sha1collisiondetection"
  url "https://github.com/cr-marcstevens/sha1collisiondetection/archive/stable-v1.0.3.tar.gz"
  sha256 "77a1c2b2a4fbe4f78de288fa4831ca63938c3cb84a73a92c79f436238bd9ac07"

  # The "master" branch is unusably broken and behind the
  # "simplified_c90" branch that's the basis for release.
  head "https://github.com/cr-marcstevens/sha1collisiondetection.git"

  bottle do
    cellar :any
    sha256 "1c12564c84282e1ddbac545864bd695527dca9026411725e4a4604eaed81ec8b" => :mojave
    sha256 "a489f11b91a88486274717eace83368f6b072b134ddc62001157b1fae9873dab" => :high_sierra
    sha256 "9eba4b19247672b715376e2086689e7418235d850a158636d2ba3deb46851933" => :sierra
    sha256 "32d59c039a26d232b35f3c1877ca8c78ba0a303866adefee002c017359b03267" => :el_capitan
    sha256 "939388a0fe029d8cba8080a778269322489c55f787301947c82fb30cf8433b08" => :yosemite
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
