class Re2c < Formula
  desc "Generate C-based recognizers from regular expressions"
  homepage "https://re2c.org"
  url "https://github.com/skvadrik/re2c/releases/download/1.2.1/re2c-1.2.1.tar.xz"
  sha256 "1a4cd706b5b966aeffd78e3cf8b24239470ded30551e813610f9cd1a4e01b817"

  bottle do
    sha256 "2d9f14907212e68580afa38eae450c8c0a9157169a1fd00e6faf27f872134433" => :mojave
    sha256 "3a39e5869772c6774b53c22e59d5e4fd195349962aedcf65731cd6eb0cb54e9d" => :high_sierra
    sha256 "20d4035575168abd66a65bfda9e93efa4d2aae6ef6597f1bd66ffa3028151dff" => :sierra
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
