class Re2c < Formula
  desc "Generate C-based recognizers from regular expressions"
  homepage "https://re2c.org"
  url "https://github.com/skvadrik/re2c/releases/download/4.0.2/re2c-4.0.2.tar.xz"
  sha256 "5e52ce0e26326115e41bc45d34dc2d5e10f2e44ed3a413fa2a826aa3500c8d56"
  license :public_domain

  bottle do
    sha256 arm64_sequoia: "0e9318e109940f1e21d942a0433cefb90b79ba64316dc8569854a47730842c1d"
    sha256 arm64_sonoma:  "3f368dc30f1a17c838097d5c7682eaee094e10d2662a36a5fd85e4aabfae6bfd"
    sha256 arm64_ventura: "43766bf660043fc50ace1ada1722496d278342f218d7c6206862b310803486c4"
    sha256 sonoma:        "78747cac6e1a5ba87c3f352f416d4d773f9f3a79bc3182262796e84de961069d"
    sha256 ventura:       "76716f8f7c70753598d5dfe910e5ca14db2efff4ea85431e302dab20e2117aca"
    sha256 x86_64_linux:  "42feeecfbb4dac152d1a8510ef76edcf0896b6870f7bed947b8769e25d25acf5"
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
