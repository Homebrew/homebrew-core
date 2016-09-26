class Utf8proc < Formula
  desc "Clean C library for processing UTF-8 Unicode data"
  homepage "http://julialang.org/utf8proc/"
  url "https://github.com/JuliaLang/utf8proc/archive/v2.0.2.tar.gz"
  sha256 "e69ca9a65225481d3ae6cdfad356f5ddd057a25e2ed9c0e7e7b35853c38a1b90"

  bottle do
    cellar :any
    sha256 "e0dd57a0dc6fd530a9519bf54fd3823879438b57b5a599adeae196f66984b541" => :sierra
    sha256 "1ceb4dfa21540ec620c0e6b04d2242aa5fc39ab8da1a231182317ebd08eff9e2" => :el_capitan
    sha256 "eb5434e4817951b5d57e1f7d3e926924f0b38036e79410d76c6a652f67701cfd" => :yosemite
    sha256 "2acce240bd4abeb3e931177dfaaa93637d43faff7f01305df1be66d5cd01dff5" => :mavericks
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
