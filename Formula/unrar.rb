class Unrar < Formula
  desc "Extract, view, and test RAR archives"
  homepage "https://www.rarlab.com/"
  url "https://www.rarlab.com/rar/unrarsrc-5.6.6.tar.gz"
  sha256 "5dbdd3cff955c4bc54dd50bf58120af7cb30dec0763a79ffff350f26f96c4430"

  bottle do
    cellar :any
    sha256 "7650add99c8cb709a738401dd1ab893229c213be5ff2c1f299ae3488d1042f82" => :mojave
    sha256 "9b8a1d5a562965087ec151574c952f03d80e8801193e0c5df1a8af31df56e975" => :high_sierra
    sha256 "fdb899e76e74ea3250b0f03c01e926695a97f70a182758bc56ebacbc96e2c4f9" => :sierra
    sha256 "f331f00688a2ca9efb672cf89948cd9dd9f22b1e3851804844db9423952887ee" => :el_capitan
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
