class Re2c < Formula
  desc "Generate C-based recognizers from regular expressions"
  homepage "https://re2c.org"
  url "https://github.com/skvadrik/re2c/releases/download/2.1.1/re2c-2.1.1.tar.xz"
  sha256 "036ee264fafd5423141ebd628890775aa9447a4c4068a6307385d7366fe711f8"
  license :public_domain

  bottle do
    sha256 arm64_big_sur: "66d9bb165a554be7a2eda77188b965378ef3de63d73caa026019295edf21a517"
    sha256 big_sur:       "92542633618857c419aad645a7b772bf42cae681a7e19e351e1d9b49c95fdac5"
    sha256 catalina:      "5d03da5d1265e3169f34f5c70a08f96dbee0dc0e617363f16db2a516e2f5c76b"
    sha256 mojave:        "7235fbeb0e362988b5137e7c3be85e9af7742848bff96f69135d38d9ebb1bc04"
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
