class Unrar < Formula
  desc "Extract, view, and test RAR archives"
  homepage "https://www.rarlab.com/"
  url "https://rarlab.com/rar/unrarsrc-5.8.3.tar.gz"
  sha256 "3591685c8f5bbcb0be09de3d0a0544adb88966b9cccb80986f6cd2b534fd91a6"

  bottle do
    cellar :any
    sha256 "3fd6a6baee897af91ab2265506a3f74698217dd15a5ddd34948e0dda42ebafa1" => :catalina
    sha256 "3ef4dcda53c304769e64a11a6aa587b5d9967594c75e78e3aa646c479356fc0c" => :mojave
    sha256 "52416842e45f140433c55960db3aec32ba465a41b1e73cc16f7d17d374632350" => :high_sierra
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
