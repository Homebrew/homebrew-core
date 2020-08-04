class Re2c < Formula
  desc "Generate C-based recognizers from regular expressions"
  homepage "https://re2c.org"
  url "https://github.com/skvadrik/re2c/releases/download/2.0.1/re2c-2.0.1.tar.xz"
  sha256 "aef8b50bb75905b2d55a7236380c0efdc756fa077fe16d808aaacbb10fb53531"
  # re2c is in the public domain
  license "Unlicense"

  bottle do
    sha256 "617a92159d2aefb4b454b81496c5c8615f27a303249c11f5ac40f887ee8ca392" => :catalina
    sha256 "d9ae7d2af374b4c57e106685b19998216265d651e8e270af822531f47c3ae44a" => :mojave
    sha256 "69d41987ea6a3250d7f4d5ff559013b20e055c99fb892cf24a14b131724515e5" => :high_sierra
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
