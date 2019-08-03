class Re2c < Formula
  desc "Generate C-based recognizers from regular expressions"
  homepage "http://re2c.org"
  url "https://github.com/skvadrik/re2c/releases/download/1.2/re2c-1.2.tar.xz"
  sha256 "000b7b8c3aeaf61fb492b58352574a5777518336fc96071f4d083a7397be841c"

  bottle do
    cellar :any_skip_relocation
    sha256 "cf04c6f2c4631614ddca8391e0d443428b92bff5858d0a87150eb26366e9a431" => :mojave
    sha256 "58a4fa0867037c92f9c9c29159f64a4435cdd2af9f76112213fc67ce47f94d5d" => :high_sierra
    sha256 "71a1e1aa49f524d87452641a05f29f117d86d6f87bac19a5bdfed96b3ca8aedf" => :sierra
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
