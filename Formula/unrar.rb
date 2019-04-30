class Unrar < Formula
  desc "Extract, view, and test RAR archives"
  homepage "https://www.rarlab.com/"
  url "https://www.rarlab.com/rar/unrarsrc-5.7.5.tar.gz"
  sha256 "e1c2fddaa87a88b1535bfc10ca484f3c5af4e5a55fbb933f8819e26203bbe2ee"

  bottle do
    cellar :any
    sha256 "ff2420a1aa7a322a051f135cbff927d68c2070400bf3870eaf1cfc73a3514951" => :mojave
    sha256 "71ef0454f1a8254d6fdc486c2b9d6c677cdbc4f7f67f85ff4fb61a466ff02065" => :high_sierra
    sha256 "d3d00ee597c886c53cbe2b1ed075d80a62cfa243c524c8ba7f2a396cf68a2ea4" => :sierra
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
