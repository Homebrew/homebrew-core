class Unrar < Formula
  desc "Extract, view, and test RAR archives"
  homepage "https://www.rarlab.com/"
  url "https://www.rarlab.com/rar/unrarsrc-5.8.1.tar.gz"
  sha256 "035f1f436f0dc2aea09aec146b9cc3e47ca2442f2c62b4ad9374c7c9cc20e632"

  bottle do
    cellar :any
    sha256 "9a911dbc68cc41ba3e74130101f8d04bb8c8aca91a667c5e16e867e73213e7c3" => :catalina
    sha256 "1f1d54b2e35a4af3ca819d432670a6e84abc54d9da19aff0aef2aa5b4717ab67" => :mojave
    sha256 "de7518a4d6465f000862af26c93ded6c699311045f5568965ff255bc6e8bef97" => :high_sierra
    sha256 "6c848f3f5667c610f9add058c5945a7109768fdc9f2caeaabdfa5340fde1d6ef" => :sierra
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
