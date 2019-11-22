class Unrar < Formula
  desc "Extract, view, and test RAR archives"
  homepage "https://www.rarlab.com/"
  url "https://rarlab.com/rar/unrarsrc-5.8.4.tar.gz"
  sha256 "0b7cb2307ef7e65f631496376ce2fdf98b9b0f2136dc4467408ef63f3bf92f96"

  bottle do
    cellar :any
    sha256 "0cd15d4c8a60379e3eac65260a8fddc8c99ce650214c61b94de35502a17dc44e" => :catalina
    sha256 "cb33b0c6fa82e4d01483bcc7398bf4a7e15e1b6cd0eb78ae177965237d52eb9d" => :mojave
    sha256 "59b6e3808c99fbc8c6edca2f76c8e2b198a68ffda0a2c4e2f44328f89b049613" => :high_sierra
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
