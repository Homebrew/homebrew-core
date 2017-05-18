class Unrar < Formula
  desc "Extract, view, and test RAR archives"
  homepage "http://www.rarlab.com"
  url "http://www.rarlab.com/rar/unrarsrc-5.5.3.tar.gz"
  sha256 "d1d9ef4a9247db088f825666de8f8bb69006d8d8b0e004ff366b3e04c103a2b3"

  bottle do
    cellar :any
    sha256 "4f4dc2cec588ab76bc09c41ce70f14edadea9973c8d355a9a309e5a4c9992b54" => :sierra
    sha256 "eb0ae9f689c8f4018160129ca11fbfb8c8f87aa3cd99d790dfa44b70a536a1d7" => :el_capitan
    sha256 "ee98c32d1856c375c21ad4bd43c3e52e6751209152927e7603a93ec2900ca299" => :yosemite
  end

  def install
    # upstream doesn't particularly care about their unix targets,
    # so we do the dirty work of renaming their shared objects to
    # dylibs for them.
    inreplace "makefile", "libunrar.so", "libunrar.dylib"

    system "make"
    # Explicitly clean up for the library build to avoid an issue with an
    # apparent implicit clean which confuses the dependencies.
    system "make", "clean"
    system "make", "lib"

    bin.install "unrar"
    lib.install "libunrar.dylib"
  end

  test do
    contentpath = "directory/file.txt"
    rarpath = testpath/"archive.rar"
    data =  "UmFyIRoHAM+QcwAADQAAAAAAAACaCHQggDIACQAAAAkAAAADtPej1LZwZE" \
            "QUMBIApIEAAGRpcmVjdG9yeVxmaWxlLnR4dEhvbWVicmV3CsQ9ewBABwA="

    rarpath.write data.unpack("m").first
    assert_equal contentpath, `#{bin}/unrar lb #{rarpath}`.strip
    assert_equal 0, $?.exitstatus

    system "#{bin}/unrar", "x", rarpath, testpath
    assert_equal "Homebrew\n", (testpath/contentpath).read
  end
end
