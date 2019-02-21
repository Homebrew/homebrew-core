class Unrar < Formula
  desc "Extract, view, and test RAR archives"
  homepage "https://www.rarlab.com/"
  url "https://www.rarlab.com/rar/unrarsrc-5.7.2.tar.gz"
  sha256 "46dd410ba57652e972a6c601e7500d01d0ca3257661577466c2cbf6f843cb13a"

  bottle do
    cellar :any
    sha256 "ef0c1d0d810b03ff0b60c00aefb441bf5363c47ccff0c7e9953a0626aa1371a3" => :mojave
    sha256 "f3ac040a97c7102491bc39948b0f561f07dbf576790cd00747cdee36b89c85b6" => :high_sierra
    sha256 "9de661e1cb1ca7cef58bb95758a7d0e802a82b008a69b6c15d01ed797a927abe" => :sierra
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
