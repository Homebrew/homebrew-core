class Texinfo < Formula
  desc "Official documentation format of the GNU project"
  homepage "https://www.gnu.org/software/texinfo/"
  url "https://ftp.gnu.org/gnu/texinfo/texinfo-6.7.tar.xz"
  mirror "https://ftpmirror.gnu.org/texinfo/texinfo-6.7.tar.xz"
  sha256 "988403c1542d15ad044600b909997ba3079b10e03224c61188117f3676b02caa"

  bottle do
    sha256 "0686381d97b0448c10d11eaba59722c029d17c8423c17ad524b76ec086790f44" => :catalina
    sha256 "419fccc89f850de008e954984c65eea9b7f82940178f7ee439e42c2c892a2e52" => :mojave
    sha256 "a634a1bd15d3d7735e4934fcf26bfa295ce17108912ae7451d2761c6d578de6a" => :high_sierra
  end

  depends_on "gettext" if MacOS.version <= :high_sierra

  keg_only :provided_by_macos, <<~EOS
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
    (testpath/"test.texinfo").write <<~EOS
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
