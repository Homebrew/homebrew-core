class Texinfo < Formula
  desc "Official documentation format of the GNU project"
  homepage "https://www.gnu.org/software/texinfo/"
  url "http://ftpmirror.gnu.org/texinfo/texinfo-6.1.tar.xz"
  mirror "https://ftp.gnu.org/gnu/texinfo/texinfo-6.1.tar.xz"
  sha256 "ac68394ce21b2420ba7ed7cec65d84aacf308cc88e9bf4716fcfff88286883d2"

  bottle do
    sha256 "f2494484ec7313c1d30156d6b4939daa4848e271030875de3d59def35db03e50" => :el_capitan
    sha256 "b9f97a38fd4ce96c0e08bb7415c1d2c5f1e6af8e83f600a3aeff7457cbde9da6" => :yosemite
    sha256 "9d95f0a35e4b245925f2b2a430a28b261c1b49659468d59a544ad28947fe34ad" => :mavericks
  end

  keg_only :provided_by_osx, <<-EOS.undent
    Software that uses TeX, such as lilypond and octave, require a newer version
    of these files.
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
    assert_match /Hello World!/, File.read("test.info")
  end
end
