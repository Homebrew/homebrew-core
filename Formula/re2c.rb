class Re2c < Formula
  desc "Generate C-based recognizers from regular expressions"
  homepage "https://re2c.org"
  url "https://github.com/skvadrik/re2c/releases/download/2.1.1/re2c-2.1.1.tar.xz"
  sha256 "036ee264fafd5423141ebd628890775aa9447a4c4068a6307385d7366fe711f8"
  license :public_domain

  bottle do
    sha256 arm64_big_sur: "4c1a0fb64840fbeb1aded100c88ce4cb8344f592a1877706199524151c9a5d1a"
    sha256 big_sur:       "7d0b8c1807aecfde713682242888df7083d5007d67940cdf5fd7e78317f72e3e"
    sha256 catalina:      "9c833a1f7a3c31b73a18bb63a76bfedcb6645242aaf6d567cd0d8603d8ac47a2"
    sha256 mojave:        "3ed464eb3353504f1a931912c498b3faa8289d1842a9e60055c1483cc2e76bd4"
    sha256 high_sierra:   "62a37784b94c5406ed7c4bcd20d76836dff43d3fb90798a144d9408678ddc71e"
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
