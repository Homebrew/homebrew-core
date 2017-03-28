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
    sha256 "c4c4e68b8082833ac655f8a7188ccd3293242ca487393b6c0d23d2438e6d913e" => :sierra
    sha256 "79b6dd2488c08d8cd967246dd896f23182bdd11b62b8c24d0b5303b0e1fdb6bc" => :el_capitan
    sha256 "79a369c74f776477df991ee0c022cb16ddba18bed3d0da6082fec72e271735a7" => :yosemite
  end

  depends_on "libtool" => :build
  depends_on "coreutils" => :build # GNU install

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
