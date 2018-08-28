class Re2c < Formula
  desc "Generate C-based recognizers from regular expressions"
  homepage "http://re2c.org"
  url "https://github.com/skvadrik/re2c/releases/download/1.1/re2c-1.1.tar.gz"
  sha256 "925d1ebc65c16ba17f59e438621c145330c952a02a4bb2d333a428c56e94d8a7"

  bottle do
    cellar :any_skip_relocation
    sha256 "687cd0c2fb9d5b6c7993083eb70e5b4746c81c86f6b4f3912989569653f12c7f" => :high_sierra
    sha256 "191a467d5d45f6264bc5bf4db7ad9012cb7e91a06b303371cef5801871c218f6" => :sierra
    sha256 "2ce041b261549a7760303365af3300d41c0dd1a4f7e65177c04bdeed51447066" => :el_capitan
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
