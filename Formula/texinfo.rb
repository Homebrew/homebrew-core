class Texinfo < Formula
  desc "Official documentation format of the GNU project"
  homepage "https://www.gnu.org/software/texinfo/"
  url "https://ftp.gnu.org/gnu/texinfo/texinfo-6.8.tar.xz"
  mirror "https://ftpmirror.gnu.org/texinfo/texinfo-6.8.tar.xz"
  sha256 "8eb753ed28bca21f8f56c1a180362aed789229bd62fff58bf8368e9beb59fec4"
  license "GPL-3.0"

  bottle do
    sha256 arm64_big_sur: "8767f78e25929771eeb011b44247b0d864765094e707aeaff9b4783385ba05a8"
    sha256 big_sur:       "7332c7a1665fc64484fff626116928630d4ee21983f1e221bda360a4d590a396"
    sha256 catalina:      "0686381d97b0448c10d11eaba59722c029d17c8423c17ad524b76ec086790f44"
    sha256 mojave:        "419fccc89f850de008e954984c65eea9b7f82940178f7ee439e42c2c892a2e52"
    sha256 high_sierra:   "a634a1bd15d3d7735e4934fcf26bfa295ce17108912ae7451d2761c6d578de6a"
  end

  depends_on "gettext" if MacOS.version <= :high_sierra

  keg_only :provided_by_macos

  uses_from_macos "ncurses"
  uses_from_macos "perl"

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
