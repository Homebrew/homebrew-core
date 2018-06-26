class Unrar < Formula
  desc "Extract, view, and test RAR archives"
  homepage "https://www.rarlab.com/"
  url "https://www.rarlab.com/rar/unrarsrc-5.6.5.tar.gz"
  sha256 "eba36a421bf41491818dee9507d934064622bc0bd9db6bbb8422a4706f200898"

  bottle do
    cellar :any
    sha256 "6ed76c131d2be88fee4fab0b838dc203046379c38797c875b87b38808397eef0" => :high_sierra
    sha256 "05b71d60e374d78ff5a68a97d784c7bad899039d38ff9fb7863fa47350febd28" => :sierra
    sha256 "e7145bddaebe83d758911d6aa9493f78311a9a49d54f6501f9e060671ad54700" => :el_capitan
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
