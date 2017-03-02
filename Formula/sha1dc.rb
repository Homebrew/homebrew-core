class Sha1dc < Formula
  desc "Tool to detect SHA-1 collisions in files, including SHAttered"
  homepage "https://github.com/cr-marcstevens/sha1collisiondetection"
  url "https://github.com/cr-marcstevens/sha1collisiondetection.git",
      :revision => "6b1c12f3606d0959f8658d44a324fcf5f4497f88"
  version "HEAD-6b1c12"

  depends_on "libtool" => :build

  def install
    inreplace "Makefile", "libtool", "glibtool"

    ENV.deparallelize

    # By default tries to build with HAVEAVX=1, fails.
    system "make", "HAVEAVX=0"
    # Some bug in the Makefile...
    system "mkdir", "-p", "#{prefix}/bin", "#{prefix}/lib" 
    system "make", "HAVEAVX=0", "PREFIX=#{prefix}", "install"
    (pkgshare/"test").install Dir["test/*"]
  end

  test do
    system "#{bin}/sha1dcsum #{pkgshare}/test/shattered-1.pdf | fgrep -q '*coll*'"
    system "#{bin}/sha1dcsum #{pkgshare}/test/shattered-2.pdf | fgrep -q '*coll*'"
    system "#{bin}/sha1dcsum_partialcoll #{pkgshare}/test/sha1_reducedsha_coll.bin | fgrep -q '*coll*'"
  end
end
