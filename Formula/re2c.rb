class Re2c < Formula
  desc "Generate C-based recognizers from regular expressions"
  homepage "http://re2c.org"
  url "https://github.com/skvadrik/re2c/releases/download/1.0.1/re2c-1.0.1.tar.gz"
  sha256 "605058d18a00e01bfc32aebf83af35ed5b13180b4e9f279c90843afab2c66c7c"

  bottle do
    cellar :any_skip_relocation
    sha256 "c11f57cdde394a072ddb8952ebaaea37aafd3c8b6ac304d7bcb956a46f7818e3" => :sierra
    sha256 "5ca925ec9bedadb50237ce862d7aeac99a55af1cb5468c47af711dcdea7a1256" => :el_capitan
    sha256 "9050cac314fe497b42b42b23e52043973b0f800c1ab39a2791482ab6cdd254d6" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
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
