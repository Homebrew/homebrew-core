class Re2c < Formula
  desc "Generate C-based recognizers from regular expressions"
  homepage "https://re2c.org/"
  url "https://github.com/skvadrik/re2c/releases/download/4.3.1/re2c-4.3.1.tar.xz"
  sha256 "5f5e8a618960f68bb46ee8728ecd4132e1275b595cfc7a48476f977afd01d0cc"
  license :public_domain

  bottle do
    sha256 arm64_tahoe:   "3b3045a151ba5ecc3fc5a483da31d4d4196b9596bf11e957e5d723dd56421938"
    sha256 arm64_sequoia: "7289acce007b056fa8dbac5dfe50eb6da95aa48ccd2d5e1db3cb137a4f48d6d6"
    sha256 arm64_sonoma:  "6c3408c26e8d725a340a0e0345d2c2f722e461691ca7a4a81166fcc3df5ca1bb"
    sha256 sonoma:        "379ea182c72aac34d4cec192c66e54214a3ef500d31287f94b871970882ecd79"
    sha256 arm64_linux:   "5dc20441f850b52ad20fa0e82bfd7e9b37d3ead3ac571ee499744eef6cb955de"
    sha256 x86_64_linux:  "03f187149999389aa0368834e004ed6c5d38e2aaafe3e3f70710e446d5d21b40"
  end

  uses_from_macos "python" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C
    system bin/"re2c", "-is", testpath/"test.c"
  end
end
