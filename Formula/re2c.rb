class Re2c < Formula
  desc "Generate C-based recognizers from regular expressions"
  homepage "http://re2c.org"
  url "https://github.com/skvadrik/re2c/releases/download/1.0.1/re2c-1.0.1.tar.gz"
  sha256 "605058d18a00e01bfc32aebf83af35ed5b13180b4e9f279c90843afab2c66c7c"

  bottle do
    cellar :any_skip_relocation
    sha256 "ee051a3865e43becdbb348397572608bd1d35598e1bc981d8735fb1c60034528" => :sierra
    sha256 "8c5417b16cb78d0b8060132799727850ac0201095e7917d4e627f2ae67098d0d" => :el_capitan
    sha256 "4e2773bf57db0dd1c0442bcbb0899cfc85db5c22096feddb76341650f1042e40" => :yosemite
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
