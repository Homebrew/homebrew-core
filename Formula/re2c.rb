class Re2c < Formula
  desc "Generate C-based recognizers from regular expressions"
  homepage "https://re2c.org"
  url "https://github.com/skvadrik/re2c/releases/download/2.0.3/re2c-2.0.3.tar.xz"
  sha256 "b2bc1eb8aaaa21ff2fcd26507b7e6e72c5e3d887e58aa515c2155fb17d744278"
  license :public_domain

  bottle do
    sha256 "322bebea8b7ef36ba9fa67f8eb244720e703e3caa61c4cb0c3f69233844a7249" => :catalina
    sha256 "c4e54f2eebcc3bf581d8b0a794041f6cbbbdc0148856d2061069396412fb080f" => :mojave
    sha256 "070dcf3fdca558cb8aac21bc3db638faba8aaadcacd199f459a4bef743d87ecd" => :high_sierra
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
