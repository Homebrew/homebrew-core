class Unrar < Formula
  desc "Extract, view, and test RAR archives"
  homepage "http://www.rarlab.com"
  url "http://www.rarlab.com/rar/unrarsrc-5.5.4.tar.gz"
  sha256 "c8217d311c8b3fbbd00737721f8d43d2b306192e1e39d7a858dcb714b2853517"
  revision 1

  bottle do
    cellar :any
    sha256 "25e5f5576e23640e4fb0c0350e40ae4f5c6751f3fabaa5d7b7bd97b639fa176c" => :sierra
    sha256 "5ba08eeace79200be3dfe6e5aaddb0ae320e6bad124ea29f89a87fa613422cc2" => :el_capitan
    sha256 "1f05206d9a2c25f58e9a6d37a1ab470c8dc591921d37b256317a94802bd77d21" => :yosemite
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
    assert_equal 0, $?.exitstatus

    system "#{bin}/unrar", "x", rarpath, testpath
    assert_equal "Homebrew\n", (testpath/contentpath).read
  end
end
