class Texi2html < Formula
  desc "Convert TeXinfo files to HTML"
  homepage "https://www.nongnu.org/texi2html/"
  url "https://download.savannah.gnu.org/releases/texi2html/texi2html-5.0.tar.gz"
  sha256 "e60edd2a9b8399ca615c6e81e06fa61946ba2f2406c76cd63eb829c91d3a3d7d"

  bottle do
    rebuild 1
    sha256 "cf02c2e593ded1e5b3ffaf04b9dc8a474ab36633ed40c50454c98a3adb5a7908" => :mojave
    sha256 "5259ab2074f122f4725058d2477233add1a32c30d385680276b06c11e06bc67f" => :high_sierra
    sha256 "5259ab2074f122f4725058d2477233add1a32c30d385680276b06c11e06bc67f" => :sierra
    sha256 "5259ab2074f122f4725058d2477233add1a32c30d385680276b06c11e06bc67f" => :el_capitan
  end

  depends_on "gettext"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--mandir=#{man}", "--infodir=#{info}"
    chmod 0755, "./install-sh"
    system "make", "install"
  end

  test do
    (testpath/"test.texinfo").write <<~EOS
      @ifnottex
      @node Top
      @top Hello World!
      @end ifnottex
      @bye
    EOS
    system "#{bin}/texi2html", "test.texinfo"
    assert_match /Hello World!/, File.read("test.html")
  end
end
