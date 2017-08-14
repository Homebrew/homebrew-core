class Unrar < Formula
  desc "Extract, view, and test RAR archives"
  homepage "http://www.rarlab.com"
  url "http://www.rarlab.com/rar/unrarsrc-5.5.8.tar.gz"
  sha256 "9b66e4353a9944bc140eb2a919ff99482dd548f858f5e296d809e8f7cdb2fcf4"

  bottle do
    cellar :any
    sha256 "80f33039a1353888351eedbf33d18a334e69c3fa885f17bfb3b5a050d9d7bb2b" => :sierra
    sha256 "c5d2404d0cff8e506ee7cc614fae635dce149be55e1fcb36bff537839c0d4a42" => :el_capitan
    sha256 "8ad71ebe5f4c6c7853ce6a06ecb69d39885d48a743a5fd2b451de2ed23a5c8af" => :yosemite
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
    assert_equal 0, $CHILD_STATUS.exitstatus

    system "#{bin}/unrar", "x", rarpath, testpath
    assert_equal "Homebrew\n", (testpath/contentpath).read
  end
end
