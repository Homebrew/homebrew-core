class Texinfo < Formula
  desc "Official documentation format of the GNU project"
  homepage "https://www.gnu.org/software/texinfo/"
  url "https://ftp.gnu.org/gnu/texinfo/texinfo-6.4.tar.xz"
  mirror "https://ftpmirror.gnu.org/texinfo/texinfo-6.4.tar.xz"
  sha256 "6ae2e61d87c6310f9af7c6f2426bd0470f251d1a6deb61fba83a3b3baff32c3a"

  bottle do
    sha256 "bcd43bfb0b31234232ed4d4894a7ffb16b23384105bce519ee7e83a12b01ecb2" => :sierra
    sha256 "f078d51fc568e628efb932f30451e4886b208d12c591aac03bafcc545d2c709a" => :el_capitan
    sha256 "c85b9e3b8577e56160abca0b98c22e162e0f576ecc49253deca1363e6758a58d" => :yosemite
  end

  keg_only :provided_by_osx, <<-EOS.undent
    software that uses TeX, such as lilypond and octave, require a newer
    version of these files
  EOS

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-install-warnings",
                          "--prefix=#{prefix}"
    system "make", "install"
    doc.install Dir["doc/refcard/txirefcard*"]
  end

  test do
    (testpath/"test.texinfo").write <<-EOS.undent
      @ifnottex
      @node Top
      @top Hello World!
      @end ifnottex
      @bye
    EOS
    system "#{bin}/makeinfo", "test.texinfo"
    assert_match "Hello World!", File.read("test.info")
  end
end
