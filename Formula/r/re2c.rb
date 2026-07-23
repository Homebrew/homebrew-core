class Re2c < Formula
  desc "Generate C-based recognizers from regular expressions"
  homepage "https://re2c.org/"
  url "https://github.com/skvadrik/re2c/releases/download/4.5.1/re2c-4.5.1.tar.xz"
  sha256 "ffea067c11aa668bcb42885be6e6cd000302000b7747d2bb213299ec66b7864e"
  license :public_domain

  bottle do
    sha256 arm64_tahoe:   "487a30e2e00d20a38b1aac7712f539b66622dea1023ec323457aac77b1fa546a"
    sha256 arm64_sequoia: "ec48f3992aa27470291114b53b4642a37bdb731812019ee1ac7f74cc52810d1c"
    sha256 arm64_sonoma:  "32ae2aebfbce16d7aee409fc41fd7fca04a0a6bface9d56a72d6b6428b9fbc09"
    sha256 sonoma:        "71371b5a39e4f52e044f03e8fad0cd7003592e80c2e7714f83b7797a6ab74ce3"
    sha256 arm64_linux:   "65b1998210ef8d466401539c0961839ef5e301cb4b2e6463c9d307c5c88711f6"
    sha256 x86_64_linux:  "ab784e322c45193e3c13283466bd751d55d88f185682b993dd7c3b799b25c65c"
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
