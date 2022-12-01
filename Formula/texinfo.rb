class Texinfo < Formula
  desc "Official documentation format of the GNU project"
  homepage "https://www.gnu.org/software/texinfo/"
  url "https://ftp.gnu.org/gnu/texinfo/texinfo-7.0.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/texinfo/texinfo-7.0.1.tar.xz"
  sha256 "bcd221fdb2d807a8a09938a0f8d5e010ebd2b58fca16075483d6fcb78db2c6b2"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_ventura:  "33acf9386cbeab7b708f5c8dd22de953ebe75282faf7fbe36825678396aaf816"
    sha256 arm64_monterey: "83e127cc706026b0279bb6891ff8649a3039e9340ed2c1a38e6fcfc17c2f490f"
    sha256 arm64_big_sur:  "e44ae3361202b0eb5cd28d7730e273b09469eea900eea6bc327ac3eccce339d2"
    sha256 ventura:        "0c515bf5c8badacf91147bc1b56a2c84b1b833b6e691dc338af092f47dea7f7d"
    sha256 monterey:       "d4f1550361dbff38ba9d7a63ae2e00cf90109929434cec52ca48418a13ebeba8"
    sha256 big_sur:        "fe5b705f97686161be9d985ca3dabdcc8692df85ed3ff2aa3583c7ce20fec1a4"
    sha256 catalina:       "59505aedbf48a25fda2c71718168027a736bf0e954fe02eb1281910cdef82e3c"
    sha256 x86_64_linux:   "0f41d9f1b881faca105bd7516a2b4fb2f5940522fa1e2ba5aaf249a877c7c311"
  end

  uses_from_macos "ncurses"
  uses_from_macos "perl"

  # texinfo has been removed from macOS Ventura.
  on_monterey :or_older do
    keg_only :provided_by_macos
  end

  on_system :linux, macos: :high_sierra_or_older do
    depends_on "gettext"
  end

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
