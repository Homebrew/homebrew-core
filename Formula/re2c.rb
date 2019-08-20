class Re2c < Formula
  desc "Generate C-based recognizers from regular expressions"
  homepage "https://re2c.org"
  url "https://github.com/skvadrik/re2c/releases/download/1.2.1/re2c-1.2.1.tar.xz"
  sha256 "1a4cd706b5b966aeffd78e3cf8b24239470ded30551e813610f9cd1a4e01b817"

  bottle do
    cellar :any_skip_relocation
    sha256 "cf04c6f2c4631614ddca8391e0d443428b92bff5858d0a87150eb26366e9a431" => :mojave
    sha256 "58a4fa0867037c92f9c9c29159f64a4435cdd2af9f76112213fc67ce47f94d5d" => :high_sierra
    sha256 "71a1e1aa49f524d87452641a05f29f117d86d6f87bac19a5bdfed96b3ca8aedf" => :sierra
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
