class Texinfo < Formula
  desc "Official documentation format of the GNU project"
  homepage "https://www.gnu.org/software/texinfo/"
  url "https://ftp.gnu.org/gnu/texinfo/texinfo-6.3.tar.xz"
  mirror "https://ftpmirror.gnu.org/texinfo/texinfo-6.3.tar.xz"
  sha256 "246cf3ffa54985118ec2eea2b8d0c71b92114efe6282c2ae90d65029db4cf93a"

  bottle do
    sha256 "ddcd68fb9757b11e5b8ea39e22996815aaf763b05711e21e17e45ba4ea68741a" => :sierra
    sha256 "f0fcad49893de2e4167658cf13dc6b6ef0a458e764637b63ff2ba623959e4928" => :el_capitan
    sha256 "91d4ca04c9b42751af95b6114b477afe01221758ba152763d4177332a67399d9" => :yosemite
    sha256 "5990ad5d13570b6991156fa2db000dfe25273614c27912d46d8802577d85fe8c" => :mavericks
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
