class Spandsp < Formula
  desc "DSP functions library for telephony"
  homepage "https://www.soft-switch.org/"
  url "https://www.soft-switch.org/downloads/spandsp/spandsp-0.0.6.tar.gz"
  sha256 "cc053ac67e8ac4bb992f258fd94f275a7872df959f6a87763965feabfdcc9465"
  revision 1

  bottle do
    cellar :any
    sha256 "d38722be71b9d6b3311ee51cb85bc406b2bc34eaf5741851c3b4ed432aecacf2" => :mojave
    sha256 "0b4bb6795c931452181252754da3db80189e6557c344e743296de823cb711efa" => :high_sierra
    sha256 "c0b8349525680304f99e464d328df804279be85398969974f2b708e5167c89fe" => :sierra
    sha256 "428120be3841ca77961f2d19fe8f98f1615972db4f568e3cfa2c0a44cae44e77" => :el_capitan
    sha256 "65fd095ea758180f18ca9c39864dbd3432115610b0db2439dbc923d3c0002f7b" => :yosemite
  end

  depends_on "libtiff"

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #define SPANDSP_EXPOSE_INTERNAL_STRUCTURES
      #include <spandsp.h>

      int main()
      {
        t38_terminal_state_t t38;
        memset(&t38, 0, sizeof(t38));
        return (t38_terminal_init(&t38, 0, NULL, NULL) == NULL) ? 0 : 1;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lspandsp", "-o", "test"
    system "./test"
  end
end
