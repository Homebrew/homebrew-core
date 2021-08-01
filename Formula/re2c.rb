class Re2c < Formula
  desc "Generate C-based recognizers from regular expressions"
  homepage "https://re2c.org"
  url "https://github.com/skvadrik/re2c/releases/download/2.2/re2c-2.2.tar.xz"
  sha256 "0fc45e4130a8a555d68e230d1795de0216dfe99096b61b28e67c86dfd7d86bda"
  license :public_domain

  bottle do
    sha256 arm64_big_sur: "66d9bb165a554be7a2eda77188b965378ef3de63d73caa026019295edf21a517"
    sha256 big_sur:       "92542633618857c419aad645a7b772bf42cae681a7e19e351e1d9b49c95fdac5"
    sha256 catalina:      "5d03da5d1265e3169f34f5c70a08f96dbee0dc0e617363f16db2a516e2f5c76b"
    sha256 mojave:        "7235fbeb0e362988b5137e7c3be85e9af7742848bff96f69135d38d9ebb1bc04"
    sha256 x86_64_linux:  "ab7b995d963a52008acc12c0a389074ad00b84eb13c16a0ad70aa94343c9d928"
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
