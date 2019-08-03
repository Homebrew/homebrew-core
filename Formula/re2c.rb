class Re2c < Formula
  desc "Generate C-based recognizers from regular expressions"
  homepage "http://re2c.org"
  url "https://github.com/skvadrik/re2c/releases/download/1.2/re2c-1.2.tar.xz"
  sha256 "000b7b8c3aeaf61fb492b58352574a5777518336fc96071f4d083a7397be841c"

  bottle do
    cellar :any_skip_relocation
    sha256 "51b7b472896a0469a279710ba252ad175ae0879a1a2df5b01af3483d27b2b2ab" => :mojave
    sha256 "acb0d0eebcc5bdc18571a551c9e8bb9bf01a60e0fa97b6ca29773059e9bcceec" => :high_sierra
    sha256 "e1809196ec0d125c664e46404a7aae0ec8a2c778e1e1db7036f75a772d62edee" => :sierra
    sha256 "3c419cef2ce49afffa70662ce865bbde4f58844cf9752ccb1390c10c9e47a2d1" => :el_capitan
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      unsigned int stou (const char * s)
      {
      #   define YYCTYPE char
          const YYCTYPE * YYCURSOR = s;
          unsigned int result = 0;

          for (;;)
          {
              /*!re2c
                  re2c:yyfill:enable = 0;

                  "\x00" { return result; }
                  [0-9]  { result = result * 10 + c; continue; }
              */
          }
      }
    EOS
    system bin/"re2c", "-is", testpath/"test.c"
  end
end
