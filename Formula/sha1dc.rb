class Sha1dc < Formula
  desc "Tool to detect SHA-1 collisions in files, including SHAttered"
  homepage "https://github.com/cr-marcstevens/sha1collisiondetection"

  # The "master" branch is unusably broken and behind the "simplified_c90" branch
  # that's the basis for release.
  head "https://github.com/cr-marcstevens/sha1collisiondetection.git",
       :using => :git,
       :branch => "simplified_c90"

  devel do
    url "https://github.com/cr-marcstevens/sha1collisiondetection/archive/development-v1.0.1.tar.gz"
    sha256 "a414aad7ab1da30193d053ad31651d39a449c2f9f74eac777e467929d0de3c93"
    version "dev-v1.0.1"
  end

  depends_on "libtool" => :build
  depends_on "coreutils" => :build

  def install
    # Workaround a poor Makefile choice that prevents cmdline override of INSTALL
    inreplace "Makefile", "INSTALL ?= install", "INSTALL ?= ginstall"

    ENV.deparallelize

    system "make", "LIBTOOL=glibtool"
    system "make", "LIBTOOL=glibtool", "PREFIX=#{prefix}", "install"
    (pkgshare/"test").install Dir["test/*"]
  end

  test do
    system "#{bin}/sha1dcsum #{pkgshare}/test/shattered-1.pdf | fgrep -q '*coll*'"
    system "#{bin}/sha1dcsum #{pkgshare}/test/shattered-2.pdf | fgrep -q '*coll*'"
    system "#{bin}/sha1dcsum_partialcoll #{pkgshare}/test/sha1_reducedsha_coll.bin | fgrep -q '*coll*'"
  end
end
