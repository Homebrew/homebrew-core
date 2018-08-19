class Utf8proc < Formula
  desc "Clean C library for processing UTF-8 Unicode data"
  homepage "https://juliastrings.github.io/utf8proc/"
  url "https://github.com/JuliaStrings/utf8proc/archive/v2.2.0.tar.gz"
  sha256 "3f8fd1dbdb057ee5ba584a539d5cd1b3952141c0338557cb0bdf8cb9cfed5dbf"

  bottle do
    cellar :any
    sha256 "59d0f3510a26a5c31c9954e9284ad82e863b0d6da00397094c9e26f442b49ec0" => :mojave
    sha256 "cdcd5132f9ae0bebe232c59e76d66f4a0cb6a4a26f37c94041a78fd214484348" => :high_sierra
    sha256 "dda62c99b48421dee34963e3be55e1db932227b21b4ab5005f268ff4e4f187c3" => :sierra
    sha256 "f7065fb123f7d5946ed5c55784d14069c54c1cef02982f28921018307cb86a99" => :el_capitan
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <string.h>
      #include <utf8proc.h>

      int main() {
        const char *version = utf8proc_version();
        return strnlen(version, sizeof("1.3.1-dev")) > 0 ? 0 : -1;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lutf8proc", "-o", "test"
    system "./test"
  end
end
