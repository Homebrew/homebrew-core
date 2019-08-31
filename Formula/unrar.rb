class Unrar < Formula
  desc "Extract, view, and test RAR archives"
  homepage "https://www.rarlab.com/"
  url "https://www.rarlab.com/rar/unrarsrc-5.8.1.tar.gz"
  sha256 "035f1f436f0dc2aea09aec146b9cc3e47ca2442f2c62b4ad9374c7c9cc20e632"

  bottle do
    cellar :any
    sha256 "8d30a945be9a3b5a668d3c558f40dd22d3ba1e4b44e3f3d3a1b004b594d66fbf" => :mojave
    sha256 "3d5b170619917ee01c311696c457eb1b75310cc13cbe5cc7fc57c37e17c31a44" => :high_sierra
    sha256 "497e8198704df625b13b9a820fdd13c49c1f8180d7f587a1e22fa98c39fc7d10" => :sierra
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
