class Unrar < Formula
  desc "Extract, view, and test RAR archives"
  homepage "http://www.rarlab.com"
  url "http://www.rarlab.com/rar/unrarsrc-5.4.5.tar.gz"
  sha256 "e470c584332422893fb52e049f2cbd99e24dc6c6da971008b4e2ae4284f8796c"

  bottle do
    cellar :any
    sha256 "160c588885c324f705a335c8637e91c133f162d5ba5b8ed6626b79ba71c9ea63" => :sierra
    sha256 "40c06c3c954ca0729491335e289dfc2a112ac8df6c2ac20e527693183ce520ff" => :el_capitan
    sha256 "4c8325c8382d687ca64c55fa4c5cac3237491babe24f2abb580e36b87cc24c52" => :yosemite
    sha256 "360cd0f3ed5b8a57e8afb0860148ce1997f7f7328afa624d4848db87a509f2a0" => :mavericks
  end

  def install
    system "make"
    # Explicitly clean up for the library build to avoid an issue with an
    # apparent implicit clean which confuses the dependencies.
    system "make", "clean"
    system "make", "lib"

    bin.install "unrar"
    # Sent an email to dev@rarlab.com (18-Feb-2015) asking them to look into
    # the need for the explicit clean, and to change the make to generate a
    # dylib file on macOS
    lib.install "libunrar.so" => "libunrar.dylib"
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
