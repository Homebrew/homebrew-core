class Re2c < Formula
  desc "Generate C-based recognizers from regular expressions"
  homepage "https://re2c.org/"
  url "https://github.com/skvadrik/re2c/releases/download/4.2/re2c-4.2.tar.xz"
  sha256 "c9dc2b24f340d135a07a1ac63ff53f7f8f74997fed5a4e9132a64050dbc3da1f"
  license :public_domain

  bottle do
    sha256 arm64_sequoia: "faef128b02d761e48c62e2731aa58333833d1f486d95485b5469da728fbb5a34"
    sha256 arm64_sonoma:  "22cf1c6043fc18b92f2a889d56becca40999dccbd19af38002ca044d7a1c6f93"
    sha256 arm64_ventura: "5172403e61e00a27d0cb0c4076014c4e12142c0bd2796a0f1dd8faa4f0432b43"
    sha256 sonoma:        "0dd252d6d34f358ef7b32fdd85eb418cbb794b6d7cb9975e7c6682da0c3a15c0"
    sha256 ventura:       "288ca32046a3739b6544615530fa8ece4b914755469c515cdb405dc05f5d4c60"
    sha256 arm64_linux:   "c975ffc6ed5497d01308a2ecef95592d2917724e4efb1bb6e7b8d361f71d187d"
    sha256 x86_64_linux:  "82d080773dbf82587b721cbd4eb1036f5f11d0eb7c4944e9d18a357138d73516"
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
