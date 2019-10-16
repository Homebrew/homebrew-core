class Unrar < Formula
  desc "Extract, view, and test RAR archives"
  homepage "https://www.rarlab.com/"
  url "https://rarlab.com/rar/unrarsrc-5.8.2.tar.gz"
  sha256 "33386623fd3fb153b56292df4a6a69b457e69e1803b6d07b614e5fd22fb33dda"

  bottle do
    cellar :any
    sha256 "8d4b3f1ee68c019b675cc26a94c5a3bfbf5f64b86f3bea0e0a0ee974736f4def" => :catalina
    sha256 "ce1ddf06087a2fe440d8d28cb430d7f587bc43a1ad42d2d9a765e15123a99d38" => :mojave
    sha256 "44e47a4d9abc8c1cf1eb930aa2fcf6c18ad767ba09d879366c6f95e68bde678a" => :high_sierra
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
