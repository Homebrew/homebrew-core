class Re2c < Formula
  desc "Generate C-based recognizers from regular expressions"
  homepage "http://re2c.org"
  url "https://github.com/skvadrik/re2c/releases/download/1.0/re2c-1.0.tar.gz"
  sha256 "fee4a9f244dcf5c8109a605163976087943560370153abda89677009b884855b"

  bottle do
    cellar :any_skip_relocation
    sha256 "c11f57cdde394a072ddb8952ebaaea37aafd3c8b6ac304d7bcb956a46f7818e3" => :sierra
    sha256 "5ca925ec9bedadb50237ce862d7aeac99a55af1cb5468c47af711dcdea7a1256" => :el_capitan
    sha256 "9050cac314fe497b42b42b23e52043973b0f800c1ab39a2791482ab6cdd254d6" => :yosemite
  end

  # Upstream commit from 11 Aug 2017 "Fixed #193: 1.0 build failure on macOS:
  # error: calling a private constructor of class 're2c::Rule'"
  patch :p2 do
    url "https://github.com/skvadrik/re2c/commit/2aae99cd.patch?full_index=1"
    sha256 "87786c33864f0b71fb2be68da3dcef7c70924c6d59248911180b1c3b153459ef"
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
