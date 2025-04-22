class Re2c < Formula
  desc "Generate C-based recognizers from regular expressions"
  homepage "https://re2c.org/"
  url "https://github.com/skvadrik/re2c/releases/download/4.1/re2c-4.1.tar.xz"
  sha256 "cd7d9bbadb3f04f20da25e20e155655de57beef48e0807266938069f0e322e8b"
  license :public_domain

  bottle do
    sha256 arm64_sequoia: "e3dd89bc2150ed75763ad5a2c065a3d658a545e3f9ddca3661aa727d9572a9d9"
    sha256 arm64_sonoma:  "dad8b1b1a90721ceea8143455d47cb372b0ed3db916b68f08345f1f6e4cea67b"
    sha256 arm64_ventura: "22c9bc70ce9c8a0573ea42021ffa52c8ee464f52a623dfc9457a2dce13d27e67"
    sha256 sonoma:        "2a8c4aef6f2606e8576136319850476b2ddbd626b3a5227893c0795dcf2d14de"
    sha256 ventura:       "4aa7eff050e9987c7cf2f37b9fdd2a4a666a40d9854dc27f56ac95f8f12221f9"
    sha256 arm64_linux:   "c89d2fb8378f3ad8b6073128229fb13dae177ed62fdf653b68c02b2b5fc10909"
    sha256 x86_64_linux:  "2c8af1a87cb6fc4e7ce2ee4b02c83931002f7a6a6240b6462d63525d73b4c6d8"
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
