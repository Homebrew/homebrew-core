class Re2c < Formula
  desc "Generate C-based recognizers from regular expressions"
  homepage "http://re2c.org"
  url "https://github.com/skvadrik/re2c/releases/download/1.0.3/re2c-1.0.3.tar.gz"
  sha256 "cf56e0de3f335f6a22d3e8c06b8b450d858a4e7875ea1b01c9233e084b90cb52"

  bottle do
    cellar :any_skip_relocation
    sha256 "5fddd5f5bb6c0c5a935b8133f83a7242ff1e311dc954124caa4d7dad3f425318" => :mojave
    sha256 "b10d4531a882667d808476d4a5cf101407b95f1dd9715f598f16dc7072c73ef4" => :high_sierra
    sha256 "0961b75960ad7cdc1f7ef7199afaa4d3f1299cc3e61a99f40ea55318d071d676" => :sierra
    sha256 "7242e7bddb6c7b6642a19b534a084f5c4e78970e3d9ec603be7ff4bf7e4c0981" => :el_capitan
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
