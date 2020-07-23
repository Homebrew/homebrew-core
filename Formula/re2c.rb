class Re2c < Formula
  desc "Generate C-based recognizers from regular expressions"
  homepage "https://re2c.org"
  url "https://github.com/skvadrik/re2c/releases/download/2.0/re2c-2.0.tar.xz"
  sha256 "89a9d7ee14be10e3779ea7b2c8ea4a964afce6e76b8dbcd5479940681db46d20"

  bottle do
    sha256 "374376ae451fe0e6ca93f17634e6353e8503cffa16018fbe44007997b865965d" => :catalina
    sha256 "3cb716f9bcb81ad81cafc6e2e5a5be444caa297cec939213bcf2e805fb65f778" => :mojave
    sha256 "7d9b2456469379900fc2abddc732710b822241a8a7bd2f734766a18b47b704a9" => :high_sierra
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
