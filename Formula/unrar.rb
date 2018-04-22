class Unrar < Formula
  desc "Extract, view, and test RAR archives"
  homepage "https://www.rarlab.com/"
  url "https://www.rarlab.com/rar/unrarsrc-5.6.3.tar.gz"
  sha256 "c590e70a745d840ae9b9f05ba6c449438838c8280d76ce796a26b3fcd0a1972e"

  bottle do
    cellar :any
    sha256 "e18d29ed9edc6c9e7e036f7b885451fca83cc093d7266d6d2fc6683f0ceb3217" => :high_sierra
    sha256 "ddff42e5cd21ce07eb3bdd871f8530422e2d468b5795d03cd4db5d04c056f064" => :sierra
    sha256 "b7561d8debd2b17a061f5e9ffb10362e669cb40d1974084f65402b8c0e0a5edc" => :el_capitan
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
