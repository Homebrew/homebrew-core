class Utf8proc < Formula
  desc "Clean C library for processing UTF-8 Unicode data"
  homepage "https://julialang.org/utf8proc/"
  url "https://github.com/JuliaLang/utf8proc/archive/v2.1.tar.gz"
  sha256 "241c409d8f6c0e4f332e41f3f1bd39552e36dcc00084fbacd03682b2969a301e"

  bottle do
    cellar :any
    sha256 "db3e01e947e412f480fd418562e78f07e9d92faa14b2bca453d445fc60156132" => :sierra
    sha256 "f43d571eae1da6c1b2945cb6059234f4ed3879c911aa810543aae767f1e897ca" => :el_capitan
    sha256 "9229016dc8952dd531ca8053fe5e5295c241cbb1cb93b02c7a2e0e550857c454" => :yosemite
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
