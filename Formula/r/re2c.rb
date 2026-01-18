class Re2c < Formula
  desc "Generate C-based recognizers from regular expressions"
  homepage "https://re2c.org/"
  url "https://github.com/skvadrik/re2c/releases/download/4.4/re2c-4.4.tar.xz"
  sha256 "6b6b865924447ef992d5db4e52fb9307e5f65f26edd43efa91395da810f4280a"
  license :public_domain

  bottle do
    sha256 arm64_tahoe:   "af83292063fa573b911e9648f904a74f99a77c96ceb7a4e18932a9160586abc6"
    sha256 arm64_sequoia: "5d8667be9712cb78ccd96df1dff21abf885eb3eda54ffce3bbff0faa9734c041"
    sha256 arm64_sonoma:  "53bedd957c9398e6806485f3dcddb118955c012d2d25929c5ac85fa642a5eb7a"
    sha256 sonoma:        "8ad2a8ca471842c3bb8cd563898c13b5fe810230f510dfcb3c333f8e847523f9"
    sha256 arm64_linux:   "8eac97303d451c3ec5d625869977308bf3a6948ea143ce6c1d2609ff021cc1cd"
    sha256 x86_64_linux:  "f73e0f74319220a3aeaeeec8765a5116d6e4d30468929df37385d20f0a82e151"
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
