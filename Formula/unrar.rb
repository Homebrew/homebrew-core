class Unrar < Formula
  desc "Extract, view, and test RAR archives"
  homepage "https://www.rarlab.com/"
  url "https://www.rarlab.com/rar/unrarsrc-5.9.1.tar.gz"
  sha256 "0eb1d1b8e02102fccae775a6d6b79336b69e2cf90e2045de92594dcfb58de100"

  bottle do
    cellar :any
    sha256 "778a5ef87bc4c4f0c76ad4c774451c2aa03692a7555780e07dd02fdd17e5d961" => :catalina
    sha256 "8f50cbc0555c19d451f85fbbaaf081586bf9f0bdf788f53c6041aacc7be2bf25" => :mojave
    sha256 "dd7813a21417cdc5741ca03dfb51bbcf104d1e7430c487aa82012c709d4c70e7" => :high_sierra
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

    rarpath.write data.unpack1("m")
    assert_equal contentpath, `#{bin}/unrar lb #{rarpath}`.strip
    assert_equal 0, $CHILD_STATUS.exitstatus

    system "#{bin}/unrar", "x", rarpath, testpath
    assert_equal "Homebrew\n", (testpath/contentpath).read
  end
end
