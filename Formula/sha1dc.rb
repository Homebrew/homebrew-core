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

    system "make", "PREFIX=#{prefix}", "install"
    (pkgshare/"test").install Dir["test/*"]

  end

  test do
    # Build system's 'make' ran 'make test'
    system "#{bin}/sha1dcsum"
  end
end
