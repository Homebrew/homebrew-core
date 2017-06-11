class Unrar < Formula
  desc "Extract, view, and test RAR archives"
  homepage "http://www.rarlab.com"
  url "http://www.rarlab.com/rar/unrarsrc-5.5.4.tar.gz"
  sha256 "278cc3ecdeb23290bab1ee654390fa9a6a8a5d586df81e3e034448fab2a972bc"

  bottle do
    cellar :any
    sha256 "401d808d3d81a9e9416edf373c3cc2488bb27a708b8b89b7d4c3ce29240fa567" => :sierra
    sha256 "ff5758b0d48110600df160d1f78c6486ed02ce52d195a13f16d7cc9f75e55953" => :el_capitan
    sha256 "529b9b1eb6f231cfd6468305d17384f2aea314591da6d5df9c3ee4d852861185" => :yosemite
  end

  def install
    # Fix "makefile:132: *** missing separator."
    # Reported to dev AT rarlab.com 11 Jun 2017
    inreplace "makefile", "  ", "\t"

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
    assert_equal 0, $?.exitstatus

    system "#{bin}/unrar", "x", rarpath, testpath
    assert_equal "Homebrew\n", (testpath/contentpath).read
  end
end
