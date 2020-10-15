class Re2c < Formula
  desc "Generate C-based recognizers from regular expressions"
  homepage "https://re2c.org"
  url "https://github.com/skvadrik/re2c/releases/download/2.0.3/re2c-2.0.3.tar.xz"
  sha256 "b2bc1eb8aaaa21ff2fcd26507b7e6e72c5e3d887e58aa515c2155fb17d744278"
  license :public_domain

  bottle do
    sha256 "9c833a1f7a3c31b73a18bb63a76bfedcb6645242aaf6d567cd0d8603d8ac47a2" => :catalina
    sha256 "3ed464eb3353504f1a931912c498b3faa8289d1842a9e60055c1483cc2e76bd4" => :mojave
    sha256 "62a37784b94c5406ed7c4bcd20d76836dff43d3fb90798a144d9408678ddc71e" => :high_sierra
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
