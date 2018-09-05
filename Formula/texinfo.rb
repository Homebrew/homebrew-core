class Texinfo < Formula
  desc "Official documentation format of the GNU project"
  homepage "https://www.gnu.org/software/texinfo/"
  url "https://ftp.gnu.org/gnu/texinfo/texinfo-6.5.tar.xz"
  mirror "https://ftpmirror.gnu.org/texinfo/texinfo-6.5.tar.xz"
  sha256 "77774b3f4a06c20705cc2ef1c804864422e3cf95235e965b1f00a46df7da5f62"

  bottle do
    sha256 "641a738c35fd055e7c73df2542ae0a08a085c235682432adda41c607271b9fd1" => :mojave
    sha256 "a38bf65a736b3e64843eecf9a3ad6029cb6538ff09261072c2cd339598ae2f8d" => :high_sierra
    sha256 "ad81d72c79b14e1ed7beed59202514817fde7d12cc4e37657fdc689bb081a2e2" => :sierra
    sha256 "e3099c5bc15295e7cadb2ce8b5f89d8983a8599b8d8602277aae23b9ff3482b1" => :el_capitan
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
