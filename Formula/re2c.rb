class Re2c < Formula
  desc "Generate C-based recognizers from regular expressions"
  homepage "https://re2c.org"
  url "https://github.com/skvadrik/re2c/releases/download/3.0/re2c-3.0.tar.xz"
  sha256 "b3babbbb1461e13fe22c630a40c43885efcfbbbb585830c6f4c0d791cf82ba0b"
  license :public_domain

  bottle do
    sha256 arm64_ventura:  "2a256f437d69f1ccf09e970303f1386ac46986ccd92f8876ab342bc5b56b0f57"
    sha256 arm64_monterey: "ca5d1ca897627eecd7b5b6870eef54f2d86081131d25b14e05e3425f521df860"
    sha256 arm64_big_sur:  "f776b0b800fa7915f5fe4868cb33d4eab2adcbd42c2840d4c0ba3f6e1a006e86"
    sha256 ventura:        "223364842afd8c24a2bd2210483f01a15ee75f70aba1dec87fe04a9849924a7c"
    sha256 monterey:       "51916b41839d4154a21b1f3895c21c87486eb119316c7f302f1384251dbc7d77"
    sha256 big_sur:        "d64db8c358174100db90153d2e9a2554d3aaabd5a9107e84bf7a9538932900b1"
    sha256 catalina:       "6b25dc91a91de111fe0b033770d8ddc095cf5fc6c81a4c67ad4e43cf57fe8758"
    sha256 x86_64_linux:   "096ce665489902beba1c057fb899494c21915e28b5309069123cdd7ee426caa5"
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
