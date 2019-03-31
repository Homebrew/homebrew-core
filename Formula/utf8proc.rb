class Utf8proc < Formula
  desc "Clean C library for processing UTF-8 Unicode data"
  homepage "https://juliastrings.github.io/utf8proc/"
  url "https://github.com/JuliaStrings/utf8proc/archive/v2.3.0.tar.gz"
  sha256 "c0265a49b59bab95481cab1ae958ba034dedc47ad58676a61f5de1fa9347930e"

  bottle do
    cellar :any
    sha256 "8a9d861ff87e8d8c2cdd8305e5eabbd210601526367e8a22e1316a1d7e2a9876" => :mojave
    sha256 "47a584237de1a359da3b43d5fc6f0b5b194404a28e2ca457ba2bcd9c105ebe67" => :high_sierra
    sha256 "8973ec51e6eb2467943341c1591a59abc62e3078530e792236609f97a321f99f" => :sierra
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
