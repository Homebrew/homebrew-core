class Utf8proc < Formula
  desc "Clean C library for processing UTF-8 Unicode data"
  homepage "http://julialang.org/utf8proc/"
  url "https://github.com/JuliaLang/utf8proc/archive/v2.0.1.tar.gz"
  sha256 "39b8dbb900756fb682fa06903c002b4646dfc65339f7ecb42743b560a328b515"

  bottle do
    cellar :any
    sha256 "d476b296c8998414e03daefab5c0afaa9705d7eb52f1a9e859c652d33d5aa192" => :el_capitan
    sha256 "85a5558af9090c81ed00b771843399812773649f66a2351b0a9551c13badc798" => :yosemite
    sha256 "396a3b43e04bbd02bd2d9629b1fa2a74f4cce09e66a437cec530d63c6e3c903a" => :mavericks
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
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
