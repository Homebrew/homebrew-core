class Re2c < Formula
  desc "Generate C-based recognizers from regular expressions"
  homepage "https://re2c.org"
  url "https://github.com/skvadrik/re2c/releases/download/2.2/re2c-2.2.tar.xz"
  sha256 "0fc45e4130a8a555d68e230d1795de0216dfe99096b61b28e67c86dfd7d86bda"
  license :public_domain

  bottle do
    sha256 arm64_monterey: "4a95c3cdce967731404c853fe7c56f2e37c9602710af795987780acf5e30c383"
    sha256 arm64_big_sur:  "9f32566ee362b6ebf98674a7bc9d642c03a120c105b32b28efd16ec1fdfe1dbc"
    sha256 monterey:       "5ae23f0895217f59237686bdbfc4c2e4c40d4d0ac1e6e45f5032e874c9f9f3ba"
    sha256 big_sur:        "622c04bf38ad6f7ff7f9ca272cf9dcbde186f0b16e3e51eed1ffc108db56adb7"
    sha256 catalina:       "8dd19c7d8532026141d42d6893faf18e86b97053fd113f9f30a1271662108e25"
    sha256 mojave:         "7092db76fdd568e0c162ffe2066e8318ec4102aab85b361098908ca49f535a0e"
    sha256 x86_64_linux:   "f8ae38af6e0ef9a4131174fc66750498c1a3cca66e896ef2392632ef16a0e9a4"
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
