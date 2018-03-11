class Unrar < Formula
  desc "Extract, view, and test RAR archives"
  homepage "https://www.rarlab.com/"
  url "https://www.rarlab.com/rar/unrarsrc-5.6.1.tar.gz"
  sha256 "67c339dffa95f6c1bedcca40045e99de5852919dbfaa06e4a9c8f18cd5064e70"

  bottle do
    cellar :any
    sha256 "ba87a2debd14ee02ebba3a2a9c687b0e64920651eab21d0ce305829cc02c1e1f" => :high_sierra
    sha256 "fb54a22a18eb4e992fa5bec6a669f97a764919a5b78dce65407b6943d2bf0ebe" => :sierra
    sha256 "82adba13791514beb06b9a7d659eb00a8c4f8057c5c9edd3df7ea8b085586372" => :el_capitan
    sha256 "5e50649d2b6c717b36447f08d3dc1ce2d72da02603c6274327a24900030b6f5f" => :yosemite
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
