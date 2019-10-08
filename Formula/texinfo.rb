class Texinfo < Formula
  desc "Official documentation format of the GNU project"
  homepage "https://www.gnu.org/software/texinfo/"
  url "https://ftp.gnu.org/gnu/texinfo/texinfo-6.6.tar.xz"
  mirror "https://ftpmirror.gnu.org/texinfo/texinfo-6.6.tar.xz"
  sha256 "9bb9ca00da53f26a7e5725eee49689cd4a1e18d25d5b061ac8b2053018d93d66"

  bottle do
    sha256 "3b73960b196abf2328e7efdd49c2b327ba883ca2661d63b96c5d2928200e2c69" => :catalina
    sha256 "2ea78114fc2f1bedb52a8cc4148c7ab48cbfe15bb2347783fb7f84998247ccc3" => :mojave
    sha256 "0181ad9121222a096857230faa80ed6b706a03eec49a5b9359694c0b8587db73" => :high_sierra
    sha256 "00f00f4d5ab3a6ba46d90264df0c8e0117cb14e30398ca574b0b53b95226e687" => :sierra
  end

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
