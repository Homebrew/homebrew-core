class Re2c < Formula
  desc "Generate C-based recognizers from regular expressions"
  homepage "http://re2c.org"
  url "https://github.com/skvadrik/re2c/releases/download/1.0.2/re2c-1.0.2.tar.gz"
  sha256 "b0919585b50095a00e55b99212a81bc67c5fab61d877aca0d9d061aff3093f52"

  bottle do
    cellar :any_skip_relocation
    sha256 "25df7de4cc1b76ee7847452b1bd4943854e177a0018e9d44b60a3564767059d4" => :high_sierra
    sha256 "37ed44e39dc5fc334383fa1288713ba050f7201b88f46f2e06214d705ebc6aa7" => :sierra
    sha256 "874c58f6fffdbc854ccdf28d9dfaeaab861850731a2a1cdea9c5f0c11f11888e" => :el_capitan
    sha256 "a64bf6f56f3bed9c64318f1c590892e53b103f4372eee3e41af7916ecbfde05c" => :yosemite
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
