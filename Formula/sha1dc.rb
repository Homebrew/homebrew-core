class Sha1dc < Formula
  desc "Tool to detect SHA-1 collisions in files, including SHAttered"
  homepage "https://github.com/cr-marcstevens/sha1collisiondetection"
  url "https://github.com/cr-marcstevens/sha1collisiondetection.git",
      :revision => "cb10f50d20a1c6c9efbf526c5da510c492d595b9"
  version "HEAD-cb10f0"
  head "https://github.com/cr-marcstevens/sha1collisiondetection.git"

  depends_on "libtool" => :build

  def install
    inreplace "Makefile", "libtool", "glibtool"

    # By default tries to build with HAVEAVX=1, fails.
    inreplace "Makefile", "HAVEAVX=1", "HAVEAVX=0"
    system "make"

    bin.install "bin/sha1dcsum"
    bin.install "bin/sha1dcsum_partialcoll"
    lib.install "bin/.libs/libdetectcoll.a"
  end

  test do
    # Build system's 'make' ran 'make test'
    system "#{bin}/sha1dcsum"
  end
end
